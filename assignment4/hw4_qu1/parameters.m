% LIST OF OBJECTS TO LEARN:
objects = 'screen+frontal-part';
paramfile = 'demoScreen';

%objects = 'car+side-part-occluded';
%paramfile = 'demoCar';

% DATABASES FOLDERS:
% Define the root folder for the images and annotations: 
BASE_DIR = '\\Client\C$\Dropbox/courses/ComputerVision/assignment4/hw4_qu1';
HOMEIMAGES = [BASE_DIR,'/LabelMeDatabase/Images']; 
HOMEANNOTATIONS = [BASE_DIR,'/LabelMeDatabase/Annotations']; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEATURES parameters
normalizedObjectSize = [48 128]; % size of object in a normalized frame (= [max height, max width])

% define a hand-picked set of filters to extract features from images:
filters = {[1], ...                  % original image
    [1 2 1;0 0 0; -1 -2 -1]/2, ...   % y derivative
    [1 0 -1; 2 0 -2; 1 0 -1]/2, ...  % x derivative
    [-1 -1 -1; -1 8 -1; -1 -1 -1]};  % laplacian
patchSize = [9:2:25]; % size of patch templates

sampleFromImages = 8; % Number of images used to build the dictionary of patches. The images selected will not be used for training or test.
patchesFromExample = 20; % Number of patches to be extracted from every image.
locSigma = exp(-(-7:7).^2/7^2); % spatial filtering of the correlation score.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parameters for precomputed features
trainingImageSize = [128 200];  % size of the images used for training
negativeSamplesPerImage = 30;    % number of background samples extracted from each image
%NsamplesPerClass = 200;         % number of training images
testImageSize = [256 256];      % size of the images used for test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Training parameters
numTrainImages  = 100;        % number of object training instances, per category

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute some common variables:
Nfilters = length(filters);
Npatches = patchesFromExample * Nfilters;
dataFile = fullfile('data', paramfile);




