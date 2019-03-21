function [resultsTable, inputTable] = InvertToMinerals(Aprime, data, mineralToUse, isRemoveBad)
%InvertToMinerals Inverts the data from elements to minerals.
%   [resultsTable] = InvertToMinerals(Aprime, data, mineralToUse, 
%   sampleNames) Inverts the data to minerals using a linear problem Ax=b.
%   Note: Slack variables are added to the A matrix.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2017

%% Preprocessing

% Defaults
if exist('isRemoveBad', 'var')== false; isRemoveBad=true; end


%% Main

dataToAnalyze = table2array(data);
nMinerals = size(Aprime,2);
nSamples = size(dataToAnalyze,1);
nElements = size(Aprime,1);

% Make sure the data is normalized
dataToAnalyze = dataToAnalyze ./ repmat(sum(dataToAnalyze,2),1,nElements);

if isUseSlack
    % Define the objective function
    f = [-1*ones(1,nMinerals) 1*ones(1, nElements)]';
    % Insert slack variables into Aprime
    A = [Aprime eye(nElements)];
    % Boundary Conditions for each variable
    lb = zeros(1,nElements+nMinerals);
    ub = ones(1,nElements+nMinerals);
    % Sum Condition
    Aeq = [ones(1,nMinerals) zeros(1, nElements)];
    beq = [1];
else
    f = -1*ones(1,nMinerals);
    A = Aprime;
    lb = zeros(1,nMinerals);
    ub = ones(1,nMinerals);
    % Sum Condition
    Aeq = ones(1,nMinerals);
    beq = [1];
end


% Initialize the results matrix
results = zeros(nSamples, nMinerals);
sampleNamesCells = data.Properties.RowNames ;

for sampleNumber = 1:nSamples   
    % Define b
    bprime = dataToAnalyze(sampleNumber,:);
    b = bprime';

    % Optimization options ('dual-simplex', 'interior-point')
    opts = optimoptions('linprog','Algorithm','interior-point', 'Display', 'iter');
    %opts = optimoptions('Display', 'off');

    % Run the optimization
    opts.TolFun = 10^-10;
    [x,fval,exitflag,output,lambda]=linprog(f,A,b,Aeq,beq,lb,ub, [], opts);

    % Put the results in the results matrix
    if isempty(x) == false
        results(sampleNumber, :) = (x(1:nMinerals)');
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