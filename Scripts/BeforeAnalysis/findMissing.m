clear all
dirPath = '~/Desktop/idol/idol_cam10/antrax/antdata/C4';
matFiles = dir(fullfile(dirPath, '*.mat'));
for i = 1:length(matFiles)
    tempName = matFiles(i).name;
    tempNumber = split(tempName, '_');w
    number(i) = str2double(tempNumber{3}(1:end-4));
end

number2 = sort(number);
a = find(~ismember(1:288, number2));

allOneString = sprintf('%.0f,' , a);
allOneString = allOneString(1:end-1)


