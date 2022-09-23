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
library(emmeans)
library(ggplot2)

# load data

infectionDynamics <- read.csv("InfectionDynamics/infection_dynamics.csv", sep = ";")
infectionDynamics$rep_cycle <- infectionDynamics$rep_cycle

# prepare data for infection probability
infectionDynamics %>% 
  filter(rep_cycle == 1) %>% 
  mutate(infection_status = Infec_intensity != 0) -> infectionStatusCycle1
  
# statistics
# logistic regression for infection probability at colony cycle 1
glmer <- glmer(data = infectionStatusCycle1, infection_status ~ Caste + (1|colony), family = binomial())
testDispersion(glmer)
testZeroInflation(glmer)
simulationOutput <- simulateResiduals(fittedModel = glmer, plot = F)
plot(simulationOutput)
summary(glmer)
drop1(glmer, scope = ~Caste, scale = 0,test = "Chisq" )

# post-hoc compare probabilities
emm <- emmeans(glmer, "Caste", type = "response")
emm
pairs(emm)

# glmm for infection intensity
## there is zero inflation in one treatment
fit <- glmmTMB(Infec_intensity ~ Caste + rep_cycle + Caste:rep_cycle  + (1|colony),  ziformula = ~rep_cycle, data = infectionDynamics)
testDispersion(fit)
testZeroInflation(fit)
simulationOutput <- simulateResiduals(fittedModel = fit, plot = F)
plot(simulationOutput)
drop1(fit, scope = ~Caste : rep_cycle, scale = 0,test = "Chisq" )

# compare slopes
emt <- emtrends(fit, ~Caste|rep_cycle, var = "rep_cycle")
emt          # estimated slopes for each species
pairs(emt)   # pairwise comparisons of slopes


# pairwise comparison between foragers and nurses at different time points (not appropriate since time is continuous - lead to estimation higher than real values for t = 2)
pairwiseFit <- emmeans(fit, pairwise~Caste|rep_cycle, at = list(rep_cycle = c(1,2,3,4)))
pairwiseFit

pairwiseFit2 <- emmeans(fit, pairwise~rep_cycle, at = list(rep_cycle = c(1,2,3,4)))
pairwiseFit2




