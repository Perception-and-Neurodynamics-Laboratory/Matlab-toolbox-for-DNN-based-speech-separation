%% --setting net params--
opts.cv_interval = 1; % check cv perf. every this many epochs
opts.isPretrain = 0; % pre-training using RBM?
opts.rbm_max_epoch = 25; 
opts.rbm_batch_size = 1024; % batch size for pretraining
opts.rbm_learn_rate_binary = 0.01;
opts.rbm_learn_rate_real = 0.004;

opts.learner = 'ada_sgd'; % 'ada_sgd' or 'sgd'
opts.sgd_max_epoch = 20; % maximum number of training epochs
opts.sgd_batch_size = 1024; % batch size for SGD
opts.ada_sgd_scale = 0.0015; % scaling factor for ada_grad
opts.sgd_learn_rate = linspace(0.08, 0.001, opts.sgd_max_epoch); % linearly decreasing lrate for plain sgd

opts.initial_momentum = 0.5;
opts.final_momentum = 0.9;
opts.change_momentum_point = 5;

opts.cost_function = 'mse';
opts.hid_struct = [1024 1024 1024 1024]; % num of hid layers and units

opts.unit_type_output = 'sigm';
opts.unit_type_hidden = 'sigm'; %sigm or relu
if strcmp(opts.unit_type_output,'softmax'); opts.cost_function = 'softmax_xentropy'; end;

opts.isDropout = 0; % need dropout regularization?
opts.isDropoutInput = 0; % dropout inputs?
opts.drop_ratio = 0.2; % ratio of units to drop
opts.train_neighbour = 2;

gcount = -1; %detect if gpu is available, if so, enable it
try
   gpuDevice;
   gcount = 1;
catch err
   disp('no gpu available, use cpu instead');
   gcount = 0;
end
if gcount > 0
   gpuobj = gpuDevice;
   gpuDevice(gpuobj.Index);
   opts.isGPU = 1; % use GPU?
else
   opts.isGPU = 0;
   disp('GPU is not available, using CPU.')
end

opts.eval_on_gpu = 0; 
opts.save_on_fly = 0; % save the current best model along the way
opts.db = db;
opts.save_model_path = 'YOUR_FOLDER_OF_MODELS';
opts.note_str = 'YOUR_NOTES';

%% --network training--
% set final structure
[num_samples, dim_input] = size(test_data);
dim_output = size(test_label, 2);
opts.net_struct = [dim_input*(2*opts.train_neighbour+1), opts.hid_struct, dim_output];
opts 

% main training function
tic
test_data = make_window_buffer(test_data, opts.train_neighbour);
cv_data = make_window_buffer(cv_data, opts.train_neighbour);
train_data = make_window_buffer(train_handle.train_data, opts.train_neighbour);
train_target = train_handle.train_target;

[model, pre_net] = funcDeepNetTrainNoRolling(train_data, train_target, cv_data,cv_label, test_data, test_label, opts);

train_time = toc;
fprintf('\nTraining done. Elapsed time: %2.2f sec\n',train_time);
