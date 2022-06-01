library(tidyverse)
library(EnvStats)
library(lme4)
library(lmerTest)
library(DHARMa)
library(car)
library(multcomp)
library(EnvStats)
library(glmmTMB)
library(pbkrtest)

# load data

infectionDynamics <- read.csv("/Users/zli/Desktop/postTrack/InfectionDynamics/infection_dynamics.csv", sep = ";")
infectionDynamics$rep_cycle <- infectionDynamics$rep_cycle
# statistics
# there is zero inflation in one treatment
gmm1 <- glmmTMB(Infec_intensity^(1/3) ~ Caste * rep_cycle  + (1|colony),  ziformula = ~rep_cycle, data = infectionDynamics)
testDispersion(fit)
testZeroInflation(fit)
simulationOutput <- simulateResiduals(fittedModel = fit, plot = F)
plot(simulationOutput)
Anova(fit, type = "II")
summary(fit)

gmm2 <- update(gmm1, .~.-Caste : rep_cycle)
anova(gmm1, gmm2)
PBmodcomp(gmm1, gmm2, cl=2)

drop1(gmm1, scope = ~Caste : rep_cycle, scale = 0, test = "Chisq" )
drop1(gmm1, scope = ~Caste, scale = 0, test = "Chisq" )
drop1(gmm1, scope = ~rep_cycle, scale = 0, test = "Chisq" )



drop1(fit, scale = 0, test = "Chisq" )
drop1(fit, scale = 0, test = "Chisq" )

