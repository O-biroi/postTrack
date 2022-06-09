function contactsPerAnt = contactRoutesCalc(contactsMat)

%     numOfAnts = size(contactsMat{1}(:,:,1), 1);
    numOfAnts = size(contactsMat{find(cellfun(@(a) ~isnan(sum(a, 'all')), contactsMat), 1, 'first')}(:,:,1), 1);
    %% Generate masking matrices
    % for working only on one copy of couples - the lower part of the
    % contactsMat.
    nansMatrix1 = triu(nan([numOfAnts, numOfAnts]), 0);                     % generate half matrix (diagonally divided) with upper half nans, and lower zeros
    nansMatrix1(nansMatrix1 == 0) = 1;                                      % change zeros to ones
    nansMatrix = repmat(nansMatrix1, 1, 1, length(contactsMat{1}(1,1,:)));  % convert into 3d matrix with the same dimension as contactsMat

    %% Generate keys
    % for connecting the contacts matrix to the ants.
    % Make 2 matrices with consequtive numbers, and then trasform them in the
    % same way the contact matrices will be trasformed.

    key1Temp = linspace(1, numOfAnts, numOfAnts);                           % make an ascending vector on animal numbers
    key1Temp = repmat(key1Temp ,numOfAnts, 1);                              % make a marix out of it
    key2Temp = key1Temp';                                                   % traspose the matrix for the second key matrix
    key1Temp = key1Temp .* nansMatrix1;                                     % mask the matrices
    key2Temp = key2Temp .* nansMatrix1;
    key1 = reshape(key1Temp, [], 1);                                        % reshape the matrices like the contactsMat will be reshaped
    key2 = reshape(key2Temp, [], 1);
    key1(isnan(key1)) = [];                                                 % remove nan columns - like will be done with the contactsMat
    key2(isnan(key2)) = [];

    clearvars nansMatrix1 key1Temp key2Temp

    %% Generate a contacts matrix for each animal
    
    for i = 1:size(contactsMat, 1)                                          % for each file
        for in = 1:size(contactsMat, 2)                                     % for each segment
            contactsMatTemp = contactsMat{i, in};                           % import the relevant part from contactsMat
            contactsMatTemp = contactsMatTemp .* nansMatrix;                % mask the matrix
            contactsMatTemp2 = reshape(contactsMatTemp, [], ...
                size(contactsMatTemp, 3));                                  % reshape the n*n matrix to all possible interactions (16*16 -> 1*120)

            clearvars contactsMatTemp

            contactsMatTemp2 = contactsMatTemp2';                           % transpose the matrix to have rows as frames and cols as interactions)
            contactsMatTemp2(:, all(isnan(contactsMatTemp2))) = [];         % remove nan cols
            [contactFrame, contactIndex] = find(contactsMatTemp2);          % get indices of all contacts
            ant1 = key1(contactIndex);                                      % translate interaction col to the ants in contacts
            ant2 = key2(contactIndex);
            for ind = 1:numOfAnts                                           % collect all contacts per ant
                contactsAntsTemp = ant2(ant1 == ind);
                contactsAntsTemp = [contactsAntsTemp; ant1(ant2 == ind)];
                contactsFramesTemp = contactFrame(ant1 == ind);
                contactsFramesTemp = [contactsFramesTemp; ...
                    contactFrame(ant2 == ind)];
                contactsPerAntTemp = [contactsFramesTemp, contactsAntsTemp];
                contactsPerAnt{i, in, ind} = sortrows(contactsPerAntTemp);

                clearvars contactsPerAntTemp contactsAntsTemp contactsFramesTemp
            end
        end
    end