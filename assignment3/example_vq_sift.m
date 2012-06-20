function HISTOGRAMS = example_vq_sift(SIFT_FILE_PATH,DICTIONARY)
  
  %%% get list of all precomputed SIFT files
  file_names = dir([SIFT_FILE_PATH,'/image*sift.mat']);
  
  %%% get size of visual dictionary
  nBins = size(DICTIONARY,1);
    
  %%% Setup output
  HISTOGRAMS = zeros(length(file_names),nBins);
  
  %%% Main loop over SIFT files.
  
  
  for i=1:length(file_names)
    
    %%% Load in each SIFT file for each image
    load([SIFT_FILE_PATH,'/',file_names(i).name]);
    
    %%% Get all SIFT descriptors for the image
    sifts = features.data;
    
    %%% How many in this image?
    nSift = size(sifts,1);
    
    %%% Now loop over all SIFT descriptors in image 
    for j = 1:nSift
    
      %%% Find the closest DICTIONARY element. Use squared Euclidean distance
      
      %%% Increment HISTOGRAMS count
      
    end
    
    
  end
  
