function run_every(noise, feat, db, TMP_STORE)
format compact;

fprintf(1,'MVNing Feat=%s Noise=%s\n', feat, noise);

root_path = [TMP_STORE filesep 'db' num2str(db) filesep]
speech_data_path = [root_path 'mix' filesep 'test_' noise '_mix_aft2.mat'];
load(speech_data_path);

% test_set
load([root_path 'feat' filesep 'test_' noise '_' feat '.mat']); %test set
test_data = feat_data; test_label = feat_label;
clear feat_data feat_label

% train_set
train_path = [root_path 'feat' filesep 'train_' noise '_' feat '.mat']

train_data = []; train_target = [];
disp(['loading ' train_path]);
load(train_path);
train_data = [train_data ; feat_data];
train_target = [train_target ; feat_label];
clear feat_data feat_label;

cv_portion = floor(0.1 * size(train_data, 1));
fprintf(1,'Total=%d, cv=%d  train=%d\n',size(train_data, 1), cv_portion, size(train_data, 1) - cv_portion);
cv_data = train_data(1:cv_portion,:);
cv_label = train_target(1:cv_portion,:);

train_data(1:cv_portion,:) = [];
train_target(1:cv_portion,:) = [];

[a2, b2] = size(cv_data);[a3, b3] = size(test_data);
fprintf(1,'cv=%d x %d, test=%d x %d\n',a2,b2,a3,b3);

[train_data,para.tr_mu,para.tr_std] = mean_var_norm(train_data);
cv_data = mean_var_norm_testing(cv_data, para.tr_mu,para.tr_std);
test_data = mean_var_norm_testing(test_data, para.tr_mu,para.tr_std);

save_mvn_prefix_path = ['MVN_STORE' filesep];
if ~exist(save_mvn_prefix_path,'dir'); mkdir(save_mvn_prefix_path); end;
MVN_DATA_PATH = [save_mvn_prefix_path 'allmvntrain_' noise '_' feat '_' num2str(db) '.mat']
save(MVN_DATA_PATH, 'train_data','train_target','cv_data','cv_label','test_data','test_label', 'DFI',...
 'small_mix_cell', 'small_noise_cell', 'small_speech_cell', 'c_mat', '-v7.3');%also saved test mixes

pause(2);

end
