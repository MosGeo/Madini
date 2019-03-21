function R = dirichletSample(nSamples, alpha)



%% Preprocessing

if ~exist('nSamples', 'var'); nSamples = 1; end
if ~exist('alpha', 'var'); alpha = [1, 1, 1]; end


%% Main

alpha = alpha(:)';

% Number of components
nComponents = numel(alpha);

% Sample from gamma distribution
alphas = repmat(alpha, [nSamples, 1]);
r = gamrnd(alphas,1, [nSamples, nComponents]);

% Normalize
R = r./sum(r,2);

end