%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the script used to generate the datasets provided with this demo.
% You do not need to run this. 
% This datasets are a subset of the LabelMe database.
%
% The full dataset can be download here:
% http://people.csail.mit.edu/brussell/research/LabelMe/intro.html
%
% If you want to train a new object detector, you can find training data
% for many object categories from the LabelMe database online. Then, you
% need to modify the file 'parameters.m' to provide the paths to the images
% and annotations and to indicate the object name you want to use. After
% that, you can run the program createDatabases.m to read the annotations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
parameters

% This list is build to select from the dataset only objects with a
% specific viewpoint and without occlusions. Other queries can generate
% a more diverse set of object poses and conditions.
% The dataset will contain three labeled objects. The original LabelMe dataset
% contains hundreds of object categories.
demoObjects = 'screen+frontal-part,car+side-part-ocluded-occluded-front-back-moving';

% Define the root folder for the LabelMe full database  
LabelMeHOMEIMAGES = 'C:\atb\Databases\CSAILobjectsAndScenes\Images'; % you can set here your default folder
LabelMeHOMEANNOTATIONS = 'C:\atb\DATABASES\LabelMe\Annotations'; % you can set here your default folder

% Load the annotations and create a struct with all the information
database = LMdatabase(LabelMeHOMEANNOTATIONS);

% This shows all the objects present in the dataset and counts the number
% of instances:
[names, counts] =  LMobjectnames(database); % show counts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we are going to create a new database, by extracting from the full
% database only the images that contain the target of interest and also by
% normalizing the images. The original images are too big and detection
% would be too slow. So, we will reduce their size by cropping and scaling 
% the original imageswhile making sure that the target has some fixed
% size to insure that the detector will work.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Locate the images that contain at least one of the objects of interest labeled
disp('Select objects of interest from LabelMe database')
[D,j]  = LMquery(database, 'object.name', demoObjects);
[D,j]  = LMquery(D, 'object.deleted', '0'); % remove deleted polygons
[names, counts] =  LMobjectnames(D, 'plot'); % show counts
LMdbshowscenes(D(fix(linspace(1, length(D), 30))), LabelMeHOMEIMAGES); % show some images with labels

% Cook database to fit our requirements: 
% For this demo, we will use objects at a single scale. But you can change
% easily the code to make it work with multiple scales.
% The output of this function is a new database with normalized images:
LMcookdatabase(D, ...
    LabelMeHOMEIMAGES, LabelMeHOMEANNOTATIONS, ...   % This specifies the folders with the full dataset
    HOMEIMAGES, HOMEANNOTATIONS, ...                 % This points to the new folders to be created
    'objectname', demoObjects, ...                       % This is the object that will drive the image normalization
    'objectsize', normalizedObjectSize, ...          % This specifies the desired object size in the normalized images
    'objectlocation', 'original', ...                % This specifies how to modify the location of the object in the new images (in this case, it will keep the center coordinates of the object in the same proportional location than in the original image)
    'maximagesize', testImageSize)               % This specifies the maximum image size for the normalized images




