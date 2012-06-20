

clear all

parameters
testImageSize = [256 256];

% Load detector parameters:
load (dataFile)
NweakClassifiers = length(data.detector);
NweakClassifiers = [120]; % put a list if you want to compare performances with different number of weak learners.
%NweakClassifiers = [30 120]; % put a list if you want to compare performances with different number of weak learners.
[Dc, jc]  = LMquery(data.databaseStruct, 'object.name', objects);

% remove images used to create the dictionary:
testImages = setdiff(jc, [data.trainingImages; data.dictionary.imagendx']);
NtestImages = length(testImages);

% Define variables used for the precision-recall curve
scoreAxis = linspace(0, 100, 20); RET = []; REL = []; RETREL = [];

% Create figures
sc = get(0, 'ScreenSize'); 
figSize = [.1*sc(3) .7*sc(4) .8*sc(3) .2*sc(4)];
Hfig = figure;
set (Hfig, 'position', figSize);
figSize = [.1*sc(3) .4*sc(4) .8*sc(3) .2*sc(4)];
Hfig2 = figure;
set (Hfig2, 'position', figSize);
plotstyle = {'rs-', 'go-', 'b^-'};

% Loop on test images
for i = 1:NtestImages
    % Read image and ground truth
    Img = LMimread(data.databaseStruct, testImages(i), HOMEIMAGES);
    annotation = data.databaseStruct(testImages(i)).annotation;

    % Normalize image:
    [newannotation, newimg, crop, scaling, err, msg] = LMcookimage(annotation, Img, ...
        'objectname', objects, 'objectsize', normalizedObjectSize, 'objectlocation', 'original', 'maximagesize', testImageSize);

    for m = 1:length(NweakClassifiers)
        % Run derector at a single scale (you can loop on scales to get scale invariance):
        [Score, boundingBox, boxScores] = singleScaleBoostedDetector(double(mean(newimg,3)), data, NweakClassifiers(m));

        % Evaluate performace looking at precision-recall with different
        % thresholds:
        for n = 1:length(scoreAxis);
            [RET(n,i,m), REL(n,i,m), RETREL(n,i,m)] = LMprecisionRecall(boundingBox(boxScores>scoreAxis(n),:), newannotation, objects, [35 35]);
        end
    end
    precision = 100 * squeeze(sum(RETREL,2) ./ sum(RET,2));
    recall    = 100 * squeeze(sum(RETREL,2) ./ sum(REL,2));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % VISUALIZATION
    figure(Hfig); clf
    subplot(141)
    LMplot(newannotation, newimg); legend off
    title('Input image with ground truth')
    subplot(142)
    imagesc(Score); axis('equal'); axis('off'); axis('tight'); colormap(gray(256))
    title('Boosting margin')
    subplot(143)
    image(255*(Score>0)); axis('equal'); axis('off'); axis('tight'); colormap(gray(256))
    title('Thresholded output')
    subplot(144)
    image(newimg);
    sb = find(boxScores>scoreAxis(3)); % show bounding boxes with a high score.
    plotBoundingBox(boundingBox(sb,:), fix(boxScores(sb)/40)+1)
    axis('equal'); axis('off'); axis('tight'); colormap(gray(256))
    title({'Detector output', sprintf('targets=%d, correct=%d, false alarms=%d',REL(3,i,end), RETREL(3,i,end), RET(3,i,end)-RETREL(3,i,end))})
    drawnow
    
    figure(Hfig2); clf
    %subplot(144)
    for m = 1:length(NweakClassifiers)
        h(m) = plot(recall(:,m), precision(:,m), plotstyle{m}, 'linewidth', 3); hold on
    end
    legend(h, num2str(NweakClassifiers(:)), 'location', 'best')
    xlabel('recall'); ylabel('precision')
    axis([0 100 0 100]); %axis('square'); 
    grid on
end

