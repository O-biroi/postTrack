library(tidyverse)
library(EnvStats)
library(lme4)
library(lmerTest)
library(DHARMa)
library(multcomp)
library(EnvStats)
library(glmmTMB)

antSpeedTemporalOrignial <- read.csv("/Users/lizimai/Desktop/postTrack/Data/outputSpeedTemporalFull.csv")
antSpeedTemporalOrignial %>% 
  mutate(Day = as.factor(1+ floor((ContinuousSegment-1)/12)),
         ContinuousSegment = as.factor(ContinuousSegment)) ->antSpeedTemporal

antSpeedTemporal %>% 
  #ßfilter(AssignmentRate > 0.5) %>% 
  ggplot() +
  geom_jitter(aes(x = Day, y = MeanSpeed, color = Treatment, alpha = 0.1) ) +
  geom_boxplot(aes(x = Day, y = MeanSpeed, color = Treatment)) +
  stat_n_text(aes(x = Day, y = MeanSpeed))
