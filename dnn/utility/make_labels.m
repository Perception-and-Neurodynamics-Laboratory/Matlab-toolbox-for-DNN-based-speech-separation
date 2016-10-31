function filled = make_labels(idx,max_val)

filled = zeros(length(idx), max_val, 'single');
for i = 1:length(idx)
    filled(i,idx(i)) = 1;
end
