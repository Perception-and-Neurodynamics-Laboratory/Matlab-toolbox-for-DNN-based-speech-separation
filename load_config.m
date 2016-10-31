format compact

feat_line = 'AmsRastaplpMfccGf' % feature tpye
noise_line = 'factory' %noise type

repeat_time = 1; % number of times that each clean utterance is mixed with noise for training.
%train_list = ['config' filesep 'list600_short.txt'];
%test_list = ['config' filesep 'list120_short.txt'];
train_list = ['config' filesep 'list600.txt'];
test_list = ['config' filesep 'list120.txt'];

% cut noise into two parts, the first part is for training and the second part is for test
noise_cut = 0.5;

% create mixtures at certain SNR
mix_db = -2; 

% use ideal ratio mask or ideal binary mask as learning target
is_ratio_mask = 1;

%% speech separation steps

% 1. generate mixtures or not. 0: no, 1: yes.
is_gen_mix = 1;

% 2. generate features/masks or not. 0: no, 1: yes.
is_gen_feat = 1;

% 3. perform dnn training/test or not. 0: no, 1: yes.
is_dnn = 1;
