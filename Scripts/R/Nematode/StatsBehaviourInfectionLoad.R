library(tidyverse)

AntTable <- read_csv("Data/outputAntTableMergedJoined.csv")
InfectionStatus <- read_delim("Data/antInfectionStatus.csv", delim = ";")

left_join(AntTable, InfectionStatus, by = c("ColonyID", "Colour", "InfectionStatus")) %>% 
  mutate(
    TreatmentInfectionStatus = as.factor(paste0(Treatment, "_", InfectionStatus)),
    Treatment = as.factor(Treatment),
    InfectionStatus = as.factor(InfectionStatus)) %>% 
  filter(TreatmentInfectionStatus != "C_uninfected" & TreatmentInfectionStatus != "X_uninfected") -> AntTableFull

cor.test(AntTableFull$OutNestRatio, AntTableFull$InfectionLoad, method = "spearman", exact = FALSE)
