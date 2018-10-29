function [essentialMinerals] = checkIfElementIsEssential(selectedMinerals, availableElements, essentialElement)


nMinerals = size(selectedMinerals,1);
isElementEssential = false(nMinerals, 1);

for mineralNumber = 1:nMinerals   
    foundElements = analyzeMineralForAvailableElements(selectedMinerals, availableElements, mineralNumber);
    isElementEssential(mineralNumber) = any(ismember(foundElements, essentialElement)) & length(foundElements)==1;
end

essentialMinerals = selectedMinerals(isElementEssential,1);
essentialMinerals = essentialMinerals.Minerals;

end