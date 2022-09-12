%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /Users/zli/Desktop/postTrack/Data/fungiSurvival/survival.csv
%
% Auto-generated by MATLAB on 05-Sep-2022 16:02:00

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 9, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["camera", "colonyCam", "colony", "colour", "startTime", "deathTime", "survivalEnd", "minutesSurvival", "minutesSurvivalForRanking"];
opts.VariableTypes = ["string", "string", "string", "categorical", "datetime", "datetime", "categorical", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["camera", "colonyCam", "colony"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["camera", "colonyCam", "colony", "colour", "survivalEnd"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "startTime", "InputFormat", "dd.MM.yy HH:mm");
opts = setvaropts(opts, "deathTime", "InputFormat", "dd.MM.yy HH:mm");

% Import the data
survival = readtable("/Users/zli/Desktop/postTrack/Data/fungiSurvival/survival.csv", opts);


%% Clear temporary variables
clear opts