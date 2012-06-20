% RANSAC code
% adapted from en.wikipedia.org/wiki/RANSAC#The_algorithm
% 
% By Adam Krebs, Spring 2012


% Input:
%     data - a set of observations
%     model - a model that can be fitted to data 
%     P - the minimum number of data required to fit the model
%     n - the number of iterations performed by the algorithm
%     t - a threshold value for determining when a datum fits a model
%     d - the number of close data values required to assert that a model fits well to data
%
% Output:
%     best_model - model parameters which best fit the data (or nil if no good model is found)
%     best_consensus_set - data points from which this model has been estimated
%     best_error - the error of this model relative to the data 

function [best_model, best_consensus_set, best_error] = RANSAC(data, model, s, n, t, d)

iter = 0;
best_model = [];
best_consensus_set = [];
best_error = inf;
while iter < n 
    % make matrix for linear system 
    X = randsample(s, data);
    
    maybe_model = fit (data, model);
    
    consensus_set = X;

    for i=1:length(data)
        if ~ismember(data(i), X)
            STD = pdist([data(i), polyval(maybe_model, i)]);
            if STD < t
                consensus_set(end+1) = data(i); % append
            end
        end
    end
    
    if length(consnsus_set) < d
       % looks like we've got a good model 
       y = erf(X);
       model = polyfit (X, y);
       if this_error < best_error
           % found our best model so far
           best_model = this_model;
           best_consensus_set = consensus_set;
           best_error = this_error;
       end
    end
    
    iter = iter + 1;
end

%use homography matrix
H = [ q(1) q(2) q(5) ; q(3) q(4) q(6) ; 0 0 1 ];
transformed_image = imtransform(im1,maketform('affine',H'));
imshow(transformed_image);
end


% Solve system of equations to find the probable model
% maybe_modle = [est_gradient, est_intercept]
function [maybe_model] = fit (X, y)
    maybe_model = inv(X'*X)*X'*y(:);
    maybe_model = pinv(X) * y(:);
    maybe_model = X \ y(:);
end