clear
rootDirPath = '/Volumes/Nema/Nema_2/cam4/antrax/antdata';
numOfVideos = 238 ; %set the expected number of videos
numOfAnts = 8;
emptyMatrix = nan(6000, 4);

list1 = dir(rootDirPath); % get the directory information of all the items the root path
list1 = list1([list1.isdir]); % filter only the directory folders 
list1 = list1(~ismember({list1.name},{'.' '..'})); % extract only member that are not . or ..
for i = 1:length(list1)
    xy = mergeXY(dir(fullfile(list1(i).folder, list1(i).name)), numOfAnts, numOfVideos, emptyMatrix); % concatenate the file names
    folder = strsplit(list1(i).folder,'/');
    filename = ['xy' list1(i).name];
    save(convertCharsToStrings(filename), 'xy')
end

function directory = listFolders(dirVar)
    dirPath = fullfile(dirVar.folder, dirVar.name);
    directory = dir(dirPath);
    directory = directory([directory.isdir]);
    directory = directory(~ismember({directory.name},{'.' '..'}));
end


function xy = mergeXY(folder, numOfAnts, numOfVideos, emptyMatrix)
    xy = [];
    matFiles = dir(fullfile(folder(1).folder, '*.mat'));
    matFiles = matFiles(~ismember({matFiles.name},{'.DS_Store'}));
    for i = 1:numOfVideos
        fileName = fullfile(folder(1).folder, ['xy_', num2str(i), '_', num2str(i), '.mat']);
        if(isfile(fileName))
            data = struct2cell(load(fullfile(folder(1).folder, ['xy_', num2str(i), '_', num2str(i), '.mat'])));
        else
            data = cell(numOfAnts,1);
            data(1:numOfAnts) = {emptyMatrix};
        end
        numOfFrames = size(data{1}, 1);
        lengthXy = size(xy, 1);
        for in = 1:2:length(data)*2
            xy(lengthXy+1 : lengthXy+numOfFrames, in:in+1) = data{(in+1)/2}(:, 1:2);
        end
        
    end
end