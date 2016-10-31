function get_all_noise_test(noise_line, cut, dB, test_list, TMP_STORE)

addpath(genpath('utility'));
global min_cut;
min_cut = cut;
fprintf(1,'noise cut ratio=%f\n',min_cut);

fprintf(1,'using %s noise\n',noise_line);
generate_test_mix(noise_line, dB, test_list, TMP_STORE);

fprintf(1,'The %s noise have been finished.\n', noise_line);
end
