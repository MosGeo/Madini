
% Sampling
alpha = 1*[1, 2, 3];
R = dirichletSample(5000, alpha);

% Plotting
figure('Color', 'White')
handles = ternplot(R(:,1), R(:,2), R(:,3), '.');

% Checking the mean
[meanValue, covariance] = dirichletStats(alpha);