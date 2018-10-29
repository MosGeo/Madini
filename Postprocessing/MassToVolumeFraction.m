function [resultsTable, results] = MassToVolumeFraction(massFractionTable, Minerals)
%MassToVolumeFraction Converts mass fraction to volume fraction.
%   [results, resultsTable] = MassToVolumeFraction(massFraction, Mineral) 
%   converts the volumetric fraction to a mass fraction.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   April, 2017

% Prepare variables
mineralToUse = massFractionTable.Properties.VariableNames;
nSamples = size(massFractionTable,1);
nMinerals = numel(mineralToUse);
densityMatrix = repmat(Minerals{mineralToUse,'Rho'}', nSamples, 1);
massMatrix = massFractionTable{:,:};

% Calculate
volumeMatrix = massMatrix ./ densityMatrix;
sumMatrix = repmat(sum(volumeMatrix,2),1,nMinerals);
volumeFractionMatrix = volumeMatrix ./ sumMatrix;
volumeFractionMatrix(isnan(volumeFractionMatrix)) = 0;

% Store Results
resultsTable = massFractionTable;
resultsTable{:,:} = volumeFractionMatrix;
results = resultsTable{:,:};

end