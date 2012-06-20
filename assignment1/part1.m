% CSCI-UA.0480-001 Assignment 1, starter Matlab code
% Adapted from A. Efros
% (http://graphics.cs.cmu.edu/courses/15-463/2010_fall/hw/proj1/)
%
% Part 1: Colorizing the Prokudin-Gorskii photo collection
%
% Adam Krebs (Spring 2012)

% combine 3 different color chanels from image file
%
% Input:
%  imname - input file with 3 separated channels (optional)
% Output:
%   colorim - the assembled image
%
function [colorim] = part1(fullim)

if nargin ~= 1
    fullim = imread('part1_1.jpg');
end

% convert to double matrix (might want to do this later on to save memory)
fullim = im2double(fullim);

% compute the height of each part (just 1/3 of total)
height = floor(size(fullim,1)/3);
% separate color channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

% Align the Red and Blue images to the Green channel
newR = align(R,G);
newB = align(B,G);

% recombine
colorim = cat(3, newR, G, newB);

% show result and save
figure, imshow(colorim);
imwrite(colorim,'pt1-result-output.jpg');

end


%% align img1 to img2
function [output] = align(img1, img2)

img_offset = offset(img1, img2);
output = circshift(img1, img_offset);

end


%% find the minimum offset through sum-squared distance
function [output] = offset(img1, img2)

min = inf; % first result must be less than this val
for x = -10:10
    for y = -10:10 
        tmp = circshift(img1, [x y]);
        ssd = sum(sum((img2-tmp).^2));
        if ssd < min
            min = ssd;
            output = [x y];
        end
    end
end

end



