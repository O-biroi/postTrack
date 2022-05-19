function contactsMat = contactsCalc(distancesMat, contactThresh)
    % contactThresh in m (0.001 = 1 mm)
    % contactThresh = 0.002;

    for i = 1:size(distancesMat, 1)                                         % run through all files
        for in = 1:size(distancesMat, 2)                                    % run through all segments
            distMatTemp = distancesMat{i,in};                               % import the relevent part of the distancesMat
            for ind = 1:size(distMatTemp, 1)
                distMatTemp(ind, ind, :) = nan;                             % ignore self-contacts
            end
            contactsMat{i,in} = distMatTemp < contactThresh;                % find contacts - distances smaller than contactThresh
            clearvars distMatTemp
        end
    end

end