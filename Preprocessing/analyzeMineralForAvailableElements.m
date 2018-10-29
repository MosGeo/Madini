function foundElements = analyzeMineralForAvailableElements(Minerals, availableElements, mineralNumber)


if exist('mineralNumber' , 'var') == false; mineralNumber=  1; end

composition = Minerals.Composition{mineralNumber};
atoms = composition.Atoms;
foundElementsIndex = ismember(atoms, availableElements);
foundElements = atoms(foundElementsIndex);

end