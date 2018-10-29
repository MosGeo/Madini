function Minerals = AnalyzeMinerals(Elements, Minerals)
%AnalyzeMinerals Perform full analysis on given minerals.
%   Minerals = AnalyzeMinerals(Elements, Minerals) perform full analysis
%   on the given minerals table including deconstructing the minerals into
%   elements, calculating the molecular weight and calculating the
%   proprotion of each element in the mineral.
%   structure (compostion) which consists of elements and their number of
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

%% Main

% Go through the the given minerals
nMinerals = size(Minerals,1);
Minerals.Composition = cell(nMinerals,1);
Minerals.Weight = zeros(nMinerals,1);

for mineralNumber = 1:nMinerals
    % Deconsutruct the formula
    composition  = DeconstructFormula(Minerals.Formula{mineralNumber});
    % Calculate the elemental proportions and weights
    composition = CalculateMolecularWeight(composition, Elements);    
    % Store teh results in teh minerals table
    Minerals.Composition{mineralNumber} = composition;
    Minerals.Weight(mineralNumber) = sum(composition.AtomicWeightsWeighted);
end

end