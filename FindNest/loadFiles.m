function [xy1, names] = loadFiles(folderPath, firstFile, numOfFiles, segment, lastframe)

files=dir(fullfile(folderPath,'*.mat')); %find all the mat files

for i = firstFile:numOfFiles
    temp=load(fullfile(files(i,:).folder,files(i,:).name));
    temp.xy = temp.xy(1:lastframe,:);
    names{i} = files(i,:).name;
    lastDay = floor(length(temp.xy)./segment);
    for day = 1:lastDay
            xy1{i,day}= temp.xy((day-1)*segment+1:(day)*segment, :);
    end
end

end

