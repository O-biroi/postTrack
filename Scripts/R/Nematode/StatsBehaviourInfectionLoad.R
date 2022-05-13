library(tidyverse)

AntTable <- read_csv("Data/outputAntTableMergedJoined.csv")

AntTable %>% 
  mutate(
    TreatmentInfectionStatus = as.factor(paste0(Treatment, "_", InfectionStatus)),
    Treatment = as.factor(Treatment),
    InfectionStatus = as.factor(InfectionStatus)) %>% 
  filter(TreatmentInfectionStatus != "C_uninfected" & TreatmentInfectionStatus != "X_uninfected") %>%   group_by(ColonyID) %>% 
  group_by(ColonyID) %>% 
  arrange(InfectionLoad) %>% 
  mutate(RankInfectionLoad = row_number(), 
         RankInfectionLoad = ifelse(InfectionLoad == "NaN", as.numeric(NA), RankInfectionLoad)) %>% 
  arrange(OutNestRatio) %>% 
  mutate(RankOutNestRatio = row_number()) %>% 
  arrange(MeanSpeed) %>% 
  mutate(RankMeanSpeed = row_number())-> AntTableWithRank

cor.test(AntTableWithRank$RankOutNestRatio, AntTableFull$RankInfectionLoad, method = "spearman", exact = FALSE)
cor.test(AntTableWithRank$RankMeanSpeed, AntTableFull$RankInfectionLoad, method = "spearman", exact = FALSE)

  ggplot(AntTableFull, aes(color = Treatment)) +
  geom_jitter(aes(x = InfectionLoad, y = OutNestRatio), size = 2) +   
  scale_color_manual(name = "Colony Treatment", labels = c("Infected", "Mixed"), values = c("T" = "#D95319", "X" = "#7E2F8E")) +
  xlab("Infection load (Number of nematodes)") +
  ylab("Proportion of frames being outside the nest") +
  theme_light(base_size = 14) +
  theme(legend.position = "bottom") 

ggsave(file="Results/jitterInfectionLoadOutNest.svg", plot=jitterInfectionLoadOutNest, width=8, height=6)
