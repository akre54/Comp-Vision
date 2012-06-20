% CSCI-UA.0480-001 Assignment 3
%
% Part 1: Face Recognition
%
% Adam Krebs (Spring 2012)


function [] = part1(K)

if nargin < 1
    K = 20
else
    K = K
end

load ORL_32x32.mat
load train_test_orl.mat;


% Split fea and gnd into training and test sets using the indices in
% trainIdx and testIdx.

feaTrain = fea(trainIdx,:);
gndTrain = gnd(trainIdx,:); 
feaTest = fea(testIdx,:);
gndTest = gnd(testIdx,:); 


% Scale the images so that the intensities range from 0 to 1.

feaTrain = mat2gray(feaTrain);
feaTest = mat2gray(feaTest);


% Center the training data, so that the per-pixel mean of across all images
% is zero.

ftrain = rot90(feaTrain);
ppmean = mean(ftrain,2);
centered = ftrain - repmat(ppmean, 1, size(ftrain,2));


% Form C, the 1024 by 1024 covariance matrix.

C = centered * centered';


% use eigs function to compute the first K principal components v of C
[v,d] = eigs(C,K);


% plot principal components
eigenfaces = rot90(v,2);
figure; montage(reshape(eigenfaces,[32 32 1 K]));


% project the centered training data into the PCA space using the
% principal components, yielding descriptors p.
p = centered' * eigenfaces;

% reconstruct face by projecting back into the image space
face = p * v';
face = rot90(face);
face = face + repmat(ppmean, 1, size(face,2));


% center and project test data into PCA space
ftest = rot90(feaTest);
ppmean = mean(ftest,2);
centeredtest = ftest - repmat(ppmean, 1, size(ftest,2));
q = centeredtest' * eigenfaces;


% Perform nearest-neighbor search to find closest Euclidean descriptor in p
[idx, dist] = knnsearch(p,q,'dist','euclidean','k',K);
result = [];
for j=1:size(idx,1)
    check = idx(j,1);
    result = [result;gndTrain(check,:)];
end


% measure fraction correctly classified
matches = 0;
for j = 1: size(result)
    matches = matches + ( result(j) == gndTest(j) );
end
total = size(result,1);
percent = round((matches / total) * 100);
title(sprintf('Matched %i of %i (%i%%)',matches,total, percent));


end