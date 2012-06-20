% Part 4:  Image alignment
%
% by Adam Krebs (Spring 2012)

% Simple driver function for Assignment 1 part 4
%
% Input:
%   img1 - the full size image (default: scene.pgm)
%   img2 - the partial search image (default: book.pgm)
%
% Output:
%   finalImg - the final transformed image
%   H - the homography matrix
%

function [finalImg, H] = part4(img1, img2) 

% save current directory and change to project4 if needed
[path, currentdir, ~] = fileparts(pwd);
if ~strcmpi(currentdir, 'part4pkg')
    cd('part4pkg');
end

% set defaults
if nargin == 0
    img1 = 'scene.pgm';
    img2 = 'book.pgm';
end

% find local image regions and characterize appearance using shift library
[sc_img, sc_desc, sc_locs] = sift(img1);
[bk_img, bk_desc, bk_locs] = sift(img2);

% run k-nearest neighbors
[idx, dists] = knnsearch(sc_desc, bk_desc);

% remove elements over the threshold
toobigs = [];

for i=1:length(dists)
    if dists(i) > .9
        toobigs(end+1) = dists(i);
    end
end

% remove large elements from list
dists=dists(setdiff(1:length(dists),toobigs));

scatterplot(dists);

RANSAC(dists, [], 100, 300, 0.95, 20);


% return to original directory
cd(strcat(path, '/', currentdir));

end