%% Plot the trajectory of each ant in every colony
clear;
parameters.folderPath ='/Volumes/ulr-lab/Users/Zimai_zili7317/idol/results/all'; %Mac
%parameters.folderPath = 'C:\Users\galciato\polybox\Laptop\Age_Analysis\DeadPruned'; %Windows
parameters.numOfFiles = 10;
parameters.firstFile = 1;
parameters.numOfAnts = 10;
antColour = ["BG","BO","GB","GP","OB","OG","OP","PB","PG","PO"];
%parameters.segment = 6000 * 3; % number of frames in one "day"
%parameters.arenaSize = 0.05; % size of circular arena (in meters)
%parameters.lastframe = 864000;

files=dir(fullfile(parameters.folderPath,'*.mat')); %find all the mat files

%% Prepare files that matches survival and behaviour
for i = parameters.firstFile:parameters.firstFile + parameters.numOfFiles - 1
    names{i} = files(i,:).name;
    splitNames{i} = split(string(names{i}),["_","."]);
    colonyID{i} = categorical(append(splitNames{i}(2),"_", splitNames{i}(3),"_", splitNames{i}(4)));
end

%%
loadSurvival;
% make color value
survival.colonyID = categorical(append(survival.camera, "_C", survival.colonyCam,"_",survival.colony));
survival.antID = categorical(append(string(survival.colonyID), "_", string(survival.colour)));
% survivalSorted = sortrows(survival, ["colonyID", "minutesSurvival"]);

% numOfColonies = length(unique(findgroups(survivalSorted.colonyID)));
% survivalSorted.rank = (repmat(1:numAnts,1,colonies))';


%%
cvars = survival.minutesSurvival;
n = max(cvars)-min(cvars) + 1;
survival.cvars_map = int16((cvars - min(cvars))/(max(cvars)-min(cvars)) * (n-1) + 1);
cmap = winter(n);

for i = 1:size(survival,1)
    if survival.survivalEnd(i) == "Alive"
        survival.rgb(i) = {[0.6706 0.9686 0.3882]}; % special color for those who stayed alive until the end
    elseif survival.cvars_map(i) == 0    % special color for those that does not have survival information
        survival.rgb(i) = {[0 0 0]};
    else
        survival.rgb(i) = {cmap(survival.cvars_map(i),:)};
    end
end

survival.hrsSurvival = survival.minutesSurvival/60;
figure;
scatter(survival, 'colonyID', 'hrsSurvival', 'filled','ColorVariable','hrsSurvival');
colorbar;
colormap(cmap);
saveas(gcf,'/Volumes/ulr-lab/Users/Zimai_zili7317/idol/results/all/colorbar.png')


%% Produces figures
figure;
x0=10;
y0=10;
width=2000;
height=2000;
set(gcf,'position',[x0,y0,width,height]);
for i = 1:parameters.numOfFiles 
    xyMatrix = load(fullfile(files(i,:).folder,files(i,:).name)).xy; % load xy matrix
    numAnts = size(xyMatrix, 2)/2; % number of ants equals to number of columns
    if i == 3 % change it into the colonies that always stayed in the nest
        xlim_min = 0.015; % set x and y axis lim
        xlim_max = 0.07;
        ylim_min = 0.065;
        ylim_max = 0.1;
    elseif i == 5 % change it into the colonies that always stayed in the nest
        xlim_min = 0.015; % set x and y axis lim
        xlim_max = 0.07;
        ylim_min = 0.01;
        ylim_max = 0.05;
    elseif i == 6 % change it into the colonies that always stayed in the nest
        xlim_min = 0.075; % set x and y axis lim
        xlim_max = 0.145;
        ylim_min = 0.06;
        ylim_max = 0.1;
    else
        xlim_min = min(min(xyMatrix(:,1:2:2*numAnts-1))); % set x and y axis lim
        xlim_max = max(max(xyMatrix(:,1:2:2*numAnts-1)));
        ylim_min = min(min(xyMatrix(:,2:2:2*numAnts)));
        ylim_max = max(max(xyMatrix(:,2:2:2*numAnts)));
    end
    for j = 1:numAnts
        antID = append(string(colonyID{i}), "_", antColour(j));
        rgb = survival.rgb{survival.antID == antID};
        subplot(10,numAnts, (i-1)*numAnts+j); % make numFile*maxNumAnts grid plot
        x= xyMatrix(:,2*j-1);
        y = xyMatrix(:,2*j);
        % assignment rate
        scatter(x, y, 1, rgb, 'filled'); % set color as the rgb color
        axis ij;
        xlim([xlim_min,xlim_max]);
        ylim([ylim_min,ylim_max]);
        axis off;
    end
end

%%
saveas(gcf,'/Volumes/ulr-lab/Users/Zimai_zili7317/idol/results/all/allColonies.png')
