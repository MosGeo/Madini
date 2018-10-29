function [Minerals, possibleElements] = getPossibleMinerals(Minerals, availableElements)

nMinerals = size(Minerals,1);
possibleMinerals = false(nMinerals, 1);
possibleElements = {}; 

for mineralNumber = 1:nMinerals   
    foundElements = analyzeMineralForAvailableElements(Minerals, availableElements, mineralNumber);
    possibleMinerals(mineralNumber) = ~isempty(foundElements);
    possibleElements = unique([possibleElements, foundElements]);
end

Minerals = Minerals(possibleMinerals,:);

end