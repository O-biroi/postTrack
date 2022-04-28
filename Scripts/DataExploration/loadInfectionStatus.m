%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /Users/zli/Desktop/postTrack/Data/antInfectionStatus.csv
%
% Auto-generated by MATLAB on 25-Apr-2022 20:53:21

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["ColonyID", "Colour", "InfectionStatus", "InfectionLoad"];
opts.VariableTypes = ["string", "categorical", "categorical", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "ColonyID", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["ColonyID", "Colour", "InfectionStatus"], "EmptyFieldRule", "auto");

% Import the data
antInfectionStatus = readtable("/Users/zli/Desktop/postTrack/Data/antInfectionStatus.csv", opts);
antInfectionStatus.ColonyID = categorical(antInfectionStatus.ColonyID);

%% Clear temporary variables
clear opts