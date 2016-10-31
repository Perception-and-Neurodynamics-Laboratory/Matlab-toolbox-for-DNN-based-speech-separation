function format_print(input, noise_type, feat_type)

noise_feat = sprintf('%-15s', [noise_type ' ' feat_type]);
fprintf(1,'\n');
fprintf(1, [ '#@# ' noise_feat ' ACC:' num2str(input(1),'%0.4f') '  HIT:' num2str(input(2),'%0.4f') '  FA:' num2str(input(3),'%0.4f') '  HIT-FA:' num2str(input(4),'%0.4f') ])
fprintf(1,'\n');
