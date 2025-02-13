
library(flextable)
library(ggplot2)
library(dplyr)
library(gt)
library(officedown)
library(officer)

add_figure_caption <- function(bkm){
  run_autonum(seq_id = "Figure", pre_label = "Figure ", bkm = bkm, tnd = 1, tns = '.')
}

add_table_caption <- function(bkm){
  run_autonum(seq_id = "Table", pre_label = "Table ", bkm = bkm, tnd = 1, tns = '.')
}


library(knitr)
knit_print.flextable <- function (x, ...) {
  is_bookdown <- flextable:::is_in_bookdown()
  is_quarto <- flextable:::is_in_quarto()
  x <- flextable:::knitr_update_properties(x, bookdown = is_bookdown, quarto = is_quarto)
  if (is.null(knitr::pandoc_to())) {
    str <- flextable:::to_html(x, type = "table")
    str <- knitr:::asis_output(str)
  }
  else if (!is.null(getOption("xaringan.page_number.offset"))) {
    str <- knit_to_html:::knit_to_html(x, bookdown = FALSE, quarto = FALSE)
    str <- knitr:::asis_output(str, meta = html_dependencies_list(x))
  }
  else if (knitr:::is_html_output(excludes = "gfm")) {
    str <- knit_to_html:::knit_to_html(x, bookdown = is_bookdown, quarto = is_quarto)
    str <- knit_to_html:::raw_html(str, meta = html_dependencies_list(x))
  }
  else if (knitr:::is_latex_output()) {
    str <- flextable:::knit_to_latex(x, bookdown = is_bookdown, quarto = is_quarto)
    str <- flextable:::raw_latex(x = str, meta = unname(list_latex_dep(float = TRUE, 
                                                                       wrapfig = TRUE)))
  }
  else if (grepl("docx", knitr::opts_knit$get("rmarkdown.pandoc.to"))) {
    if (rmarkdown::pandoc_version() < numeric_version("2")) {
      stop("pandoc version >= 2 required for printing flextable in docx")
    }
    str <- flextable:::knit_to_wml(x, bookdown = is_bookdown, quarto = is_quarto)
    str <- gsub("</w:tbl>","</w:tbl><w:p></w:p>",str, fixed =  TRUE)
    str <- gsub('<w:pPr><w:pStyle w:val="Normal"/><w:jc w:val="left"/><w:pBdr><w:bottom w:val="none" w:sz="0" w:space="0" w:color="B7D1C3"/><w:top w:val="none" w:sz="0" w:space="0" w:color="B7D1C3"/><w:left w:val="none" w:sz="0" w:space="0" w:color="B7D1C3"/><w:right w:val="none" w:sz="0" w:space="0" w:color="B7D1C3"/></w:pBdr><w:spacing w:after="40" w:before="40" w:line="240"/><w:ind w:left="40" w:right="40" w:firstLine="0" w:firstLineChars="0"/></w:pPr>',
                '<w:pPr><w:pStyle w:val="Table-Heading"/><w:jc w:val="left"/><w:spacing w:after="40" w:before="40" w:line="240"/><w:ind w:left="40" w:right="40" w:firstLine="0" w:firstLineChars="0"/></w:pPr>', str, fixed = TRUE)
    str <- gsub('<w:pPr><w:pStyle w:val="Normal"/><w:jc w:val="left"/><w:pBdr><w:bottom w:val="none" w:sz="0" w:space="0" w:color="000000"/><w:top w:val="none" w:sz="0" w:space="0" w:color="000000"/><w:left w:val="none" w:sz="0" w:space="0" w:color="000000"/><w:right w:val="none" w:sz="0" w:space="0" w:color="000000"/></w:pBdr><w:spacing w:after="40" w:before="40" w:line="240"/><w:ind w:left="40" w:right="40" w:firstLine="0" w:firstLineChars="0"/></w:pPr>',
                '<w:pPr><w:pStyle w:val="Table-Text"/><w:jc w:val="left"/><w:spacing w:after="40" w:before="40" w:line="240"/><w:ind w:left="40" w:right="40" w:firstLine="0" w:firstLineChars="0"/></w:pPr>', str, fixed = TRUE)
    str <- knitr:::asis_output(str)
  }
  else if (grepl("pptx", knitr::opts_knit$get("rmarkdown.pandoc.to"))) {
    if (rmarkdown::pandoc_version() < numeric_version("2.4")) {
      stop("pandoc version >= 2.4 required for printing flextable in pptx")
    }
    str <- flextable:::knit_to_pml(x)
    str <- knitr:::asis_output(str)
  }
  else {
    plot_counter <- getFromNamespace("plot_counter", "knitr")
    in_base_dir <- getFromNamespace("in_base_dir", "knitr")
    tmp <- fig_path("png", number = plot_counter())
    in_base_dir({
      dir.create(dirname(tmp), showWarnings = FALSE, recursive = TRUE)
      save_as_image(x, path = tmp, expand = 0)
    })
    str <- include_graphics(tmp)
  }
  str
}

registerS3method(
  "knit_print", 'flextable', knit_print.flextable, 
  envir = asNamespace("flextable") 
  # important to overwrite {flextable}s knit_print
)



knit_print.gt_tbl <- function (x, ..., inline = FALSE) {
  if (gt:::knitr_is_rtf_output()) {
    x <- gt:::as_rtf(x)
  }
  else if (knitr::is_latex_output()) {
    x <- gt:::as_latex(x)
  }
  else if (gt:::knitr_is_word_output()) {
    str <- gsub("</w:tbl>","</w:tbl><w:p></w:p>", as_word(x), fixed = TRUE)
    x <- knitr::asis_output(paste("\n\n``````{=openxml}", str, 
                                  "``````\n\n", sep = "\n"))
  }
  else {
    x <- htmltools:::as.tags(x, ...)
  }
  knitr::knit_print(x, ..., inline = FALSE)
}



registerS3method(
  "knit_print", 'gt_tbl', knit_print.gt_tbl, 
  envir = asNamespace("gt") 
  # important to overwrite {gt}s knit_print
)


flextable2ICES <- function(x){
  x |>
    font(fontname = "Calibri", part = "all") |>
    fontsize(size = 8.5, part = "all") |>
    bold(part = "header") |>
    align(align = "left", part = "all") |>
    flextable::border(part = "all", 
                      border.top = fp_border(color = "black", width = 0.5),
                      border.bottom = fp_border(color = "black", width = 0.5)) |>
    bg(bg = "#B7D1C3", part = "header") |>
    style(pr_p=fp_par(padding = 2),
          part = "all") |>
    style(pr_p=fp_par(padding = 2,
                      border = fp_border(width = 0, col = "#B7D1C3", style = "none")),
          part = "header") |>
    fit_to_width(16/2.54)
}

