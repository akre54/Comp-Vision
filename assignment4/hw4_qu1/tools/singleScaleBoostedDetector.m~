function [Score, boundingBox, boxScores] = singleScaleBoostedDetector(img, data, NweakClassifiers)
%
% This runs the detector at single scale.
%
% In order to build a multiscale detectors, you need to loop on scales.
% Something like this:
% for scale = 1:Nscales
%    img = imresize(img, .8, 'bilinear');
%    Score{scale} = singleScaleBoostedDetector(img, data);
% end


% Number of weak detectors:
if nargin < 3
    NweakClassifiers = length(data.detector);
end

% Initialize variables
Score = 0; nwScore = 0;

% Compute all features and reweight features
for j = 1:NweakClassifiers
    % select feature index
    k  = data.detector(j).featureNdx;
    % evaluate feature (weak detector)
    feature = convCrossConv(img, data.dictionary.filter(k), data.dictionary.patch(k), data.dictionary.location(k));
    % compute regression stump
    weakDetector = (data.detector(j).a * (feature > data.detector(j).th) + data.detector(j).b);
    % cumulate to build the strong detector
    Score = Score + weakDetector;
end

% Look at local maximum of output score and output a set of detected object
% bounding boxes.
s = double(Score>0);
s = conv2(hamming(35),hamming(35),s,'same');

BW = imregionalmax(s);
[y, x] = find(BW.*s);

D = dist([x y]'); D = D + 1000*eye(size(D));
while min(D(:))<10
    N = length(x);
    [i,j] = find(D==min(D(:)));
    x(i(1)) = round((x(i(1)) + x(j(1)))/2);
    y(i(1)) = round((y(i(1)) + y(j(1)))/2);
    x = x(setdiff(1:N,j(1)));
    y = y(setdiff(1:N,j(1)));
    D = dist([x y]'); D = D + 1000*eye(size(D));
end

nDetections = length(x);
boundingBox = repmat(data.averageBoundingBox, [nDetections 1]) + [x x y y];
ind = sub2ind(size(s), y, x);
boxScores = s(ind);
