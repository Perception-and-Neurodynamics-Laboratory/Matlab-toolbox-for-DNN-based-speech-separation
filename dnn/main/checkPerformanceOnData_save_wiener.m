function [perf,perf_str] = checkPerformanceOnData_save_wiener(net,data,label,opts,write_wav,num_split)
disp('save_wiener_func');
global feat noise frame_index DFI;
global small_mix_cell small_noise_cell small_speech_cell;
num_test_sents = size(DFI,1)

if nargin < 6
    num_split = 1;
end

num_samples = size(data,1);

if ~opts.eval_on_gpu
    for i = 1:length(net)
        net(i).W = gather(net(i).W);
        net(i).b = gather(net(i).b);
        data = gather(data);
    end
end

output = getOutputFromNetSplit(net,data,5,opts);

est_r = cell(num_test_sents);
ideal_r = cell(num_test_sents);
clean_s = cell(num_test_sents);
mix_s = cell(num_test_sents);
EST_MASK = cell(num_test_sents);
IDEAL_MASK = cell(num_test_sents);
stoi_est_sum = 0;
stoi_ideal_sum = 0;
unprocessed_stoi_sum = 0;
noise_feat = sprintf('%-15s', [noise ' ' feat]);
for i=1:num_test_sents
    EST_MASK{i} = transpose(output(DFI(i,1):DFI(i,2),:));
    IDEAL_MASK{i} = transpose(label(DFI(i,1):DFI(i,2),:));

    mix = double(small_mix_cell{i});
    mix_s{i} = mix;
    est_r{i} = synthesis(mix, double(EST_MASK{i}), [50, 8000], 320, 16e3);
    ideal_r{i} = synthesis(mix, double(IDEAL_MASK{i}), [50, 8000], 320, 16e3);

    clean_s{i} = double(small_speech_cell{i});
    est_stoi = stoi(clean_s{i}, est_r{i}, 16e3);
    ideal_stoi = stoi(clean_s{i}, ideal_r{i}, 16e3);
    unprocessed_stoi = stoi(clean_s{i}, mix, 16e3);
    fprintf(1,['#STOI_single# ' noise_feat ' index=%d unprocessed_stoi=%0.4f ideal_stoi=%0.4f est_stoi=%0.4f \n'], i, unprocessed_stoi, ideal_stoi, est_stoi);

    stoi_est_sum = stoi_est_sum + est_stoi;
    stoi_ideal_sum = stoi_ideal_sum + ideal_stoi;
    unprocessed_stoi_sum = unprocessed_stoi_sum + unprocessed_stoi;

    clean_sig = floor(2^15*clean_s{i}/(max(abs(clean_s{i})))); % normalize
end

fprintf(1,['\n#STOI_average# ' noise_feat ' unprocessed_stoi=%0.4f ideal_stoi=%0.4f est_stoi=%0.4f \n'], unprocessed_stoi_sum/num_test_sents, stoi_ideal_sum/num_test_sents, stoi_est_sum/num_test_sents);

save_prefix_path = ['STORE' filesep 'db' num2str(opts.db) filesep];
if ~exist(save_prefix_path,'dir'); mkdir(save_prefix_path); end;
if ~exist([save_prefix_path 'EST_MASK'],'dir'); mkdir([save_prefix_path 'EST_MASK' ]); end;
if ~exist([save_prefix_path 'sound'],'dir'); mkdir([save_prefix_path 'sound']); end;
save([save_prefix_path 'EST_MASK' filesep 'ratio_MASK_' noise '_' feat '.mat' ],'EST_MASK','IDEAL_MASK','frame_index','DFI');
save([save_prefix_path 'sound' filesep 'ratio_' noise '_' feat '.mat'],'est_r','ideal_r', 'clean_s', 'mix_s');

mse = getMSE(output, label);

% return criteria
perf = mse; perf_str = 'MSE';
fprintf(1,[ '#MSE# ' noise_feat ' MSE: ' num2str(mse,'%0.4f')  '\n']);

pause(5);
save_wav_path = ['WAVE' filesep];
if ~exist(save_wav_path,'dir'); mkdir(save_wav_path); end;

save_wav_path = [save_wav_path 'db' num2str(opts.db) filesep];
if ~exist(save_wav_path,'dir'); mkdir(save_wav_path); end;

save_wav_path = [save_wav_path 'ratio_'];

if write_wav == 1
    %write to wav files
    disp('writing waves ......');
    warning('off','all');
    for i=1:num_test_sents
       sig = mix_s{i};
       sig = sig/max(abs(sig))*0.9999;
       audiowrite([save_wav_path num2str(i) '_mixture.wav'], sig,16e3);
    
       sig = clean_s{i};
       sig = sig/max(abs(sig))*0.9999;
       audiowrite([save_wav_path num2str(i) '_clean.wav'], sig,16e3);
    
       sig = ideal_r{i};
       sig = sig/max(abs(sig))*0.9999;
       audiowrite([save_wav_path num2str(i) '_ideal.wav'],sig,16e3);
    
       sig = est_r{i};
       sig = sig/max(abs(sig))*0.9999;
       audiowrite([save_wav_path num2str(i) '_estimated.wav'],sig,16e3);
    end
    warning('on','all');
    disp('finish waves');
end
