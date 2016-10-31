function combine = my_features_AmsRastaplpMfccGf(sig)
    sig = double(sig);
    nframe = floor(length(sig)/160);
    nc = 64;
    
    feat_stack = [];
    %fprintf('AMS...')
    ams_feat = get_amsfeature_chan_fast(sig,nc);

    %fprintf('RASTAPLP2D...')
    rastaplp_feat = rastaplp(sig, 16000, 1, 12);
    rastaplp_feat = [zeros(size(rastaplp_feat,1),1) rastaplp_feat];
    
    %fprintf('MODMFCC...\n')
    mfcc_feat = melfcc(sig, 16000,'numcep',31,'nbands',nc,'wintime', 0.020, 'hoptime', 0.010, 'maxfreq', 8000);
    mfcc_feat = [zeros(size(mfcc_feat,1),1) mfcc_feat];
     
    feat = cochleagram(gammatone(sig, nc, [50, 8000], 16e3));
    %feat = feat(:,1:nFrame);
    gf_feat = single(feat.^(1/15));
    
    combine = [ams_feat; rastaplp_feat; mfcc_feat; gf_feat];  
    
    % add delta features
    combine = [combine; deltas(combine)];
end

