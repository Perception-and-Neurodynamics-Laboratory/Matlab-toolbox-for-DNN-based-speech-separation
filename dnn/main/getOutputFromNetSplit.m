function output = getOutputFromNetSplit(net,data,num_split,opts)

num_samples = size(data,1);
dim_output = opts.net_struct(end);
chunck_size = ceil(num_samples/num_split);

if opts.eval_on_gpu
    output = gpuArray.zeros(num_samples,dim_output,'single');
else
    output = zeros(num_samples,dim_output,'single');
end
for i = 1:num_split
    idx_start = (i-1)*chunck_size+1;
    idx_end = i*chunck_size;
    if idx_end>num_samples; idx_end = num_samples; end
    output_chunck = getOutputFromNet(net,data(idx_start:idx_end,:),opts);
    output(idx_start:idx_end,:) = output_chunck;
end
