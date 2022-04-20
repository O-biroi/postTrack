%% Plot the trajectory of each ant in every colony
figure;
x0=10;
y0=10;
width=1700;
height=2000;
set(gcf,'position',[x0,y0,width,height])
for i = 1:10
     xyMatrix = load(fullfile(xyDir, outputFiltered.Filename(i))).xy(1:frameKeep,:); % load xy matrix
     numAnts = size(xyMatrix, 2)/2; % number of ants equals to number of columns
     xlim_min = min(min(xyMatrix(:,1:2:2*numAnts-1))); % set x and y axis lim
     xlim_max = max(max(xyMatrix(:,1:2:2*numAnts-1)));
     ylim_min = min(min(xyMatrix(:,2:2:2*numAnts)));
     ylim_max = max(max(xyMatrix(:,2:2:2*numAnts)));
     for j = 1:numAnts
        subplot(10,maxNumAnts, (i-1)*maxNumAnts+j); % make numFile*maxNumAnts grid plot
        x= xyMatrix(:,2*j-1);
        y = xyMatrix(:,2*j);
        % assignment rate
        if table2array(outputFiltered.AntOutput{i,1}(j,"AssignmentRate")) < 0.7
            scatter(x, y, 1, 'black' , 'filled');
        else
            scatter(x, y, 1, 'filled');
        end
        axis ij;
        xlim([xlim_min,xlim_max]);
        ylim([ylim_min,ylim_max]);
     end
end
saveas(gcf,'cTrajectories.png')


figure;
x0=10;
y0=10;
width=1700;
height=2000;
set(gcf,'position',[x0,y0,width,height])
for i = 11:20
     xyMatrix = load(fullfile(xyDir, outputFiltered.Filename(i))).xy(1:frameKeep,:); % load xy matrix
     numAnts = size(xyMatrix, 2)/2; % number of ants equals to number of columns
     xlim_min = min(min(xyMatrix(:,1:2:2*numAnts-1))); % set x and y axis lim
     xlim_max = max(max(xyMatrix(:,1:2:2*numAnts-1)));
     ylim_min = min(min(xyMatrix(:,2:2:2*numAnts)));
     ylim_max = max(max(xyMatrix(:,2:2:2*numAnts)));
     for j = 1:numAnts
        subplot(10,maxNumAnts, (i-11)*maxNumAnts+j); % make numFile*maxNumAnts grid plot
        x= xyMatrix(:,2*j-1);
        y = xyMatrix(:,2*j);
        % assignment rate
        if table2array(outputFiltered.AntOutput{i,1}(j,"AssignmentRate")) < 0.7
            scatter(x, y, 1, 'black' , 'filled');
        else
            scatter(x, y, 1,'filled');
        end
        axis ij;
        xlim([xlim_min,xlim_max]);
        ylim([ylim_min,ylim_max]);
     end
end
saveas(gcf,'tTrajectories.png')

figure;
x0=10;
y0=10;
width=1700;
height=2000;
set(gcf,'position',[x0,y0,width,height])
for i = 21:30
     xyMatrix = load(fullfile(xyDir, outputFiltered.Filename(i))).xy(1:frameKeep,:); % load xy matrix
     numAnts = size(xyMatrix, 2)/2; % number of ants equals to number of columns
     xlim_min = min(min(xyMatrix(:,1:2:2*numAnts-1))); % set x and y axis lim
     xlim_max = max(max(xyMatrix(:,1:2:2*numAnts-1)));
     ylim_min = min(min(xyMatrix(:,2:2:2*numAnts)));
     ylim_max = max(max(xyMatrix(:,2:2:2*numAnts)));
     for j = 1:numAnts
        subplot(10,maxNumAnts, (i-21)*maxNumAnts+j); % make numFile*maxNumAnts grid plot
        x= xyMatrix(:,2*j-1);
        y = xyMatrix(:,2*j);
        % assignment rate
        if table2array(outputFiltered.AntOutput{i,1}(j,"AssignmentRate")) < 0.7
            scatter(x, y, 1, 'black' , 'filled');
        else
            scatter(x, y, 1, 'filled');
        end
        axis ij;
        xlim([xlim_min,xlim_max]);
        ylim([ylim_min,ylim_max]);
     end
end
saveas(gcf,'xTrajectories.png')
