function [antTableUpdated] = addTableColumns(antTable,Cell4Column,columnName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Column = reshape(cell2mat(Cell4Column).',1,[])';
antTableUpdated = addvars(antTable, Column, 'NewVariableNames', columnName);
end

