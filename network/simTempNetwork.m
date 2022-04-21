function infections = simTempNetwork(contactsPerAnt, infectionProb, entryPoints, numOfReps)
    numOfAnts = size(contactsPerAnt, 3);
    % entryPoints = linspace(1, numOfAnts, numOfAnts);
    % numOfReps = 10;
    % infectionProb = 0.01;

    for i = 1:size(contactsPerAnt, 1)                                       % for each file
        for in = 1:size(contactsPerAnt, 2)                                  % for each segment
            for ind = 1:length(entryPoints)                                 % for each entry point
                infectedAnts = entryPoints(ind);                            % add the entry point to the list of infected ants
                infectedContacts = contactsPerAnt{i, in, infectedAnts};     % gather the contacts of the entry point ant
                infectedContacts(:, 3) = infectedAnts;                      % add the infected ant to the third col
                for inde = 1:numOfReps                                      % for each simulation replication
                    infectionTimesTemp = 0;                                 % first infection is at 0 time for the entry point
                    infectingAntTemp = nan;                                 % first infection is not caused by another infecting ant - therfore nan
                    index = 1;                                              % start an index variable
                    while index <= size(infectedContacts, 1) && ...
                            length(infectedAnts) <= numOfAnts               % run the simulation as long as there are more contacts and more susceptible ants.
                        if rand < infectionProb && ...
                                ~ismember(infectedContacts(index, 2), ...
                                infectedAnts)                               % if a random number (between 0 and 1) is smaller than infection probability, and the contact is with a
                            infectedAnts = [infectedAnts, ...
                                infectedContacts(index, 2)];                % add the contacted ant to the infected ants list
                            infectionTimesTemp = [infectionTimesTemp, ...
                                infectedContacts(index, 1)];                % write down the time of infection
                            infectingAntTemp = [infectingAntTemp, ...
                                infectedContacts(index, 3)];                % write down the infecting ant
                            infectedContactsTemp = ...
                                contactsPerAnt{i, in, ...
                                infectedContacts(index, 2)};                % gather the contact list of the newly infected ant
                            infectedContactsTemp(infectedContactsTemp(:, ...
                                1) < infectedContacts(index, 1), :) = [];   % remove all contacts prior to the infection time
                            infectedContactsTemp(:, 3) = ...
                                infectedContacts(index, 2);                 % add the ant who made the contact to the third col
                            infectedContacts = [infectedContacts; ...
                                infectedContactsTemp];                      % add the newly infected ant's contact to the contact list
                            infectedContacts = sortrows(infectedContacts);  % sort the list in ascending order
                            clearvars infectedContactsTemp
                        end
                        index = index+1;
                    end
                    infections{i, in, ind, inde}.infectedAnts = infectedAnts;   % save the infection parameters
                    infections{i, in, ind, inde}.infectingAnts = ...
                        infectingAntTemp;
                    infections{i, in, ind, inde}.times = infectionTimesTemp;
                end

                clearvars infectionTimesTemp infectingAntTemp infectedAnts
            end
        end
    end
end

