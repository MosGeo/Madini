function [Elements, Minerals] = LoadChemicalConstants(elementsFileName, mineralFileName)
%LoadChemicalConstants Loads the chemical constants used in the analysis.
%   [Elements, Minerals] = LoadChemicalConstants(chemicalConstantsFile) 
%   returns two tables: Elements table is the table for elemental
%   properties and Minerals table is the table for the minerals properties.
%   Extra minerals can be added in the Excel file if needed.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

% Read the Excel sheets
[Elements] = readtable(elementsFileName, 'ReadRowNames',true);
[Minerals] = readtable(mineralFileName, 'ReadRowNames',true);

end