sizeArray = size(infectionsArray);
infectionsMat = nan(sizeArray(1), sizeArray(2), sizeArray(3), sizeArray(4), sizeArray(5), 3, 16, 'single');
for i = 1:sizeArray(1)
    for in = 1:sizeArray(2)
        for ind = 1:sizeArray(3)
            for inde = 1:sizeArray(4)
                for index = 1:sizeArray(5)
                    relevantData = infectionsArray{i, in, ind, inde, index};
                    lengthRelevantData = length(relevantData.times);
                    infectionsMat(i, in, ind, inde, index, 1, 1:lengthRelevantData) = infectionsArray{i, in, ind, inde, index}.infectedAnts;
                    infectionsMat(i, in, ind, inde, index, 2, 1:lengthRelevantData) = infectionsArray{i, in, ind, inde, index}.infectingAnts;
                    infectionsMat(i, in, ind, inde, index, 3, 1:lengthRelevantData) = infectionsArray{i, in, ind, inde, index}.times;
                end
            end
        end
    end
end

