library(tidyverse)
library(glmmTMB)
library(DHARMa)

AntTable <- read_csv("Data/outputAntTableMergedJoined.csv")

AntTable %>% 
  mutate(
    TreatmentInfectionStatus = as.factor(paste0(Treatment, "_", InfectionStatus)),
    Treatment = as.factor(Treatment),
    InfectionStatus = as.factor(InfectionStatus)) %>% 
  filter(TreatmentInfectionStatus != "C_uninfected" & TreatmentInfectionStatus != "X_uninfected") %>%   group_by(ColonyID) %>% 
  group_by(ColonyID) %>% 
  arrange(InfectionLoad, ) %>% 
  mutate(RankInfectionLoad = row_number(), 
         RankInfectionLoad = ifelse(InfectionLoad == "NaN", as.numeric(NA), RankInfectionLoad)) %>% 
  arrange(OutNestRatio) %>% 
  mutate(RankOutNestRatio = row_number()) %>% 
  arrange(MeanSpeed) %>% 
  mutate(RankMeanSpeed = row_number()) %>% 
  ungroup() -> AntTableWithRank

AntTableWithRank %>% 
  filter(TreatmentInfectionStatus == "T_infected") %>% 
ggplot(aes(RankInfectionLoad, RankOutNestRatio)) +
  geom_smooth(method='lm') +
  geom_jitter()

cor.test(AntTableWithRank$RankInfectionLoad, AntTableWithRank$RankOutNestRatio, method = "spearman", exact = FALSE)
cor.test(AntTableWithRank$RankMeanSpeed, AntTableWithRank$RankInfectionLoad, method = "spearman", exact = FALSE)

lmerOutLoad <- glmmTMB(OutNestRatio ~ InfectionLoad + (1|ColonyID), data = AntTableWithRank, family = beta_family())
summary(lmerOutLoad)
testDispersion(lmerOutLoad)
simulationOutput <- simulateResiduals(fittedModel = lmerOutLoad, plot = F)
plot(simulationOutput)

lmerSpeedLoad <- glmmTMB(MeanSpeed ~ InfectionLoad + (1|ColonyID), data = AntTableWithRank, family = gaussian())
summary(lmerSpeedLoad)
testDispersion(lmerSpeedLoad)
simulationOutput <- simulateResiduals(fittedModel = lmerSpeedLoad, plot = F)
plot(simulationOutput)

  ggplot(AntTableFull, aes(color = Treatment)) +
  geom_jitter(aes(x = InfectionLoad, y = OutNestRatio), size = 2) +   
    geom_line() +
  scale_color_manual(name = "Colony Treatment", labels = c("Infected", "Mixed"), values = c("T" = "#D95319", "X" = "#7E2F8E")) +
  xlab("Infection load (Number of nematodes)") +
  ylab("Proportion of frames being outside the nest") +
  theme_light(base_size = 14) +
  theme(legend.position = "bottom") 

ggsave(file="Results/jitterInfectionLoadOutNest.svg", plot=jitterInfectionLoadOutNest, width=8, height=6)
