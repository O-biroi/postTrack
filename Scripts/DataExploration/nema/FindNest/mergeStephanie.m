clear all
rootDirPath = '/Users/daniel/Documents/Academia/Post-Ulrich/previous work/StephanieData/crossfostering_antdata/cross_fostering_antdata';
% mkdir merged
list1 = dir(rootDirPath);
list1 = list1([list1.isdir]);
list1 = list1(~ismember({list1.name},{'.' '..'}));
for i = 1:length(list1)
    list2 = listFolders(list1(i));
    for in = 1:length(list2)
        list3 = listFolders(list2(in));
        for ind = 1:length(list3)
            list4 = listFolders(list3(ind));
            for inde = 1:length(list4)
                list5 = listFolders(list4(inde));
                if isempty(list5)
                    xy = mergeXY(dir(fullfile(list4(inde).folder, list4(inde).name)));
                    folder = strsplit(list4(inde).folder,'/');
                    filename = [folder{end-2}, folder{end-1}, list4(inde).name];
                    save(convertCharsToStrings(filename), 'xy')
                else
                    for index = 1:length(list5)
                        xy = mergeXY(dir(fullfile(list5(index).folder, list5(index).name)));
                        folder = strsplit(list5(index).folder,'/');
                        filename = [folder{end-3} folder{end-2}, folder{end-1}, list5(index).name];
                        save(convertCharsToStrings(filename), 'xy')
                    end
                end
            end
        end
    end
end




function directory = listFolders(dirVar)
    dirPath = fullfile(dirVar.folder, dirVar.name);
    directory = dir(dirPath);
    directory = directory([directory.isdir]);
    directory = directory(~ismember({directory.name},{'.' '..'}));
end


function xy = mergeXY(folder)
    xy = [];
    matFiles = dir(fullfile(folder(1).folder, '*.mat'));
    matFiles = matFiles(~ismember({matFiles.name},{'.DS_Store'}));
    for i = 1:length(matFiles)
        data = struct2cell(load(fullfile(folder(1).folder, ['xy_', num2str(i), '_', num2str(i), '.mat'])));
        numOfFrames = size(data{1}, 1);
        lengthXy = size(xy, 1);
        for in = 1:2:length(data)*2
            xy(lengthXy+1 : lengthXy+numOfFrames, in:in+1) = data{(in+1)/2}(:, 1:2);
        end
        
    end
end




