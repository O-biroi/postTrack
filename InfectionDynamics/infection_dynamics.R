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

infectionDynamics <- read.csv("/Users/zli/Desktop/postTrack/InfectionDynamics/infection_dynamics.csv", sep = ";")
infectionDynamics$rep_cycle <- infectionDynamics$rep_cycle
# statistics
# there is zero inflation in one treatment
fit <- glmmTMB(Infec_intensity^(1/3) ~ Caste * rep_cycle  + (1|colony),  ziformula = ~rep_cycle, data = infectionDynamics)
testDispersion(fit)
testZeroInflation(fit)
simulationOutput <- simulateResiduals(fittedModel = fit, plot = F)
plot(simulationOutput)
Anova(fit, type = "II")
summary(fit)

