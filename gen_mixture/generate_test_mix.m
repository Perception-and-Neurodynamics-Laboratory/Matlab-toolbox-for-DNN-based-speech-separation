function generate_test_mix( noise_ch, dB, test_list, TMP_STORE)
    warning('off','all');
    global min_cut;

    tmp_str = strsplit(noise_ch,'_');
    noise_name = tmp_str{1};

    fprintf(1,'\nMix Test Set, noise_name = %s ######\n\n',noise_name);
    num_sent = numel(textread(test_list,'%1c%*[^\n]')); 
    small_mix_cell = cell(1,num_sent);
    small_noise_cell = cell(1,num_sent);
    small_speech_cell = cell(1,num_sent);
    alpha_mat = zeros(1,num_sent);
    c_mat = zeros(1,num_sent);
    
    index_sentence = 1;

    fid = fopen(test_list);
    tline = fgetl(fid);
    iteration = 1;
    constant = 5*10e6; % used for engergy normalization for mixed signal
    c = 1;
    
    while ischar(tline)
        [tmp_n  fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'noise' filesep noise_name '.wav']);   
        tmp_n = tmp_n(:,1);
        
        %IEEE sentence
        [s  s_fs] = audioread(['..' filesep '..' filesep 'premix_data' filesep 'clean_speech' filesep tline]);
        tmp_n = resample(tmp_n,16000,fs);
        s = resample(s,16000,s_fs); %resamples to 16000 samples/second
        
        % only take the second part of the noise
        tmp_n = tmp_n(ceil(length(tmp_n)*min_cut):end-7*16000);
        
        %choosing a point where we start to cut
        start_cut_point = randi(length(tmp_n)-length(s)+1);
        
        %cut
        n = tmp_n (start_cut_point:start_cut_point+length(s)-1);
        
        %compute SNR
        snr = 10*log10(sum(s.^2)/sum(n.^2));
        
        db = dB;
        alpha = sqrt(  sum(s.^2)/(sum(n.^2)*10^(db/10)) );
        
        %check SNR
        snr1 = 10*log10(sum(s.^2)/sum((alpha.*n).*(alpha.*n)));
        
        mix = s + alpha*n;
        
        c = sqrt(constant * length(mix)/sum(mix.^2));
        mix = mix*c;
        
        small_mix_cell{index_sentence} = single(mix);
        
        small_speech_cell{index_sentence} = single(s);
        
        small_noise_cell{index_sentence} = single(alpha*n);
        
        alpha_mat(index_sentence) = alpha;
        
        c_mat(index_sentence) = c;

        after_constant = sum(mix.^2)/length(mix); 
        fprintf(1,'name=%s before_snr=%f, using db=%d, after_snr=%f, index_sentence=%d\n', tline, snr, db, snr1, index_sentence);
        %read next line from list.txt
        tline = fgetl(fid);
        
        iteration = iteration + 1;
        index_sentence =index_sentence +1;
        end
    fclose(fid); 

    save_path = [TMP_STORE filesep 'db' num2str(dB)];
    if ~exist(save_path,'dir'); mkdir(save_path); end;
    save_path = [TMP_STORE filesep 'db' num2str(dB) filesep 'mix' filesep];
    if ~exist(save_path,'dir'); mkdir(save_path); end;

    save([save_path, 'test_', noise_ch, '_mix_aft2.mat'], 'small_mix_cell', 'small_speech_cell', 'small_noise_cell', 'c_mat', '-v7.3');
    warning('on','all');
end
