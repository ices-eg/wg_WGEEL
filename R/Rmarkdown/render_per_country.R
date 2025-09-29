
cou = 'FR'
rmarkdown::render("C:/workspace/wg_WGEEL/R/Rmarkdown/automatic_tables_graphs_per_country.Rmd",
                           output_format = 'bookdown::html_document2', 
                            output_file = paste0("2025/",cou,'.html'),
                             params =list(country=list(value= cou)))

cou = 'IT'
rmarkdown::render("C:/workspace/wg_WGEEL/R/Rmarkdown/automatic_tables_graphs_per_country.Rmd",
                  output_format = 'bookdown::html_document2', 
                  output_file = paste0("2025/",cou,'.html'),
                  params =list(country=list(value= cou)))


cou = 'SE'
rmarkdown::render("C:/workspace/wg_WGEEL/R/Rmarkdown/automatic_tables_graphs_per_country.Rmd",
       output_format = 'bookdown::html_document2', 
       output_file = paste0("2025/",cou,'.html'),
        params =list(country=list(value= cou),
         area= list(choices = "North Sea")))

cou = 'EE'
rmarkdown::render("C:/workspace/wg_WGEEL/R/Rmarkdown/automatic_tables_graphs_per_country.Rmd",
                  output_format = 'bookdown::html_document2', 
                  output_file = paste0("2025/",cou,'.html'),
                  params =list(country=list(value= cou),
                               area= list(choices = "North Sea")))


cou = 'LT'
rmarkdown::render("C:/workspace/wg_WGEEL/R/Rmarkdown/automatic_tables_graphs_per_country.Rmd",
                  output_format = 'bookdown::html_document2', 
                  output_file = paste0("2025/",cou,'.html'),
                  params =list(country=list(value= cou),
                               area= list(choices = "North Sea")))