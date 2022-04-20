matFiles = dir(fullfile(pwd, '*.mat'));
matFilesNames = {matFiles.name};
matFilesNamesLeng = cellfun(@length, matFilesNames);
toMerge1 = find(matFilesNamesLeng == 44);
toMerge1Names = matFilesNames(toMerge1);
toMerge2 = find(matFilesNamesLeng == 45);
toMerge2Names = matFilesNames(toMerge2);

for i = 1:length(toMerge1)/2
    ending = toMerge1Names{i}(end-12 : end);
    files = find(contains(toMerge1Names,ending));
    secondFile = toMerge1Names{files(2)};
    thirdFile = toMerge1Names{files(3)};
    first = load(fullfile(toMerge1Names{i}));
    second = load(fullfile(secondFile));
    third = load(fullfile(thirdFile));
    xy = [first.xy; second.xy; third.xy];
    filename = append(toMerge1Names{i}(1:end-23), toMerge1Names{i}(end-12:end-4));
    save(filename, 'xy');
end

for i = 1:length(toMerge2)/2
    ending = toMerge2Names{i}(end-12 : end);
    files = find(contains(toMerge2Names,ending));
    secondFile = toMerge2Names{files(2)};
    first = load(fullfile(toMerge2Names{i}));
    second = load(fullfile(secondFile));
    xy = [first.xy; second.xy];
    filename = append(toMerge2Names{i}(1:end-23), toMerge2Names{i}(end-12:end-4));
    save(filename, 'xy');
end
    
    
    
    


