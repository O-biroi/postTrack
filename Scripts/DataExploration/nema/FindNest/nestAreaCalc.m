function nest = nestAreaCalc(activeArea, spatialHist, nestThresh, smoothSigma, minNestSize)

nest = cell(size(spatialHist));                                                 % create empty variable

for i = 1:size(spatialHist,1)
    for day = 1:size(spatialHist,2)
    nestTemp = zeros(size(spatialHist{i,day}));                                         % create empty variable
    
    %% Define nest area
    smoothedSpatialHist = imgaussfilt(nthroot(spatialHist{i,day}, 2), smoothSigma);                 % smooth the spatial histogram
    smoothedSpatialHist = smoothedSpatialHist ./ max(max(smoothedSpatialHist));     % normalize the spatial histogram to the maximum value
    %nestTemp(smoothedSpatialHist > nestThresh) = 1;                                 % define as nest any pixel with values larger than the nestThresh
    nestTemp(smoothedSpatialHist > prctile(smoothedSpatialHist, nestThresh,'all')) = 1; %Use the top 10% bins instead of original system 
    %% Seperate nest to different nests
    bw = bwlabel(nestTemp,4);                                                         % unattached nest areas get different numbers on the image
    [groupCount, groupIndex] = groupcounts(bw(:));                                  % make bw to a vector, and count the pixel amount of each nest (groupCount) and its number(groupIndex)
    groupCount(groupIndex == 0) = [];                                               % remove group 0 - this is the background where there is no nest
    groupIndex(groupIndex == 0) = [];                                               % remove group 0
    
    smallNests = groupCount < minNestSize;                                          % define small nests under threshold pixels
    if any(smallNests)                                                              % in case there are small nests
        %       
        %nestTemp(ismember(bw, groupIndex(smallNests))) = 0;                         % erase them from the image
        bw(ismember(bw, groupIndex(smallNests))) = 0;
    end
    
    nestNumbersTemp = unique(bw);
    for in = 2 : length(nestNumbersTemp)                                            % for each nest (starting from 2 to ignore nest 0 - background)
        bw(bw == nestNumbersTemp(in)) = in - 1;                                     % arrange nests' numbers as running numbers
    end
    
    nest{i,day} = bw;                                                       % create nest image - seperated nest recive different values
    nest{i,day}(activeArea{i,day} == 0) = nan;                                              % maintain only the active arena area
    
    
    clear smoothedStandSpatial smoothedRunSpatial bw groupCount groupIndex nestTemp bw nestNumbersTemp
    end
end
end


