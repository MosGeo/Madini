function composition =  CalculateMolecularWeight(composition, Elements)
%CalculateMolecularWeight Calculates the molecular weight in the mineral.
%   [composition] =  CalculateMolecularWeight(composition, Elements)
%   Calculates the weight of each element in the mineral. 
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

% Retrieve the informations
atoms = composition.Atoms;
nAtoms = composition.nAtoms;

% Get the atomic weights
selectedElements = Elements(atoms,:);
atomicWeights = selectedElements.Weight;

% Weight by the number of atoms
atomicWeightsWeighted = atomicWeights .* nAtoms';

% Store the results
composition.AtomicWeightsWeighted = atomicWeightsWeighted;
composition.AtomicWeights =  atomicWeights;

end