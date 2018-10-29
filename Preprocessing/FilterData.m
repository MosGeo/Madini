function dataTable = FilterData(dataTable,elementsToUse)
%FilterData Filter data to specific elements.
%   data = FilterData(data, header,elementsToUse) returns filtered data
%   with specific elements and renormalizes the remaining Data.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

%% Main

% Filter data to specific elements
dataTable = dataTable(:,elementsToUse);

% Renormalize the remaining data
dataFilteredNormalized = table2array(dataTable) ./ repmat(sum(table2array(dataTable), 2), 1, size(dataTable,2));

% Insert the normalized data back to the table
dataTable(:,:) = array2table(dataFilteredNormalized);

end