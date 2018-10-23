function [resultsTable, inputTable] = InvertToMinerals(Aprime, data, mineralToUse, isRemoveBad)
%InvertToMinerals Inverts the data from elements to minerals.
%   [resultsTable] = InvertToMinerals(Aprime, data, mineralToUse, 
%   sampleNames) Inverts the data to minerals using a linear problem Ax=b.
%   Note: Slack variables are added to the A matrix.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017


dataToAnalyze = table2array(data);
nMinerals = size(Aprime,2);
nSamples = size(dataToAnalyze,1);
nElements = size(dataToAnalyze,2);

if exist('isRemoveBad', 'var')== false; isRemoveBad=true; end;

% Make sure the data is normalized
dataToAnalyze = dataToAnalyze ./ repmat(sum(dataToAnalyze,2),1,nElements);

% Define the objective function
f = [-1*ones(1,nMinerals) +1*ones(1, nMinerals)]';

% Insert slack variables into Aprime
A = [Aprime eye(size(Aprime))];

% Boundary Conditions for each variable
lb = zeros(1,2*nMinerals);
ub = ones(1,2*nMinerals);

% Sum Condition
Aeq = [ones(1,nMinerals) zeros(1, nMinerals)];
beq = [1];

% Initialize the results matrix
results = zeros(nSamples, nMinerals);

sampleNamesCells = data.Properties.RowNames ;

for sampleNumber = 1:nSamples   
    % Define b
    bprime = dataToAnalyze(sampleNumber,:);
    b = bprime';
    %xInitial = mldivide(Aprime,b);

    % Optimization options ('dual-simplex', 'interior-point')
    opts = optimoptions('linprog','Algorithm','interior-point', 'Display', 'off');

    % Run the optimization
    opts.TolFun = 10^-8;
    [x,fval,exitflag,output,lambda]=linprog(f,A,b,Aeq,beq,lb,ub, [], opts);

    % Put the results in the results matrix
    if isempty(x) == false
        results(sampleNumber, :) = (x(1:end/2)');
    end
end


% Construct the results table
resultsTable = array2table(results);
resultsTable.Properties.VariableNames = mineralToUse;
resultsTable.Properties.RowNames   = sampleNamesCells;

inputTable = data;

if isRemoveBad==true
   indexToRemove = sum(resultsTable{:,:},2) == 0;
   resultsTable = resultsTable(~indexToRemove,:);
   inputTable = data(~indexToRemove,:);
end


end