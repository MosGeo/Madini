function [objective] = lossFunc2(x,A,b)

x = x{1,1:end}';

% Number of evaluations
nEvaluations = 1000;

% Parameters
nMinerals = numel(x);
alpha = x(1:nMinerals);

% Draw samples
samples = dirichletSample(nEvaluations, alpha);
% Evaluation
objectives = zeros(nEvaluations,1);
for i = 1:nEvaluations
    left  = A*samples(i,:)';
    right = b;
    objectives(i)   = sum((left-right).^2);
end
% Get the mean
objective = mean(objectives);

% Draw samples
% [meanValue] = dirichletStats(alpha);
% left  = A*meanValue;
% right = b;
% objective = sum((left-right).^2);


end