library(tidyverse)
library(EnvStats)
library(lme4)
library(lmerTest)
library(DHARMa)
library(car)
library(multcomp)
library(EnvStats)

# load data

infectionDynamics <- read.csv("/Users/lizimai/Desktop/postTrack/InfectionDynamics/infection_dynamics.csv", sep = ";")
infectionDynamics$rep_cycle <- as.factor(infectionDynamics$rep_cycle)
# statistics
fit <- lmer(Infec_intensity^(1/3) ~ Caste * rep_cycle  + (1|colony), data = infectionDynamics)
testDispersion(fit)
simulationOutput <- simulateResiduals(fittedModel = fit, plot = F)
plot(simulationOutput)
Anova(fit, type = "II")
summary(fit)
