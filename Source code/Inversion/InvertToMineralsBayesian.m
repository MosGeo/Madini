function [resultsTable, inputTable] = InvertToMineralsBayesian(Aprime, data, mineralToUse, priors, isRemoveBad)
%InvertToMinerals Inverts the data from elements to minerals.
%   [resultsTable] = InvertToMinerals(Aprime, data, mineralToUse, 
%   sampleNames) Inverts the data to minerals using a linear problem Ax=b.
%   Note: Slack variables are added to the A matrix.
%
%   Mustafa Al Ibrahim (Mustafa.Geoscientist@outlook.com)
%   Febuary, 2019

%% Preprocessing

% Defaults
if exist('isRemoveBad', 'var')== false; isRemoveBad=true; end

%% Main

dataToAnalyze = table2array(data);
nMinerals = size(Aprime,2);
nSamples = size(dataToAnalyze,1);
nElements = size(dataToAnalyze,2);

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

% Define the paramters
clear prior
for i = 1:(nMinerals*2)
    prior(i) = optimizableVariable(['n' num2str(i)],[0,1]);
end

for i = (nMinerals+1):(nMinerals*2)
    prior(i) = optimizableVariable(['n' num2str(i)],[0,.05]);
end

for sampleNumber = 1:nSamples   
    % Define b
    bprime = dataToAnalyze(sampleNumber,:);
    b = bprime';
    
    % Optimization options ('dual-simplex', 'interior-point')
    opts = optimoptions('linprog','Algorithm','interior-point', 'Display', 'off');
    opts.TolFun = 10^-10;
    [x,fval,exitflag,outputLinearProg,lambda]=linprog(f,A,b,Aeq,beq,lb,ub, [], opts);
    InitialX = num2cell(x');
    
    nEval = 50;
    fun = @(x) lossFunc(x,A,b);
    resultsBays = bayesopt(fun,prior, 'InitialX',  InitialX,'Verbose',1,'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations', nEval);
    output = resultsBays.XAtMinObjective{1,:};
    output(1:nMinerals) = output(1:nMinerals)/sum(output(1:nMinerals));
    outputDeterminestic = x';
    
    outputAll = resultsBays.XTrace{:,:}./sum(resultsBays.XTrace{:,:},2);
    meanSol = mean(outputAll);
    stdSol  = std(outputAll);
    negError = stdSol; negError((meanSol-stdSol)<0)=meanSol((meanSol-stdSol)<0);
    posError = stdSol; posError((meanSol-stdSol)>1)=1-meanSol((meanSol-stdSol)>1);
    figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
    errorbar(1:numel(meanSol),meanSol,negError,posError,'o', 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red', 'LineWidth',3); hold on;
    xlabel('Mineral'); ylabel('Proportion');
    set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times');
    plot(outputDeterminestic(1:nMinerals), 'x', 'MarkerSize',15, 'MarkerEdgeColor','k');
    legend({'Bayesian optimizaiton', 'Linear programming'});
    
    figure('Color', 'White', 'Units','inches', 'Position',[3 3 7 4],'PaperPositionMode','auto');
    for i=1:nMinerals
        histogram(outputAll(:,i), 10); 
        hold on
        legendText{i} = num2str(i);
    end
    xlim([0,1])
    legend(legendText)

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


