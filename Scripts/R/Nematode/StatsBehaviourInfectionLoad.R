library(tidyverse)

AntTable <- read_csv("Data/outputAntTableMergedJoined.csv")
InfectionStatus <- read_delim("Data/antInfectionStatus.csv", delim = ";")

#left_join(, by = c("ColonyID", "Colour", "InfectionStatus")) %>% 
  AntTable %>% 
   mutate(
    TreatmentInfectionStatus = as.factor(paste0(Treatment, "_", InfectionStatus)),
    Treatment = as.factor(Treatment),
    InfectionStatus = as.factor(InfectionStatus)) %>% 
  filter(TreatmentInfectionStatus != "C_uninfected" & TreatmentInfectionStatus != "X_uninfected") -> AntTableFull

cor.test(AntTableFull$OutNestRatio, AntTableFull$InfectionLoad, method = "spearman", exact = FALSE)

#jitterInfectionLoadOutNest <- 
  
  ggplot(AntTableFull, aes(color = Treatment)) +
  geom_jitter(aes(x = InfectionLoad, y = OutNestRatio), size = 2) +   
  scale_color_manual(name = "Colony Treatment", labels = c("Infected", "Mixed"), values = c("T" = "#D95319", "X" = "#7E2F8E")) +
  xlab("Infection load (Number of nematodes)") +
  ylab("Proportion of frames being outside the nest") +
  theme_light(base_size = 14) +
  theme(legend.position = "bottom") 

  
  ggsave(file="Results/jitterInfectionLoadOutNest.svg", plot=jitterInfectionLoadOutNest, width=8, height=6)
