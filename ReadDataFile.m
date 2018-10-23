function [header,sampleNames,  dataTable] = ReadDataFile(dataFileName)
%ReadDataFile Loads elemental data file from an Excel spreadsheet.
%   [header,sampleNames,dataTable]= ReadDataFile(dataFileName) returns the
%   header for the file, the sample names and teh complete table of the
%   data (in table format).
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017


% Read the excel Sheet
dataRaw = readtable(dataFileName);

% Construct the complete table
dataTable = cell2table(dataRaw(2:end,2:end));
dataTable.Properties.VariableNames = header;
dataTable.Properties.RowNames   = sampleNamesCells;

end