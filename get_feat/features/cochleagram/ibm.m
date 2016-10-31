function sig = ibm(target,masker,snr,lc,fRange)
% Produce an IBM (ideal binary mask) processed mixture.
% The first variable is required.
% When the second variable is not provided the function returns an all-one
% masked signal.
% snr: input SNR in dB.
% lc: local SNR criterion in dB.
% fRange: frequency range.
% Written by DeLiang Wang at Oticon in Feb'07

if nargin < 2
    [numChan,numFrame] = size(cochleagram(gammatone(target)));
    sig = synthesis(target,ones(numChan,numFrame));  % equivalent to an all-one mask
    return
end
if nargin < 3
    snr = 0;      % default input SNR is 0 dB
end
if nargin < 4
    lc = 0;       % default lc is 0 dB
end
if nargin < 5
    fRange = [80, 5000]; % default frequency range in Hz
end

numChan = 128;      % default is 128 channels
lt = length(target); lm = length(masker);
if (lt >= lm)       % equalize the lengths of the two files
    target = target(1:lm);
else
    masker = masker(1:lt);
end

change = 20*log10(std(target)/std(masker)) - snr;
masker = masker*10^(change/20);     % scale masker to specified input SNR
gt = gammatone(target,numChan,fRange);
gm = gammatone(masker,numChan,fRange);

ct = cochleagram(gt);     
cm = cochleagram(gm);

[numChan,numFrame] = size(ct);     % number of channels and time frames

if isinf(-lc)
    mask = ones(numChan,numFrame);  % give an all-one mask with lc = -inf
else
    for c = 1:numChan
        for m = 1:numFrame
            mask(c,m) = ct(c,m) >= cm(c,m)*10^(lc/10);     % this way to avoid division by zero
        end
    end
end    
dlmwrite('mask.out', mask);
mixture = target+masker;
sig = synthesis(mixture,mask,fRange);
