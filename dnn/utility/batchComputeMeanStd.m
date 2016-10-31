function [mean_vec, std_vec] = batchComputeMeanStd(data, batch_size)
if nargin < 2
    batch_size = 1024*2;
end

mean_vec = mean(data);

[m, dim] = size(data);

batch_id = genBatchID(m, batch_size);

ss = 0;
for bid = 1:length(batch_id)    
    range = batch_id(1,bid):batch_id(2,bid);
    chunck = data(range, :);
    ss = ss + sum((bsxfun(@minus, chunck, mean_vec)).^2);
end

std_vec = sqrt(ss/(m-1));

