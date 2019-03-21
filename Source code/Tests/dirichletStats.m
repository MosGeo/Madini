function [meanValue, covariance] = dirichletStats(alpha)


%% Preprocessing


%% Main

% Number of components
nComponents = numel(alpha);

% Alpha0
alpha0  = sum(alpha);

% Mean
meanValue = alpha./alpha0;

% Covariance initialization
covariance  = zeros(nComponents);

% Covariance diagonal
diagIndex   = eye(nComponents, 'logical');
covariance(diagIndex)  = (alpha.*(alpha0-alpha))/(alpha0^2 *(1+alpha0));

% Covariance non-diagonal (simple for loops for readibility, can be vectorized)
for i = 1:nComponents
    for j = 1:nComponents
       if (i==j); continue; end
       covariance(i,j) = (-alpha(i)*alpha(j))/(alpha0^2 *(1+alpha0));
    end
end

end