function [  ] = PlotResultsTable(resultsTable, smoothingWindow, inputTable)
%PlotResultsTable Plots the results.
%   [  ] = PlotResultsTable(ResultsTable) Plots the results. 
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

if exist('smoothingWindow', 'var') == false
    smoothingWindow =1;
end

% Retrieve headers and sample names from the results table
sampleNames = resultsTable.Properties.RowNames;
mineralsToUse =  resultsTable.Properties.VariableNames;
nMinerals = numel(mineralsToUse);

if exist('inputTable', 'var') == true
    elementsToUse = inputTable.Properties.VariableNames;
    nElements = numel(elementsToUse);
else
    nElements = 0;
end

% Create Sample numbers if the samples names are string
cellsNumbers = cellfun(@str2num,sampleNames, 'UniformOutput', false);
isNotNumber = cellfun(@isempty, cellsNumbers);

if sum(isNotNumber) > 1
   sampleNames = 1:numel(sampleNames);
else
    sampleNames = cellfun(@str2num,sampleNames);
end


% Plot results
figure('Color', 'White', 'Name', 'Mineral Estimation Results', 'NumberTitle', 'off', 'ToolBar', 'None', 'Units', 'Normalized', 'Position',[.15 .15 .7 .7])

if exist('inputTable', 'var') == true
for elemNumber = 1:nElements
    subplot(1,nMinerals+nElements,elemNumber)
    plot(smooth(inputTable{:,elementsToUse{elemNumber}},smoothingWindow), sampleNames, 'LineWidth', 2, 'Color', 'Red');
    title(elementsToUse{elemNumber});
    set (gca,'ydir','reverse')
    if elemNumber>1;     set(gca,'yticklabel',[]); end
    axis tight;
end
end


for minNumber = 1:nMinerals
    subplot(1,nMinerals+nElements,minNumber+nElements)
    plot(smooth(resultsTable{:,mineralsToUse{minNumber}},smoothingWindow), sampleNames, 'LineWidth', 2);
    title(mineralsToUse{minNumber},'Interpreter', 'none');
    set (gca,'ydir','reverse')
    if minNumber~=1 || nElements ~=0; set(gca,'yticklabel',[]); end
    axis tight;
end

end

