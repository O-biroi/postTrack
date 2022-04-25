%% Data exploration for raw xy files
%% PURPOSE
% This is code is to calculate general metrics for the xy output from antrax 
% that were merged
%% INPUT

% input file information
xyDir = "/Users/lizimai/Insync/zimai.li@evobio.eu/Google Drive/DoctorToBe/01_Projects/ZIM01_Nematode/P2_Tracking/01_Data/all";
%xyDir = "/Users/zli/Insync/zimai.li@evobio.eu/Google Drive/DoctorToBe/01_Projects/ZIM01_Nematode/P2_Tracking/01_Data/all";
xyFileinfo = dir(fullfile(xyDir,'xy*.mat'));
xyFilename = string((sort({xyFileinfo.name}))');

% create output matrix with experiment information in the xy file names
output = table(xyFilename,'VariableNames',{'Filename'});
splitNames = split(output.Filename, ["_","."]);
output.Treatment = categorical(splitNames(:, 2));
output.ColonyID = categorical(append(splitNames(:, 2),"_", splitNames(:, 3)));

% data filtering
maxNumAnts = 8; % maximum number of ants in one colony
treatRm = "None"; % treatment to remove
frameKeep = 864000; % frame to keep

% ant information
antColour = categorical(["BB","BG","BR","GG","GR","RB","RG","RR"]'); % colour code: sequence has to be matched with column sequence in the xy matrix
antTable = table(antColour, 'VariableNames',{'Colour'}); % create empty ant table for data storage of ants in each colony 

% run find nest code
inNestWithNansRaw = copyNans(xy, inNest);
inNestWithNans = inNestWithNansRaw(:,1);

% load infection status
loadInfectionStatus;

%% Clean Data

% filter some treatments
outputFiltered = output(output.Treatment~=treatRm,:);
numFile = length(outputFiltered.Filename);

% merge segments of inNestWithNansRaw
for i = 1:size(inNestWithNansRaw,1)
    for j = 2:size(inNestWithNansRaw,2)
    inNestWithNans{i} = [inNestWithNans{i};inNestWithNansRaw{i,j}];
    end
end


%% Calculate Metrics for Ants and Colonies
% *ATTENTION:* Run FindNest Before this section
for i = 1:numFile
    xyMatrix = load(fullfile(xyDir, outputFiltered.Filename(i))).xy(1:frameKeep,:); % load xy matrix
    numAnts = size(xyMatrix, 2)/2; % number of ants equals to number of columns
    treatment = outputFiltered.Treatment(i);
    colonyID = outputFiltered.ColonyID(i);
    % calculate basic statistics for ants
    for j = 1:length(antColour)
        antXy = xyMatrix(:,[j*2-1, j*2]);
        assignmentRate = 1 - sum(isnan(antXy),'all')/(size(xyMatrix, 1)*2);
        inNestFrame = sum(inNestWithNans{i,1}(:,j),"omitnan");
        totalFrame = (length(inNestWithNans{i,1}(:,j))-sum(sum(isnan(inNestWithNans{i,1}(:,j)))));
        antTable.ColonyID = repelem(colonyID,numAnts)';
        antTable.Treatment = repelem(treatment,numAnts)';
        antTable.AssignmentRate(j) = assignmentRate;
        antTable.InNestFrame(j) = inNestFrame;
        antTable.TotalFrame(j) = totalFrame;
        antTable.InNestRatio(j) = inNestFrame/totalFrame;  
    end
    
    % calculate basic statistics for colonies  
   outputFiltered.NumAnts(i) = numAnts; % count number of ants
   outputFiltered.AntOutput{i} = antTable ; % insert ant output
   outputFiltered.AssignmentRate(i) = mean(outputFiltered.AntOutput{i,1}.AssignmentRate); % count mean assignment rate
   outputFiltered.InNestRatioMean(i) = mean(outputFiltered.AntOutput{i,1}.InNestRatio); % count mean in-nest ratio
   outputFiltered.InNestRatioVariance(i) = var(outputFiltered.AntOutput{i,1}.InNestRatio); % count mean in-nest ratio
   outputFiltered.InNestRatioGlobal(i) = sum(inNestWithNans{i,1}, "all", "omitnan")/(length(inNestWithNans{i,1})*numAnts - sum(sum(isnan(inNestWithNans{i,1}))));
end

outputFiltered;

%%  produce ant table
antOutputTemp = table2array(outputFiltered(:,5));
antOutputTemp2 = vertcat(antOutputTemp{:});

% join ant table with infection status table
antOutputTemp2.OutNestFrame = antOutputTemp2.TotalFrame -  antOutputTemp2.InNestFrame;
antOutputTemp2.OutNestRatio = 1- antOutputTemp2.InNestRatio;

antOutput = join(antOutputTemp2, antInfectionStatus, "Keys",["ColonyID","Colour"]);
antOutput.ColonyTreatmentAntInfectionStatus = categorical(strcat(string(antOutput.Treatment), "_",string(antOutput.InfectionStatus)), ["C_uninfected", "T_infected", "X_uninfected", "X_infected"]);

writetable(antOutput, "antOutput.csv")
%% Statistics
% make violin charts
figure;
violinplot(antOutput.OutNestRatio, antOutput.Treatment);
xticklabels({'Uninfected','Infected','Mix'});
xlabel("Colony Treatment");
ylabel("Ratio of time being outside the nest")

% violin plot that separate ants with different infection status
figure;
violinplot(antOutput.OutNestRatio, antOutput.ColonyTreatmentAntInfectionStatus);
xticklabels({'Uninfected - uninfected','Infected - infected','Mix - Uninfected', 'Mix - infected'});
xlabel("Colony Treatment - Ant Infection Status");
ylabel("Ratio of time being in nest")
%boxchart(antOutput.ColonyTreatmentAntInfectionStatus, antOutput.InNestRatio,'Notch','on','GroupByColor', antOutput.Treatment);

%% 

% linear mix model, colony as random factor
lme1 = fitlme(antOutput,'InNestRatio~Treatment+(1|ColonyID)')



