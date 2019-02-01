function [ selectedMinerals ] = selectMineralsByName( Minerals, selectedMineralsNames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Main

selectedMinerals = Minerals(ismember(Minerals.Minerals, selectedMineralsNames),:);


end

