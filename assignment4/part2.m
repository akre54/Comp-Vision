% CSCI-UA.0480-001 Assignment 4
%
% Part 2: Mean Shift Image Segmentation
%
% Adam Krebs (Spring 2012)

function [segmented_im] = part2(input_im,window_size)
  
convergence_threshold = 1e-2;
cluster_quantization = 5; %% larger means fewer clusters

if (nargin==1) % default
  window_size = 0.5;
end

%% get image size
[imy,imx,imc] = size(input_im);
nPixels = imx*imy;

%% convert image to 0..1
input_im = double(input_im)/255;

%% convert to LCBCr
ycbcr_im = rgb2ycbcr(input_im);

%% turn into nPixelsx3 matrix
pixels = reshape(ycbcr_im,[nPixels imc]);

% scale so that each dimension has the same variance
tmp = std(pixels,[],1);
pixels = pixels ./ (ones(nPixels,1)*tmp);

%% setup array for results...
stationary_points = zeros(nPixels,imc);

%% main loop
for i=1:nPixels
    
  % take a single pixel
  probe_pixel = pixels(i,:);
  
  % setup for mean shift on this pixel
  converged = 0;
  % initialize center
  center = probe_pixel;

  % now run until convergence
  while ~converged
    
    % get all points within window size
    % [x,y]=meshgrid(-(center(2)-1):(imx-center(2)),-(center(1)-1):(center(1)-cy));
    % c_mask=((x.^2+y.^2)<=window_size^2);
    
    dist = compute_L2_dist(center, pixels);
    idx = find(dist <= window_size);
    %idx = rangesearch(pixels, center, window_size);
    
    % now update center location
    idx_mean = mean(pixels(idx,:),1);
    new_center = idx_mean; 
    
    % check to see if we are converged
    if (compute_L2_dist(center,new_center)<convergence_threshold)
      converged = 1;
    end
  
    % move to new center
    center = new_center;
        
  end
  
  % store the point we ended up at
  % this should be an nPixels by 3 array which stores the final location of the center (for each pixel)
  stationary_points(i,:) = new_center;
   
  if (mod(i,1000)==0)
    fprintf('%d.',i);
  end
  
end

fprintf('\n');

% now find unique clusters by rounding
rounded_points = round(stationary_points * cluster_quantization);

% get unique points left
% unique doesn't work on anything other and 1D data, so hack it...
tmp_points = rounded_points(:,1) + 100*rounded_points(:,2) + 10000*rounded_points(:,3);
[tmp_clusters,~,cluster_idx] = unique(tmp_points);
segmented_im = reshape(cluster_idx,[imy imx]);

figure; 
subplot(1,2,1); imagesc(input_im); axis equal; axis off; title('Input');
subplot(1,2,2); imagesc(segmented_im); axis equal; axis off; title('Segmented');





function dist_out = compute_L2_dist(center,points)
  % assume center is 1 x ndims
  % assume points are nPoints x ndims  
  
  dist_out = sqrt(sum((points - repmat(center,[size(points,1) 1])).^2,2));
  
  
return 
