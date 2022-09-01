clear all;
colNum = 2;
expPath = '/Volumes/ulr-lab/Users/Zimai_zili7317/idol/idol_cam11/';
a = [];
for i = 1:colNum
    number = [];
    colNumString = num2str(i);
    dirPath = strcat(expPath,'antrax/antdata/C',colNumString);
    matFiles = dir(fullfile(dirPath, '*.mat'));
    for j = 1:length(matFiles)
        tempName = matFiles(j).name;
        tempNumber = split(tempName, '_');
        number(j) = str2double(tempNumber{3}(1:end-4));
    end
    number2 = sort(number);
    a_temp = find(~ismember(1:288, number2));
    a = union(a, a_temp);
end

allOneString = sprintf('%.0f,' , a);
allOneString = allOneString(1:end-1)
