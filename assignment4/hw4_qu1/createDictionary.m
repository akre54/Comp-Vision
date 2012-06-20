%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create dictionary of features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% From each object class: get 10 images normalized in size, from each image
% filter the image with one filter (3 filters), from each output get 9
% fragments sampling location on a regular grid 3x3 => 10*3*9 = 270
% fragments for each object
%
% Store indices of images used for building the dictionary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

% Load parameters
parameters

% Load database struct
load ('data/databaseStruct');
data.databaseStruct = D;

% Query for images that contain the target class:
[Dc, jc]  = LMquery(D, 'object.name', objects);

% Initialize patch counts
nd = 0;
averageBoundingBox = [];
% Loop for extracting patches to build the dictionary
for i = 1:sampleFromImages
    img = LMimread(D, jc(i), HOMEIMAGES);
    img = uint8(mean(double(img),3));

    % Get tight crop of the centered object to extract patches:
    [newannotation, newimg, crop, scaling, err, msg] = LMcookimage(D(jc(i)).annotation, img, ...
        'objectname', objects, 'objectsize', normalizedObjectSize, 'objectlocation', 'centered', 'maximagesize', normalizedObjectSize + 60);

    [nrows, ncols] = size(newimg);
    if err == 0 | min(nrows,ncols)< min(normalizedObjectSize)

        % Get object polygon and object center coordinates
        [X,Y] = LMobjectpolygon(newannotation, objects); % get object polygon


        % Object center
        cx = round((min(X{1})+max(X{1}))/2);
        cy = round((min(Y{1})+max(Y{1}))/2);
        averageBoundingBox = [averageBoundingBox; min(X{1})-cx max(X{1})-cx min(Y{1})-cy max(Y{1})-cy];

        % segmentation mask
        [x,y] = meshgrid(1:ncols, 1:nrows);
        mask = logical(inpolygon(x, y, X{1}, Y{1}));
        % Sample points from edges within the object mask:
        edgemap = edge(newimg,'canny', [0.001 .01]);
        [yo, xo] = find(edgemap.*mask);
        no = randperm(length(xo(:))); no = no(1:patchesFromExample); % random sampling on edge points
        xo = xo(no); yo = yo(no);

        % keep coordinates within image size:
        xo = max(xo, max(patchSize+1)/2+1);
        yo = max(yo, max(patchSize+1)/2+1);
        xo = min(xo, ncols - max(patchSize+1)/2);
        yo = min(yo, nrows - max(patchSize+1)/2);

        % Get patches from filtered image:
        out = convCrossConv(double(newimg), filters);

        % Crop patches: all filter outputs from each location
        for lp = 1:patchesFromExample
            Lx = 2*abs(xo(lp) - cx)+1;
            gx = zeros(1, Lx); gx((Lx+1)/2 - (xo(lp) - cx)) = 1;
            gx = conv(gx, locSigma);
            gx = gx/sum(gx);

            Ly = 2*abs(yo(lp) - cy)+1;
            gy = zeros(1, Ly); gy((Ly+1)/2 - (yo(lp) - cy)) = 1;
            gy = conv(gy, locSigma);
            gy = gy/sum(gy);

            for lf = 1:Nfilters
                p = patchSize(fix(rand*length(patchSize))+1)-1; % random patch size
                patch  = double(out(yo(lp)-p/2:yo(lp)+p/2, xo(lp)-p/2:xo(lp)+p/2, lf));
                patch  = (patch - mean(patch(:))) / std(patch(:));

                nd = nd+1; % counter of elements in the dictionary

                % Store parameters in dictionary
                dictionary.filter{nd} = filters{lf}; % Filter (feature)
                dictionary.patch{nd}  = patch;       % Patch (template)
                dictionary.location{nd}{1}  = gx;    % Location (part location)
                dictionary.location{nd}{2}  = gy;
                dictionary.imagendx(nd)  = jc(i);    % Index of image source

                figure(2)
                subplot(ceil(sqrt(Npatches)), ceil(sqrt(Npatches)), lf+(lp-1)*Nfilters)
                imagesc(patch); 
                axis('square'); colormap(gray(256)); drawnow
            end
        end

        % Visualize what is done
        figure(1); clf
        subplot(1,2,1)
        LMplot(newannotation, newimg); axis('on');
        plot(cx, cy, 'rs', 'MarkerFaceColor','r')
        plot(xo, yo, 'gs', 'MarkerFaceColor','g')
        subplot(1,2,2)
        imshow(colorSegments(mask)); axis('on')
        drawnow
    end
end

averageBoundingBox = median(averageBoundingBox);
data.dictionary = dictionary;
data.averageBoundingBox = averageBoundingBox;

% SAVE DICTIONARY
save (dataFile, 'data')



