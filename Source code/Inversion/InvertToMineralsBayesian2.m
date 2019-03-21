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
results = zeros(nSamples, nMinerals*3);
sampleNamesCells = data.Properties.RowNames ;

% Define the paramters
clear prior
for i = 1:(nMinerals)
    prior(i) = optimizableVariable(['n' num2str(i)],[1,3]);
end

%%
sampleNumber = 60

% Define b
    bprime = dataToAnalyze(sampleNumber,:);
    b = bprime';
    
    % Optimization options ('dual-simplex', 'interior-point')
    opts = optimoptions('linprog','Algorithm','interior-point', 'Display', 'off');
    opts.TolFun = 10^-10;
    [x,fval,exitflag,outputLinearProg,lambda]=linprog(f,A,b,Aeq,beq,lb,ub, [], opts);
    x = x(1:nMinerals);
    InitialX = num2cell(x');
    
    nEval = 50;
    fun = @(x) lossFunc2(x,Aprime,b);
    resultsBays = bayesopt(fun,prior, 'InitialX',  InitialX,'Verbose',1,'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations', nEval);
    outputAlpha = resultsBays.XAtMinObjective{1,:};
    output(1:nMinerals) = outputAlpha(1:nMinerals)/sum(outputAlpha(1:nMinerals));
    outputDeterminestic = x';
    
    % All solution analysis
    outputAll = resultsBays.XTrace{30:end,:}./sum(resultsBays.XTrace{30:end,:},2);
    meanSol = mean(outputAll);
    stdSol  = std(outputAll);
    negError = stdSol; negError((meanSol-stdSol)<0)=meanSol((meanSol-stdSol)<0);
    posError = stdSol; posError((meanSol-stdSol)>1)=1-meanSol((meanSol-stdSol)>1);
    figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
    errorbar(1:numel(meanSol),meanSol,negError,posError,'o', 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red', 'LineWidth',3); hold on;
    xlabel('Mineral'); ylabel('Proportion');
    set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times');
    plot(output(1:nMinerals), 's', 'MarkerSize',12, 'MarkerEdgeColor','k');
    plot(outputDeterminestic(1:nMinerals), 'x', 'MarkerSize',15, 'MarkerEdgeColor','k');
    legend({'Bayesian optimizaiton solutions means', 'Baysian optimization best solution mean', 'Linear programming'});
    title('Optimized means')
    xticks([1:(nMinerals)])
    xlim([0,(nMinerals+1)])
    ylim([0,1])
    
    figure('Color', 'White', 'Units','inches', 'Position',[3 3 7 6],'PaperPositionMode','auto');
    for i=1:nMinerals
        subplot(nMinerals,1,i)
        histogram(outputAll(:,i), 10); 
        hold on
        legendText{i} = num2str(i);
        xlim([0,1])
    end
    
    % Best solution analysis
    [output, cova] = dirichletStats(outputAlpha);
    figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
    heatmap(abs(cova))
    
    [R] = dirichletSample(1000, outputAlpha);
    meanSol = mean(R);
    stdSol  = std(R);
    negError = stdSol; negError((meanSol-stdSol)<0)=meanSol((meanSol-stdSol)<0);
    posError = stdSol; posError((meanSol-stdSol)>1)=1-meanSol((meanSol-stdSol)>1);
    figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
    errorbar(1:numel(meanSol),meanSol,negError,posError,'o', 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red', 'LineWidth',3); hold on;
    xlabel('Mineral'); ylabel('Proportion');
    set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times');
    plot(outputDeterminestic(1:nMinerals), 'x', 'MarkerSize',15, 'MarkerEdgeColor','k');
    legend({'Bayesian optimizaiton best', 'Linear programming'});
    xticks([1:(nMinerals)])
    xlim([0,(nMinerals+1)])
    ylim([0,1])
    title('Best solutions')
    
%%

meanSolAll=[];
negErrorAll=[];
posErrorAll=[];

for sampleNumber = 1:nSamples  
    close all
    % Define b
    bprime = dataToAnalyze(sampleNumber,:);
    b = bprime';
    
    % Optimization options ('dual-simplex', 'interior-point')
    opts = optimoptions('linprog','Algorithm','interior-point', 'Display', 'off');
    opts.TolFun = 10^-10;
    [x,fval,exitflag,outputLinearProg,lambda]=linprog(f,A,b,Aeq,beq,lb,ub, [], opts);
    if isempty(x); continue; end
    x = x(1:nMinerals);
    InitialX = num2cell(x');
    
    nEval = 30;
    fun = @(x) lossFunc2(x,Aprime,b);
    resultsBays = bayesopt(fun,prior, 'InitialX',  InitialX,'Verbose',1,'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations', nEval);
    outputAlpha = resultsBays.XAtMinObjective{1,:};
    output(1:nMinerals) = outputAlpha(1:nMinerals)/sum(outputAlpha(1:nMinerals));
    outputDeterminestic = x';
    
    % All solution analysis
    outputAll = resultsBays.XTrace{25:end,:}./sum(resultsBays.XTrace{25:end,:},2);
    meanSol = mean(outputAll);
    stdSol  = std(outputAll);
    negError = stdSol; negError((meanSol-stdSol)<0)=meanSol((meanSol-stdSol)<0);
    posError = stdSol; posError((meanSol-stdSol)>1)=1-meanSol((meanSol-stdSol)>1);
    
%     figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
%     errorbar(1:numel(meanSol),meanSol,negError,posError,'o', 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red', 'LineWidth',3); hold on;
%     xlabel('Mineral'); ylabel('Proportion');
%     set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times');
%     plot(output(1:nMinerals), 's', 'MarkerSize',12, 'MarkerEdgeColor','k');
%     plot(outputDeterminestic(1:nMinerals), 'x', 'MarkerSize',15, 'MarkerEdgeColor','k');
%     legend({'Bayesian optimizaiton solutions means', 'Baysian optimization best solution mean', 'Linear programming'});
%     title('Optimized means')
%     xticks([1:(nMinerals)])
%     xlim([0,(nMinerals+1)])
%     ylim([0,1])
%     
%     figure('Color', 'White', 'Units','inches', 'Position',[3 3 7 6],'PaperPositionMode','auto');
%     for i=1:nMinerals
%         subplot(nMinerals,1,i)
%         histogram(outputAll(:,i), 10); 
%         hold on
%         legendText{i} = num2str(i);
%         xlim([0,1])
%     end
%     
%     % Best solution analysis
%     [output, cova] = dirichletStats(outputAlpha);
%     figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
%     heatmap(abs(cova))
%     
        [R] = dirichletSample(1000, outputAlpha);
        meanSol = mean(R);
        stdSol  = std(R);
        negError = stdSol; negError((meanSol-stdSol)<0)=meanSol((meanSol-stdSol)<0);
        posError = stdSol; posError((meanSol-stdSol)>1)=1-meanSol((meanSol-stdSol)>1);
        
        meanSolAll(sampleNumber,:) = meanSol;
        negErrorAll(sampleNumber,:) = negError;
        posErrorAll(sampleNumber,:) = posError;

%     figure('Color', 'White', 'Units','inches', 'Position',[3 3 6 3],'PaperPositionMode','auto');
%     errorbar(1:numel(meanSol),meanSol,negError,posError,'o', 'MarkerSize',10,'MarkerEdgeColor','red','MarkerFaceColor','red', 'LineWidth',3); hold on;
%     xlabel('Mineral'); ylabel('Proportion');
%     set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times');
%     plot(outputDeterminestic(1:nMinerals), 'x', 'MarkerSize',15, 'MarkerEdgeColor','k');
%     legend({'Bayesian optimizaiton best', 'Linear programming'});
%     xticks([1:(nMinerals)])
%     xlim([0,(nMinerals+1)])
%     ylim([0,1])
%     title('Best solutions')
    
    % Put the results in the results matrix
    if isempty(x) == false
        results(sampleNumber, :) = [meanSolAll(sampleNumber,:), negErrorAll(sampleNumber,:), posErrorAll(sampleNumber,:)];
    end
end

% Construct the results table
resultsTable = array2table(results);
%resultsTable.Properties.VariableNames = mineralToUse;
resultsTable.Properties.RowNames   = sampleNamesCells;

inputTable = data;

if isRemoveBad==true
   indexToRemove = sum(resultsTable{:,:},2) == 0;
   resultsTable = resultsTable(~indexToRemove,:);
   inputTable = data(~indexToRemove,:);
end

end


