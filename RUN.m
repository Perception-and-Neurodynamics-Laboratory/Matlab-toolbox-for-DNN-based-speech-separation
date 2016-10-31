format compact
warning off;

% load configurations 
load_config

% create folders for demo
tmp_path = ['DATA' filesep];
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
tmp_path = ['DATA' filesep noise_line];
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
tmp_path = ['DATA' filesep noise_line filesep 'dnn'];
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
tmp_path = ['DATA' filesep noise_line filesep 'tmpdir'];
if ~exist(tmp_path,'dir'); mkdir(tmp_path); end;
TMP_DIR_STR = [pwd filesep 'DATA' filesep noise_line filesep 'tmpdir'];

copyfile('config',['DATA' filesep noise_line filesep 'config']);

fid = fopen(['DATA' filesep noise_line filesep 'dnn' filesep 'feat_list'],'w');
tmp_str = ['d_' noise_line '_'  feat_line '.mat'];
fprintf(fid,'%s\n', tmp_str);
fclose(fid);

% write log file
delete(['DATA' filesep noise_line filesep 'log_db' num2str(mix_db) '.txt'])
diary(['DATA' filesep noise_line filesep 'log_db' num2str(mix_db) '.txt'])
diary on

% print config
fprintf(1,'train_list=%s, test_list=%s, noise_cut=%f\n\n',train_list, test_list, noise_cut);
fprintf(1,'dB: '); disp(mix_db);
fprintf(1,'feat_type:%s, noise_type:%s\n', feat_line, noise_line);

% get # of test/train mixtures 
num_mix_per_test_part = numel(textread(test_list,'%1c%*[^\n]'));
num_clean_sent_per_train_part = numel(textread(train_list,'%1c%*[^\n]'));
num_mix_per_train_part = num_clean_sent_per_train_part * repeat_time;


%% start DNN based speech separation

% open the directory of the demo
cd(['DATA' filesep noise_line]);

% 1. generate training/test mixtures 
if is_gen_mix == 1
    fprintf(1, '\n\n\n##########################################\n');
    fprintf('Start to generate training/test mixtures \n\n\n\n');
	addpath(['..' filesep '..' filesep 'gen_mixture']);
    % test mixtures
	get_all_noise_test(noise_line, noise_cut, mix_db, test_list, TMP_DIR_STR);
    % training mixtures
	get_all_noise_train(noise_line, noise_cut, mix_db, repeat_time, train_list, TMP_DIR_STR);
end

% 2. generate features and ideal masks
if is_gen_feat == 1
    fprintf(1, '\n\n\n##########################################\n');
    fprintf(1, 'Start to generate features and ideal masks \n\n\n\n');
	addpath(genpath(['..' filesep '..' filesep 'get_feat']));
	% test features
	total(feat_line, noise_line, -1, 1, num_mix_per_test_part, mix_db, is_ratio_mask, TMP_DIR_STR);
	% training features
	total(feat_line, noise_line, 1, 1, num_mix_per_train_part, mix_db, is_ratio_mask, TMP_DIR_STR);
end

% 3. dnn training/test
cd('dnn');
addpath(genpath(['..' filesep '..' filesep '..' filesep 'dnn']));
if is_dnn == 1
    fprintf(1, '\n\n\n##########################################\n');
    fprintf(1, 'Start mean variance normalization and dnn training/test \n\n\n\n');
    % mean variance normalization
	mvn_store(noise_line, feat_line, mix_db, TMP_DIR_STR);
    % dnn training/test
    run_every(noise_line, feat_line, mix_db, is_ratio_mask);
end
cd(['..' filesep '..' filesep '..'])
