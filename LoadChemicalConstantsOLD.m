function [Elements, Minerals] = LoadChemicalConstants(chemicalConstantsFile)
%LoadChemicalConstants Loads the chemical constants used in the analysis.
%   [Elements, Minerals] = LoadChemicalConstants(chemicalConstantsFile) 
%   returns two tables: Elements table is the table for elemental
%   properties and Minerals table is the table for the minerals properties.
%   Extra minerals can be added in the Excel file if needed.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

% Read the Excel sheets
[~,~,ElementsRaw] = xlsread(chemicalConstantsFile,'Elements');
[~,~,MineralsRaw] = xlsread(chemicalConstantsFile,'Minerals');

% Create the elements table
Elements = cell2table(ElementsRaw(2:end,2:end));
Elements.Properties.VariableNames = ElementsRaw(1,2:end);
Elements.Properties.RowNames = ElementsRaw(2:end,1);

% Create the minerals table
Minerals = cell2table(MineralsRaw(2:end,2:end));
Minerals.Properties.VariableNames = MineralsRaw(1,2:end);
Minerals.Properties.RowNames = MineralsRaw(2:end,1);
Minerals = AnalyzeMinerals(Elements, Minerals);

end