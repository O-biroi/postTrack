clear all
dirPath = '/Volumes/Nema/Nema_2/cam4/antrax/antdata/C6';
matFiles = dir(fullfile(dirPath, '*.mat'));
for i = 1:length(matFiles)
    tempName = matFiles(i).name;
    tempNumber = split(tempName, '_');
    number(i) = str2double(tempNumber{3}(1:end-4));
end

number2 = sort(number);
a = find(~ismember(1:238, number2));

allOneString = sprintf('%.0f,' , a);
allOneString = allOneString(1:end-1)


