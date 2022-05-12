library(tidyverse)
library(EnvStats)
library(lme4)
library(lmerTest)
library(DHARMa)
library(multcomp)
library(EnvStats)
library(glmmTMB)

antSpeedTemporalOrignial <- read.csv("/Users/zli/Desktop/postTrack/Data/outputSpeedTemporalFull.csv")
antOutNestSpeedTemporalOrignial <- read.csv("/Users/zli/Desktop/postTrack/Data/outputOutNestSpeedTemporalFull.csv")

### Compare Mean Speed
antSpeedTemporalOrignial %>% 
  mutate(Day = as.factor(1+ floor((ContinuousSegment-1)/12)),
         ContinuousSegment = as.factor(ContinuousSegment)) %>% 
  group_by(ColonyID, Colour, Treatment, Day) %>% 
  summarise(MeanSpeedByDay = mean(MeanSpeed, na.rm = TRUE),
            MeanAssignmentRateByDay = mean(AssignmentRate, na.rm = TRUE))->antSpeedTemporal

antSpeedTemporal %>% 
  filter(MeanAssignmentRateByDay > 0.5) %>% 
  ggplot() +
  geom_jitter(aes(x = Day, y = MeanSpeedByDay, color = Treatment, alpha = 0.1) ) +
  geom_boxplot(aes(x = Day, y = MeanSpeedByDay, color = Treatment)) +
  stat_n_text(aes(x = Day, y = MeanSpeedByDay))

### Compare Out Nest Speed
antOutNestSpeedTemporalOrignial %>% 
  mutate(Day = as.factor(1+ floor((ContinuousSegment-1)/12)),
         ContinuousSegment = as.factor(ContinuousSegment)) %>% 
  group_by(ColonyID, Colour, Treatment, Day) %>% 
  summarise(MeanSpeedByDay = mean(MeanSpeed, na.rm = TRUE),
            MeanAssignmentRateByDay = mean(AssignmentRate, na.rm = TRUE))->antOutNestSpeedTemporal

antOutNestSpeedTemporal %>% 
  filter(MeanAssignmentRateByDay > 0.05) %>% 
  ggplot() +
  geom_jitter(aes(x = Day, y = MeanSpeedByDay, color = Treatment, alpha = 0.1) ) +
  geom_boxplot(aes(x = Day, y = MeanSpeedByDay, color = Treatment)) +
  stat_n_text(aes(x = Day, y = MeanSpeedByDay))

# sanity check for 
antOutNestSpeedTemporalOrignial %>% 
  group_by(ColonyID, Colour, Treatment) %>% 
  summarise(MeanSpeedByAnt = mean(MeanSpeed, na.rm = TRUE)) %>% 
  ggplot() +
  geom_jitter(aes(x = Treatment, y = MeanSpeedByAnt, color = Treatment, alpha = 0.1) ) +
  geom_boxplot(aes(x = Treatment, y = MeanSpeedByAnt, color = Treatment)) +
  stat_n_text(aes(x = Treatment, y = MeanSpeedByAnt, color = Treatment))
