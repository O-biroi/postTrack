function [network] = calNetwork(contactsMat)
%CALCENTRALITY calculate the centrality of each
% ant based on the contact matrix
for i = 1:length(contactsMat)
    network{i,:} = sum(contactsMat{i}, 3);
end
end

