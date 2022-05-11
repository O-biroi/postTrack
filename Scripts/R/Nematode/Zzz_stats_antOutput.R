library(tidyverse)
library(EnvStats)
library(lme4)
library(lmerTest)
library(DHARMa)
library(car)
library(multcomp)
library(EnvStats)
library(glmmTMB)

# load data
AntTable <- read_csv("Data/outputAntTableMergedJoined.csv")
InfectionStatus <- read_delim("Data/antInfectionStatus.csv", delim = ";")



left_join(AntTable, InfectionStatus, by = c("ColonyID", "Colour", "InfectionStatus")) %>% 
  mutate(
    TreatmentInfectionStatus = as.factor(paste0(Treatment, "_", InfectionStatus)),
    Treatment = as.factor(Treatment),
    InfectionStatus = as.factor(InfectionStatus)) %>% 
  filter(TreatmentInfectionStatus != "C_uninfected" & TreatmentInfectionStatus != "X_uninfected") -> AntTableFull



AntTableFull %>% 
  group_by(Treatment) %>% 
  summarise(MeanOutNestRatio = mean(OutNestRatio),
            SdOutNestRatio = sd(OutNestRatio))



left_join(antOutput, antInfectionStatus) %>% 
  mutate(TreatmentMerged = ifelse(Treatment == "C", "C", "Others")) -> antOutputTreatmentMerged



fit1 <- glmer(cbind(OutNestFrame, InNestFrame) ~ Treatment + InfectionLoad + (1|ColonyID), data = antOutputTreatmentMerged,  family = binomial())
testDispersion(fit1)
simulationOutput <- simulateResiduals(fittedModel = fit1, plot = F)
plot(simulationOutput)
Anova(fit1, type = "II")
summary(fit1)


œ

anova(fit1, fit2)

fit2 <- glmer(cbind(OutNestFrame, InNestFrame) ~ ColonyTreatmentAntInfectionStatus + (1|ColonyID), data = antOutput, family = binomial())
testDispersion(fit2)
simulationOutput <- simulateResiduals(fittedModel = fit2, plot = F)
plot(simulationOutput)
Anova(fit2, type = "II")
summary(fit2)


antOutputTreatmentMerged %>% 
  filter(InfectionLoad != 0 & InfectionLoad != "NaN") -> antOutputAllInfected



cor.test(antOutputAllInfected$InfectionLoad, antOutputAllInfected$OutNestRatio, method = "spearman")

# zero inflation
fit3 <- glmmTMB(cbind(OutNestFrame, InNestFrame) ~ InfectionLoad + (1|ColonyID),data = antOutputAllInfected,  family = binomial())
testDispersion(fit3)
simulationOutput <- simulateResiduals(fittedModel = fi31, plot = F)
plot(simulationOutput)
Anova(fit3, type = "II")
summary(fit3)
