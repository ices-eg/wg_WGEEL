load("../../../../wkeelmigration/source/resc2.Rdata")
subset_closures = subset(resc2, resc2$reason_for_closure %in% c("EMP", "EU Closure"))
subset_closures = subset(resc2, resc2$typ_name=="com_closure")
EMP_closures=subset(subset_closures, subset_closures$reason_for_closure == "EMP")
EU_closures=subset(subset_closures, subset_closures$reason_for_closure == "EU Closure")

charac_EMP_closures=EMP_closures %>% 
  group_by(emu_nameshort,
           hty_code,
          lfs_code) %>%
  summarize(year=min(year))

charac_EU_closures=EU_closures %>% 
  group_by(emu_nameshort,
           hty_code,
          lfs_code) %>%
  summarize(year=min(year))


EMP_closures = EMP_closures[order(EMP_closures$emu_nameshort,
                                  EMP_closures$lfs_code,
                                  EMP_closures$hty_code,
                                  EMP_closures$year,
                                  EMP_closures$month,
                                  decreasing=TRUE),]

EU_closures = EU_closures[order(EU_closures$emu_nameshort,
                                  EU_closures$lfs_code,
                                  EU_closures$hty_code,
                                  EU_closures$year,
                                  EU_closures$month,
                                  decreasing=TRUE),]
EMP_closures=unique(EMP_closures[, c("emu_nameshort","lfs_code","hty_code","month","fishery_closure_percent")])
EMP_closures=EMP_closures[!duplicated(EMP_closures[,c("emu_nameshort","lfs_code","hty_code","month")]), ]
EU_closures=unique(EU_closures[, c("emu_nameshort","lfs_code","hty_code","month","fishery_closure_percent")])
EU_closures=EU_closures[!duplicated(EU_closures[,c("emu_nameshort","lfs_code","hty_code","month")]), ]

all_year <- EMP_closures %>%
  filter(month==13) %>% slice(rep(1:n(), each = 12))
all_year$month=factor(1:12,levels=1:13)

EMP_closures <- bind_rows(EMP_closures %>% filter(month!=13),
                          all_year)

