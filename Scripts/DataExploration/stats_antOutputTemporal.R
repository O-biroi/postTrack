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
antOutputTemporal 
ggplot() +
  geom_jitter(aes(x = Day, y = OutNestRatio, color = Treatment)) +
  geom_boxplot(aes(x = Day, y = OutNestRatio, color = Treatment))
