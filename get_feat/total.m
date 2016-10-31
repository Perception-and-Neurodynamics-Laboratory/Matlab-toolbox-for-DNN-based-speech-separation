function  total(feat, noise, part, START, END, db, is_ratio_mask, TMP_STORE)
    tic;
    fprintf(1,'start noise:%s  feat:%s\n',noise, feat);
    run_every(feat, noise, part, START, END, db, TMP_STORE, is_ratio_mask);
    fprintf(1,'finish noise:%s  feat:%s\n',noise, feat);
    seconds = toc;
    fprintf(1,'%f seconds spent on the noise:%s feat:%s\n', seconds, noise, feat);
end
