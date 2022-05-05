%% Extract proportion of time spent in the nest to later analyse in R

%% ad NaNs into in Nest
inNest2 = copyNans(xy, inNest); %copy NaNs into Nest

for w = 1:length(inNest2(:,1))
    for n = 1:length(inNest2) % loop to calculate mean time spent in the nest
        extractedValues{n,1} = mean(inNest2{w,n},"omitnan"); % code omits NaNs;
        extractedValues2(n,:) = cell2mat(extractedValues(n));% save output in right form
    end
    filename = fullfile('/Users/stephanie/Dropbox/Stipend_MPI/Tracking/Results_Nest',names{1, w}); %attach folderpath to filename
    save(filename,'extractedValues2');
end
