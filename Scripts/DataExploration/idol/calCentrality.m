function [centrality] = calCentrality(network, type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if type == "degree"
    for i = 1:length(network)
        centrality{i,:} = sum(network{i}'+triu(network{i}',1)', 1);
    end
end

end

