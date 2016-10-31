function generate_train_mix( noise_ch, dB, repeat_time, train_list, TMP_STORE)
    warning('off','all');
    global min_cut;

    tmp_str = strsplit(noise_ch,'_');
    noise_name = tmp_str{1};
   
    fprintf(1,'\nMix Training Set, noise_name = %s repeat_time = %d ######\n',noise_name, repeat_time);
    num_sent = numel(textread(train_list,'%1c%*[^\n]'));    
    small_mix_cell = cell(1,num_sent*repeat_time);
    small_noise_cell = cell(1,num_sent*repeat_time);
    small_speech_cell = cell(1,num_sent*repeat_time);
    alpha_mat = zeros(1,num_sent*repeat_time);
    c_mat = zeros(1,num_sent*repeat_time);
    
    index_sentence = 1;
    fid = fopen(train_list);
    tline = fgetl(fid);
    
    constant = 5*10e6; % used for engergy normalization for mixed signal
    c = 1;

    while ischar(tline)
        [n_tmp  fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'noise' filesep noise_name '.wav']);   
        n_tmp = n_tmp(:,1); 
        %IEEE sentence
        [s  s_fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'clean_speech' filesep tline]);
        n_tmp = resample(n_tmp,16000,fs); 
        s = resample(s,16000,s_fs); %resamples to 16000 samples/second
        
        % only take the first half of the noise
        n_tmp = n_tmp(1:floor(length(n_tmp)*min_cut));
        double_n_tmp = [n_tmp; n_tmp]; %wrap around

        for var_ind = 1:repeat_time
        
            %choosing a point where we start to cut
            start_cut_point = randi(length(n_tmp));
            
            %cut
            n = double_n_tmp (start_cut_point:start_cut_point+length(s)-1);
 
            %compute SNR
            snr = 10*log10(sum(s.^2)/sum(n.^2));
            
            db = dB;
            alpha = sqrt(  sum(s.^2)/(sum(n.^2)*10^(db/10)) );
            
            %check SNR
            snr1 = 10*log10(sum(s.^2)/sum((alpha.*n).*(alpha.*n)));
            
            mix = s + alpha*n;
            
            c = sqrt(constant * length(mix)/sum(mix.^2));
            mix = mix*c;

            store_index = (index_sentence-1)*repeat_time + var_ind;
            
            small_mix_cell{store_index} = single(mix);
            
            small_speech_cell{store_index} = single(s);
            
            small_noise_cell{store_index} = single(alpha*n);
            
            alpha_mat(store_index) = alpha;
            
            c_mat(store_index) = c;
            
            after_constant = sum(mix.^2)/length(mix);
            fprintf(1,'name=%s before_snr=%f, using db=%d, after_snr=%f, index_sentence=%d var_ind=%d store_ind=%d\n', tline, snr, db, snr1, index_sentence, var_ind, store_index);
            
        end    
            tline = fgetl(fid);
            index_sentence =index_sentence +1;
    end
    
    fclose(fid);

save_path = [TMP_STORE filesep 'db' num2str(dB)];
if ~exist(save_path,'dir'); mkdir(save_path); end;
save_path = [TMP_STORE filesep 'db' num2str(dB) filesep 'mix' filesep];
if ~exist(save_path,'dir'); mkdir(save_path); end;

save([save_path, 'train_', noise_ch, '_mix_bef2.mat'], 'small_mix_cell', 'small_speech_cell', 'small_noise_cell', 'c_mat', '-v7.3');
warning('on','all');
