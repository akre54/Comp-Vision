function [ACCURACY,PREDICTED_LABELS] = example_classify_nn(TRAIN_IND,TEST_IND,TRAIN_LABELS,TEST_LABELS,HISTOGRAMS,K)
  
%%% make output vector
PREDICTED_LABELS = zeros(1,length(TEST_IND));    
    
%%% Get set of *all* train histograms
all_train_hist = ;

%%%% Main loop over each test example
  
for i=1:length(TEST_IND)
  
  %%% Get histogram for test example i from HISTOGRAMS matrix
  test_hist = ; 
  
  %%% Compute squared Euclidean distance between test_hist and every
  %%% histogram in all_train_hist
  dist_l2 = ;
  
  %%% Feel free to try some other distance metric mentioned in the
  %%% slides. Some of them might perform better than Euclidean distance.  
  
  %% Sort by distance and take closest K points.
  
  
  %% Compute predicted label. 
  PREDICITED_LABELS(i) = mode(  ); 
    
end
  
%%% Compute ACCURACY, i.e. what fraction of the time does
%PREDICITED_LABELS agree with TEST_LABELS
ACCURACY = ;
