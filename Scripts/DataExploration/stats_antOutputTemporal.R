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
antOutputTemporal <- read.csv("/Users/lizimai/Desktop/postTrack/Data/outTemporalFull.csv")
antOutputTemporal$Day = as.factor(antOutputTemporal$Day)
antOutputTemporal %>% 
  filter(AssignmentRate > 0.5) %>% 
  ggplot() +
  geom_jitter(aes(x = Day, y = OutNestRatio, color = Treatment, alpha = 0.1) ) +
  geom_boxplot(aes(x = Day, y = OutNestRatio, color = Treatment)) +
  stat_n_text(aes(x = Day, y = OutNestRatio, color = Treatment))

fit4 <- glmmTMB(formula = cbind(OutNestFrames, InNestFrames) ~ Treatment*Day + (1|ColonyID), data = antOutputTemporal, ziformula = ~., family = betabinomial())
simulationOutput <- simulateResiduals(fittedModel = fit4, plot = F)
plot(simulationOutput)
summary(fit4)

# sanity check for 
antOutputTemporal %>% 
  group_by(ColonyID, Colour, Treatment) %>% 
  summarise(OutNestFrames_ttl = sum(OutNestFrames),
            TotalFrames_ttl = sum(TotalFrames),
            OutNestRatio = OutNestFrames_ttl/TotalFrames_ttl) %>% 
  ggplot() +
  geom_jitter(aes(x = Treatment, y = OutNestRatio, color = Treatment, alpha = 0.1) ) +
  geom_boxplot(aes(x = Treatment, y = OutNestRatio, color = Treatment)) +
  stat_n_text(aes(x = Treatment, y = OutNestRatio, color = Treatment))
 ,zz