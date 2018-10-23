function [Aprime, AprimeTable] = ConstructAprimeMatrix(Minerals, elementsToUse, mineralToUse)
%ConstructAprimeMatrix Constructs the Aprime matrix for inversion.
%   [Aprime, AprimeTable] = ConstructAprimeMatrix(Minerals, elementsToUse, 
%   mineralToUse)construct the A prime table (without the slack variables)
%   in the Ax = b system.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

% Initialize
nMinerals = numel(mineralToUse);
Aprime = [];

% Build A in Ax=b
for mineralIndex = 1:nMinerals 
   
   % Get current mineral information
   currentMineralName = mineralToUse{mineralIndex};
   mineralInfo = Minerals(currentMineralName,:);
   elementsInMineral = mineralInfo.Composition{1}.Atoms;
   elementsWeights = mineralInfo.Composition{1}.AtomicWeightsWeighted;
   
   % Find the elements that we are using in the mineral
   [Lia,Locb] = ismember(elementsToUse, elementsInMineral);
   Avector = zeros(size(Lia));
   
   % Calculate the A vector the the mineral
   Avector(Lia==1) =  elementsWeights(Locb(Lia==1)) ./ mineralInfo.Weight;
   
   % insert in the matrix
   Aprime(:, mineralIndex) = Avector;
    
end

% Construct the A prime table for visulization
AprimeTable = array2table(Aprime);
AprimeTable.Properties.VariableNames = mineralToUse;
AprimeTable.Properties.RowNames   = elementsToUse;

end