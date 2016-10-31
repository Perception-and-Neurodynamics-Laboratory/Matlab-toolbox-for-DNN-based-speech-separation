function net = trainRBM(data,num_hidden,isBinary,rbm_opts)
% code by Yuxuan Wang (wangyuxu@cse.ohio-state.edu), 2012
%% parameter setting
% if real-valued inputs, use smaller learning rates, e.g., 0.001
if isBinary
    learn_rate = rbm_opts.rbm_learn_rate_binary;
else
    learn_rate = rbm_opts.rbm_learn_rate_real;
end

L2_lambda  = 2e-4; % L2-regularization
[num_samples,num_dim] = size(data);
isGPU = rbm_opts.isGPU;
%% initialization
weight_inc = zeros(num_dim,num_hidden,'single'); 
hidden_bias_inc = zeros(1,num_hidden,'single'); 
visible_bias_inc = zeros(1,num_dim,'single');

weight = 0.01*randn(num_dim, num_hidden,'single'); 
hidden_bias = zeros(1,num_hidden,'single');
visible_bias = zeros(1,num_dim,'single');

if isGPU
    weight_inc = gpuArray(weight_inc);
    hidden_bias_inc = gpuArray(hidden_bias_inc);
    visible_bias_inc = gpuArray(visible_bias_inc);
    weight = gpuArray(weight);
    hidden_bias = gpuArray(hidden_bias);
    visible_bias = gpuArray(visible_bias);
end
%% training
batch_id = genBatchID(num_samples,rbm_opts.rbm_batch_size);
num_batch = size(batch_id,2);

for epoch = 1:rbm_opts.rbm_max_epoch
   err_sum = 0;
   seq = randperm(num_samples);
   for bid = 1: num_batch
       num_batch_size = batch_id(2,bid)-batch_id(1,bid)+1;
       permIdx = seq(batch_id(1,bid):batch_id(2,bid));

       if isGPU; 
           v0 = gpuArray(data(permIdx,:));
       else
           v0 = data(permIdx,:);
       end
       
       % one step of Gibbs sampling (CD-1)
       h0_prob = sigmoid(bsxfun(@plus, v0*weight, hidden_bias));

       if isGPU
           h0_sample = single(h0_prob > gpuArray.rand(num_batch_size,num_hidden,'single'));
       else
           h0_sample = single(h0_prob > rand(num_batch_size,num_hidden,'single'));
       end
       
       if isBinary
            v1_prob = sigmoid(bsxfun(@plus, h0_sample*weight', visible_bias));
       else
            v1_prob = bsxfun(@plus, h0_sample*weight', visible_bias);
       end
       h1_prob = sigmoid(bsxfun(@plus, v1_prob*weight, hidden_bias));
       
       pos_prods = v0' * h0_prob;
       neg_prods = v1_prob' * h1_prob; % negative phase starts from v1_prob
       
       pos_hid_act = sum(h0_prob);
       pos_vis_act = sum(v0);
       
       neg_hid_act = sum(h1_prob);
       neg_vis_act = sum(v1_prob);
       
       % minibatch gradient descent
       err_sum = err_sum + sum(sum((v1_prob-v0).^2));
       if epoch <= 5 
           momentum = 0.5;
       else
           momentum = 0.9;
       end

       weight_inc = momentum*weight_inc + learn_rate*((pos_prods-neg_prods)/num_batch_size-L2_lambda*weight);
       visible_bias_inc = momentum*visible_bias_inc + (learn_rate/num_batch_size)*(pos_vis_act-neg_vis_act);
       hidden_bias_inc = momentum*hidden_bias_inc + (learn_rate/num_batch_size)*(pos_hid_act-neg_hid_act);

       weight = weight + weight_inc;
       visible_bias = visible_bias + visible_bias_inc;
       hidden_bias = hidden_bias + hidden_bias_inc;                            
   end   
   disp(['RBM reconstruction error at epoch ', int2str(epoch), ' is ', num2str(err_sum)]);
end

%%
net.W = weight';
net.b = hidden_bias';
