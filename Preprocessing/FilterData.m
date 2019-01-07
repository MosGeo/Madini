function dataTable = FilterData(dataTable, columnsToUse, isNormalize)
%% FILTERDATA   filter data with specific columns with renormalizes 
%
% dataTable:                Table containing data
% columnsToUse:             Column names to keep
% isRenormalize:            Normalize the remaining columns to 1?
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('isNormalize', 'var'); isNormalize = true; end

% Assertions
assert(exist('dataTable', 'var')== true, 'dataTable must be provided');
assert(istable(dataTable), 'dataTable must be a table');
assert(exist('columnsToUse', 'var')== true, 'columnsToUse must be provided');
assert(iscell(columnsToUse) || ischar(columnsToUse), 'columnsToUse must a string or a cells of strings');
assert(isa(isNormalize, 'logical'), 'isNormalize must be a logical');

%% Main

% Filter data to specific elements
dataTable = dataTable(:,columnsToUse);

if isNormalize == true
    % Renormalize the remaining data
    dataFilteredNormalized = table2array(dataTable) ./ repmat(sum(table2array(dataTable), 2), 1, size(dataTable,2));
    
    % Insert the normalized data back to the table
    dataTable(:,:) = array2table(dataFilteredNormalized);
end

end