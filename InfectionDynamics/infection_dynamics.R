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

infectionDynamics <- read.csv("InfectionDynamics/infection_dynamics.csv", sep = ";")
infectionDynamics$rep_cycle <- infectionDynamics$rep_cycle

infectionDynamics %>% 
  group_by(rep_cycle) %>% 
  summarise(mean = mean(Infec_intensity),
            sd = sd(Infec_intensity))
# statistics
# there is zero inflation in one treatment
fit <- glmmTMB(Infec_intensity^(1/3) ~ Caste * rep_cycle  + (1|colony),  family = gaussian(), ziformula = ~rep_cycle, data = infectionDynamics)
testDispersion(fit)
testZeroInflation(fit)
simulationOutput <- simulateResiduals(fittedModel = fit, plot = F)
plot(simulationOutput)
Anova(fit, type = "II")
summary(fit)

