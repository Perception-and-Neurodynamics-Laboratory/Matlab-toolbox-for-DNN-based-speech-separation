function parameters = AMS_init_FFT(nFFT_env,nFFT_speech,nFFT_ams,nChnl,Srate)


opt_spacing = 2; %2 is mel
[crit_filter_SNR CB2FFT] = create_crit_filter(nFFT_speech,nChnl,Srate,opt_spacing);
crit_filter = create_crit_filter(nFFT_env,nChnl,Srate,opt_spacing);

% FFT MF->Selected Modulation Frequency Transformation
MF_T = zeros(15,nFFT_ams/2);
MF_T(1,1+1:1+3) = [0.25 0.5 0.25];
MF_T(2,1+2:1+5) = [0.1 0.4 0.4 0.1];
MF_T(3,1+3:1+6) = [0.1 0.4 0.4 0.1];
MF_T(4,1+4:1+6) = [0.25 0.5 0.25];
MF_T(5,1+4:1+7) = [0.1 0.4 0.4 0.1];
MF_T(6,1+5:1+8) = [0.1 0.4 0.4 0.1];
MF_T(7,1+6:1+9) = [0.1 0.4 0.4 0.1];
MF_T(8,1+8:1+10) = [0.25 0.5 0.25];
MF_T(9,1+9:1+12) = [0.1 0.4 0.4 0.1];
MF_T(10,1+11:1+13) = [0.25 0.5 0.25];
MF_T(11,1+13:1+15) = [0.25 0.5 0.25];
MF_T(12,1+15:1+17) = [0.25 0.5 0.25];
MF_T(13,1+17:1+19) = [0.25 0.5 0.25];
MF_T(14,1+20:1+22) = [0.25 0.5 0.25];
MF_T(15,1+23:1+25) = [0.25 0.5 0.25];


% % uniform triangular filterbank
% st = 1; % starting fft point
%
% % ~400Hz
% ed = 27; % ending fft point
% nCh = 15;
% is_modified.fb = 'uniform_trib_15';
%
%
%
% step = (ed-st)/(nCh+1);
% centers = st + (1:nCh)*step;
% slope = 1/step; % slope of triangular filter
% MF_T = zeros(nCh,nFFT_ams/2);
% for n=1:nCh
%       for i = ceil(centers(n)-step):floor(centers(n))
%               MF_T(n,i) = slope*(i-centers(n))+1;
%       end
%       for i = ceil(centers(n)):floor(centers(n)+step)
%               MF_T(n,i) = -slope*(i-centers(n))+1;
%       end
% end



parameters.CB2FFT = CB2FFT;
parameters.crit_filter = crit_filter;
parameters.nFFT_env = nFFT_env;
parameters.nFFT_speech = nFFT_speech;
parameters.nFFT_ams = nFFT_ams;
parameters.nChnl = nChnl;
parameters.MF_T = MF_T;
parameters.Srate = Srate;
parameters.crit_filter_SNR = crit_filter_SNR;