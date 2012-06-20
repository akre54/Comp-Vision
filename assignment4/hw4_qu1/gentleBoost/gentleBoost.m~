function classifier = gentleBoost(x, y, Nrounds, plotstyle)
% gentleBoost
%
% features x
% class: y = [-1,1]
%
%

% Implementation of gentleBoost:
% Friedman, J. H., Hastie, T. and Tibshirani, R. 
% "Additive Logistic Regression: a Statistical View of Boosting." (Aug. 1998) 

% atb, 2003

% By default there is no visualization
if nargin < 4; plotstyle = []; end

[Nfeatures, Nsamples] = size(x); % Nsamples = Number of thresholds that we will consider
Fx = zeros(1, Nsamples);
w  = ones(1, Nsamples);

for m = 1:Nrounds
    disp(sprintf('Round %d', m))
    
    % Weak regression stump: It is defined by four parameters (a,b,k,th)
    %     f_m = a * (x_k > th) + b
    [k, th, a , b] = selectBestRegressionStump(x, y, w);
    
    % update parameters classifier
    classifier(m).featureNdx = k;
    classifier(m).th = th;
    classifier(m).a  = a;
    classifier(m).b  = b;
    
    % Updating and computing classifier output on training samples
    fm = (a * (x(k,:)>th) + b); % evaluate weak classifier
    Fx = Fx + fm; % update strong classifier
    
    % Reweight training samples
    w = w .* exp(-y.*fm);
    
    % Plot results on a 2D space
    if size(plotstyle,1)>0; 
        plotw(x(1,:), x(2,:), w, y, plotstyle); 
        pause; 
    end
end

