function rbm_net = pretrainRBMStack(data, opts)
%this pretraining code supports only sigmoid hidden units, use with caution
%relu+dropout seems to eliminate the need of pretraining
%%
rbm_net = struct;
num_net_layer = length(opts.net_struct)-1;

for ll = 1:num_net_layer-1 % output layer just use random initialization
    disp(['Training Stacked RBM Layer #',int2str(ll)]);
    num_hidden = opts.net_struct(ll+1);
    
    if ll == 1 % input layer uses Gaussian units
        net = trainRBM(data,num_hidden,0,opts);
    else       % upper layers all use binary units
        net = trainRBM(data,num_hidden,1,opts);
    end
    
    rbm_net(ll).W = net.W;
    rbm_net(ll).b = net.b;    
    
    net.W = gather(net.W);
    net.b = gather(net.b);
    disp('Generating upper layer inputs...')
    data = sigmoid(bsxfun(@plus, data*net.W', net.b')); % perfrom this on main memory!
end

%output layer just do randomized stuff
rbm_net(num_net_layer).W = initializeRandWSparse(opts.net_struct(end),opts.net_struct(end-1));
rbm_net(num_net_layer).b = zeros(opts.net_struct(end),1,'single');
