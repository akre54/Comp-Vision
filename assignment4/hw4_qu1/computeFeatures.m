clear all
close all

% Load parameters
parameters

load (dataFile)
dictionary = data.dictionary;
D = data.databaseStruct;

Nfeatures = length(dictionary.filter);
Nsamples = (2*numTrainImages) * (negativeSamplesPerImage+1); % this is an upper bound to the number of samples that will be computed

data.features = zeros([Nsamples, Nfeatures]);
data.class    = zeros(Nsamples, 1);
data.image    = zeros(Nsamples, 1);
data.instance = zeros(Nsamples, 1);
data.location = zeros(Nsamples, 2);

ns = 0; % counter for the number of samples really computed.
% Query for images that contain object class objects{c}:
[Dc, jc]  = LMquery(D, 'object.name', objects);

% Remove images used to create the dictionary:
jc = setdiff(jc, dictionary.imagendx);

i = 0; 
ii = 0;
while ii < numTrainImages & i < length(jc)
    i = i+1;
    img = LMimread(D, jc(i), HOMEIMAGES);
    img = uint8(mean(double(img),3));

    annotation = D(jc(i)).annotation;
    jo = LMobjectindex(annotation, objects);

    % Loop on the number of instances present in each image
    imageUsed = 0;
    for m = 1:length(jo)
        ann = annotation;
        ann.object = ann.object([jo(m) setdiff(jo,jo(m))]);
        % Get tight crop of the centered object to extract patches:
        [newannotation, newimg, crop, scaling, err, msg] = LMcookimage(ann, img, ...
            'objectname', objects, 'objectsize', normalizedObjectSize, 'objectlocation', 'original', 'maximagesize', trainingImageSize);
        [nrows, ncols] = size(newimg);

        if err == 0
            % Get object polygon
            [X,Y] = LMobjectpolygon(newannotation, objects); % get object polygon

            % Check that the object is inside the image. If it is cropped we
            % will not use it for training.
            if min(X{1})>0 & min(Y{1})>0 & max(X{1})<ncols & max(Y{1})<nrows
                imageUsed = 1;
                % Get object polygon, segmentation mask and object center coordinates
                mask = LMobjectmask(newannotation, size(newimg), objects); % get masks

                % Compute features
                out = convCrossConv(double(newimg), dictionary.filter, dictionary.patch, dictionary.location);

                % Sample locations for negative examples where the templates produce strong false
                % alarms.
                score = mean(abs(out),3);
                BW = imregionalmax(score);% + imregionalmin(score);
                [y, x] = find(zeroBoundary(sum(mask,3)==0, 10).*BW);
                [foo, n] = sort(-score(sub2ind(size(score),y,x)));
                n = n(1:min(length(n), negativeSamplesPerImage));
                n = n(randperm(length(n)));
                yn = y(n(1:min(length(n),negativeSamplesPerImage)));
                xn = x(n(1:min(length(n),negativeSamplesPerImage)));
                mi = negativeSamplesPerImage - length(n)';
                if mi > 0
                    [y, x] = find(zeroBoundary(sum(mask,3)==0, 10));
                    n = randperm(length(x));
                    yn = [yn; y(n(1:mi))];
                    xn = [xn; x(n(1:mi))];
                end

                % Store features in background image regions
                for n = 1:negativeSamplesPerImage
                    ns = ns+1;
                    data.features(ns, :) =  out(yn(n), xn(n), :);
                    data.class(ns)       =  -1; % background class
                    data.image(ns)       =  jc(i);
                    data.instance(ns)    =  m;
                    data.location(ns,:)    =  [xn(n) yn(n)];
                end

                % Store features at the center of the object
                % Object center (we could be a bit tolerant with this and
                % search of an object center that is one local maximum of
                % the features score).
                cx = round((min(X{1})+max(X{1}))/2);
                cy = round((min(Y{1})+max(Y{1}))/2);
                [y, x] = find(imregionalmax(score)); rr = sqrt((x-cx).^2 + (y-cy).^2);
                [minr, jm] = min(rr);
                if minr < 9;
                    cx = x(jm);
                    cy = y(jm);
                end

                ns = ns+1;
                data.features(ns, :) =  out(cy, cx, :);
                data.class(ns)    =  1; % object class
                data.image(ns)    =  jc(i);
                data.instance(ns)    =  m;
                data.location(ns,:)    =  [cx cy];

                % Visualize what is done
                figure(1); clf
                subplot(2,2,1)
                LMplot(newannotation, newimg); legend off; axis('on');
                plot(cx, cy, 'rs', 'MarkerFaceColor','r')
                plot(xn, yn, 'gs', 'MarkerFaceColor','g')
                subplot(2,2,2)
                imshow(colorSegments(mask)); axis('on')
                subplot(2,2,3)
                imagesc(score); axis('equal'); axis('tight'); axis('on'); hold on
                plot(cx, cy, 'rs', 'MarkerFaceColor','r')
                plot(xn, yn, 'gs', 'MarkerFaceColor','g')
                title([ii i m])
                drawnow
            end
        else
            disp(msg)
        end
    end
    
    ii = ii + imageUsed;
end

data.databaseStruct = D;
data.dictionary = dictionary;
data.features = data.features(1:ns, :);
data.class    = data.class(1:ns);
data.image    = data.image(1:ns);
data.instance = data.instance(1:ns);
data.location = data.location(1:ns,:);

save (dataFile, 'data')

