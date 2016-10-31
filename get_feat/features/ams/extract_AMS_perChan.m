function [ns_ams] = extract_AMS_perChan(sub_gf, nChnl, freq)

if nargin < 4
    freq = 16000;
end

Srate = freq;
x = sub_gf;
%% 
% Level Adjustment
% [x ratio]= LTLAdjust(x, Srate);

%% 
len = floor(6*Srate/1000); % 6ms, frame size in samples, envelope length
if rem(len,2)==1
    len = len+1; 
end
env_step = 0.25;
len2 = floor(env_step*Srate/1000); 
Nframes = floor(length(x)/len2);
Srate_env = 1/(env_step/1000); % Since we calculate the envelope every 0.25ms, the sampling rate for envelope is this.
win = window(@hann,len);
%s_frame_len = 20;
s_frame_len = 32;

nFFT_env = 128;
nFFT_ams = 256;

nFFT_speech = s_frame_len/1000*Srate; % in samples
AMS_frame_len = s_frame_len/env_step; % 128 frames of envelope corresponding to 128*0.25 = 32ms
AMS_frame_step = 80/2; % step size, corresponds to 40 frames of envelope, i.e. 10ms window shift in orignal signal

k = 1;% sample position of the speech signal
kk = 1;
KK = floor(Nframes/AMS_frame_step);
ss = 1; % sample position of the noisy speech for synthesize
ns_ams = zeros(1*15,KK);

parameters = AMS_init_FFT(nFFT_env,nFFT_speech,nFFT_ams,nChnl,Srate);
% parameters_FB = AMS_init(nFFT_speech,64,nChnl,Srate);


ENV_x = env_extraction_gmt_chan2(sub_gf, 'abs'); %time domain envelope in subbands
mix_env = ENV_x;
mix_env = [mix_env zeros(1,AMS_frame_len)];

win_ams = window(@hann,AMS_frame_len);
repwin_ams = repmat(win_ams,1,1);
for kk=1:KK
    if kk == 1 %special treatment to the 1st frame, making it consistent with cochleagram and IBM calculation 
        mix_env_frm = mix_env(:,(1:(AMS_frame_len-AMS_frame_step))+(AMS_frame_step*(kk-1)));
        ams = abs(fft(mix_env_frm'.*repwin_ams((AMS_frame_step+1):end,:),nFFT_ams));        
        
    else
        mix_env_frm = mix_env(:,(1:AMS_frame_len)+(AMS_frame_step*(kk-2)));    
        ams = abs(fft(mix_env_frm'.*repwin_ams,nFFT_ams));
        
    end
	ams = parameters.MF_T*ams(1:nFFT_ams/2,:);
	ams = ams';
	ns_ams(:,kk) = reshape(ams,[],1);	
end

return;

