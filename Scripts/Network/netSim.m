probInfection = 0.01;
numOfReps = 10;

clearvars numOfInfections

for i = 1:size(contactNet, 1)
    for in = 1:size(contactNet, 2)
        contactNetTemp = contactNet{i, in};
        for indexCase = 1:size(contactNetTemp, 2)
            %             tic
            for rep = 1:numOfReps   
                infectedVec = zeros(1, size(contactNetTemp, 2));
                infectedVec(indexCase) = 1;
                infected = indexCase;
                for ind = 1:size(contactNetTemp, 3)
                    infectedMat1 = repmat(infectedVec, size(contactNetTemp, 2), 1);
                    infectedMat2 = repmat(infectedVec', 1, size(contactNetTemp, 2));
                    infectedMat = infectedMat1|infectedMat2;
                    contactMat = contactNetTemp(:, :, ind) == 1;
                    contactInfectedMat = infectedMat .* contactMat;
                    [r, c] = find(contactInfectedMat);
                    for inde = 1:length(infected)
                        contacts = c(r == infected(inde));
                        contacts = [contacts; r(c == infected(inde))];
                        for index = 1:length(contacts)
                            if ismember(contacts(index), infected)
                                continue
                            end
                            if rand < probInfection
                                infectedVec(contacts(index)) = 1;
                                infected(end+1) = contacts(index);
                            end
                        end
                        clearvars contacts contactsFiltered
                        
                    end
                    clearvars infectedMat1 infectedMat2 infectedMat contactMat contactInfectedMat
                    numOfInfections(i, in, ind, indexCase, rep) = sum(infectedVec);
                    %                     toc
                end
                
            end
        end
    end
end







