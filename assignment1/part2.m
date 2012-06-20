% Part 2: Harris Corner Detection
% 
% by Adam Krebs (Spring 2012)

% 
%
% Input:
%   im - the input image in greyscale / 2D array
%   threshold - "cornerness" threshold
%   sigma - std deviation of Gaussian used to smooth 2nd moment matrix
%   radius - radius of non-maximal suppression
%
% Output:
%   img - the output image
%   corners - a 2 x N matrix of corner locations
%

function [img, corners] = part2(im, threshold, sigma, radius)

% Define the filters as Sobel operator
dx = [ -1 0 1 ; -2 0 2 ; -1 0 1];
dy = diff(dx);

% Compute image derivates
Ix = conv2(double(im), dx, 'same');
Iy = conv2(double(im), dy, 'same');

% Generate Gaussian smoothing filter
G = fspecial('gaussian', (6*sigma), sigma);

% Compute the Squares of Ix and Iy, and Ixy
Ixx = Ix.^2;
Iyy = Iy.^2;
Ixy = Ix .* Iy;

% Compute smoothed versions
Sixx = conv2(Ixx, G, 'same');
Siyy = conv2(Iyy, G, 'same');
Sixy = conv2(Ixy, G, 'same');

% Compute cornerness measure M
M = (Sixx.*Siyy - Sixy.^2) - 0.04*(Sixx+Siyy).^2;

% Perform non-maximal surpression
nonmax = ordfilt2(M, radius^2, ones([radius radius]));

% Find the coordinates of the corner points
corners = (M == nonmax) & (nonmax > threshold);
[row, col] = find(corners);

% Display image and superimpose corners
figure, imshow(im);

% superimpose onto same plot
hold on;
p=[col row];
corners = plot(p(:,1),p(:,2),'or');
hold off;

F=getframe;
img = frame2im(F);
end