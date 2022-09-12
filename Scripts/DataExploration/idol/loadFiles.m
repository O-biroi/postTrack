function [xy1, names] = loadFiles(folderPath, firstFile, numOfFiles,lastframe)

files=dir(fullfile(folderPath,'*.mat')); %find all the mat files

for i = firstFile:firstFile + numOfFiles - 1
    temp=load(fullfile(files(i,:).folder,files(i,:).name));
    names{i} = files(i,:).name;
    temp.xy=temp.xy(1:lastframe,:);
    lastDay = floor(length(temp.xy)./lastframe);
    for day = 1:lastDay
            xy1{i - firstFile + 1,day}= temp.xy((day-1)*lastframe+1:(day)*lastframe, :);
    end
end

end

