function composition  = DeconstructFormula(chemicalFormula)
%DeconstructFormula Deconstruct a mineral to its elements with proportions.
%   [composition] = DeconstructFormula(chemicalFormula) returns the
%   structure (compostion) which consists of elements and their number of
%   atoms in a given mineral (chemicalFormula. The chemical formula is case
%   sensitive. The chemical formula cannot contain parentheses that are 
%   inside other parentheses.
%   e.g. DeconstructFormula('Ca5(PO4)3OH')
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017


% Initialize
atoms = [];
nAtoms = [];

% Find all parentheses
parenthesesExpression = '\([a-zA-Z0-9.]*\)[0-9.]*';
[startIndexPar,endIndexPar] = regexp(chemicalFormula,parenthesesExpression);

% A variable for tracking elements not analyzed
remainingChars = 1:numel(chemicalFormula);

% Deal with each parentheses term
for iPar = 1:numel(startIndexPar)
    chemicalFormulaPar = chemicalFormula(startIndexPar(iPar):endIndexPar(iPar));
    remainingChars(ismember(remainingChars,startIndexPar(iPar):endIndexPar(iPar))) = [];
    [elements, number] = DeconstructParanthesis(chemicalFormulaPar);
    atoms = [atoms elements];
    nAtoms = [nAtoms number];
end

% Deal with what is left outside the parentheses
[elements, number] = DeconstructElements(chemicalFormula(remainingChars));
atoms = [atoms elements];
nAtoms = [nAtoms number];

% Consolidate atoms if needed
[atoms, nAtoms] = ConsolidateAtoms(atoms, nAtoms) ;

% Return the results
composition.Atoms = atoms;
composition.nAtoms = nAtoms ;

%% Subfunctions
    % =====================================================================
    % Consolidate Atoms
    function [atomsU, nAtomsU] = ConsolidateAtoms(atoms, nAtoms)
        [C,~,ic] = unique(atoms);
        
        nAtomsU = zeros(1,numel(C));
        atomsU = [];
        
        for i = 1:numel(C)
            atomsU{i} = C{i};
            nAtomsU(i) = sum(nAtoms(ic==i));
        end  
    end



    % =====================================================================
    % Analyze forumula under paranthesis
    function [elements, number] = DeconstructParanthesis(chemicalFormulaPar)
       elements =[];
       number = [];
        multiplierExpression = '\)[0-9.]+';
       [startIndex,endIndex] = regexp(chemicalFormulaPar,multiplierExpression);
       
       % Obtain the multiplier of the paranthesis
       if (startIndex == endIndex)
           multiplier = 1;
       else
           multiplier = str2double(chemicalFormulaPar(startIndex+1:endIndex));
       end
       
       % Obtain the text and analyze
       if (startIndex ==2)
           return;
       else
           chemicalFormulaElem = chemicalFormulaPar(2:startIndex-1);
           [elements, number] = DeconstructElements(chemicalFormulaElem);
           number = number * multiplier;
       end     
    end


    % =====================================================================
    % Deconstruct elements group
    function [elements, number] = DeconstructElements(chemicalFormulaElem)
        elementExpression = '[A-Z][a-z]*[0-9.]*';
        [startIndex,endIndex] = regexp(chemicalFormulaElem,elementExpression);
        
        elements =[];
        number = [];
        
        for i = 1:numel(startIndex)
            selectedElement = chemicalFormulaElem(startIndex(i):endIndex(i));
            numberExpression = '[0-9.]+';
            [startIndexNumber,endIndexNumber] = regexp(selectedElement,numberExpression);
            if numel(startIndexNumber) == 0
                number(i) = 1;
                elements{i} = selectedElement;             
            else
                number(i) = str2double(selectedElement(startIndexNumber:endIndexNumber));
                elements{i} = selectedElement(1:startIndexNumber-1);             
            end
        end
        
    end


end

