numOfAnts = size(contactNet{1}(:,:,1), 1);

nansMatrix1 = triu(nan([numOfAnts, numOfAnts]), 0);
nansMatrix1(nansMatrix1 == 0) = 1;
nansMatrix = repmat(nansMatrix1, 1, 1, length(contactNet{1}(1,1,:)));

key1Temp = linspace(1, numOfAnts, numOfAnts);
key1Temp = repmat(key1Temp ,numOfAnts, 1);
key2Temp = key1Temp';
key1Temp = key1Temp .* nansMatrix1;
key2Temp = key2Temp .* nansMatrix1;
key1 = reshape(key1Temp, [], 1);
key2 = reshape(key2Temp, [], 1);
key1(isnan(key1)) = [];
key2(isnan(key2)) = [];

clearvars nansMatrix1 key1Temp key2Temp

for i = 1:size(contactNet, 1)
    for in = 1:size(contactNet, 2)
        contactNetTemp = contactNet{i, in};
        contactNetTemp = contactNetTemp .* nansMatrix;
        contactNetTemp2 = reshape(contactNetTemp, [], size(contactNetTemp, 3));
        clearvars contactNetTemp
        contactNetTemp2 = contactNetTemp2';
        contactNetTemp2(:, all(isnan(contactNetTemp2))) = [];
        [contactFrame, contactIndex] = find(contactNetTemp2);
        ant1 = key1(contactIndex);
        ant2 = key2(contactIndex);
        for ind = 1:numOfAnts
            contactsAntsTemp = ant2(ant1 == ind);
            contactsAntsTemp = [contactsAntsTemp; ant1(ant2 == ind)];
            contactsFramesTemp = contactFrame(ant1 == ind);
            contactsFramesTemp = [contactsFramesTemp; contactFrame(ant2 == ind)];
            contactsPerAntTemp = [contactsFramesTemp, contactsAntsTemp];
            contactsPerAnt{i, in, ind} = sortrows(contactsPerAntTemp);

            clearvars contactsPerAntTemp contactsAntsTemp contactsFramesTemp
        end
    end
end

