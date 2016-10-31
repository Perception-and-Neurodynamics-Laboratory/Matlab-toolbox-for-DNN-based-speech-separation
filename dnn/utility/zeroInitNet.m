function net = zeroInitNet(net_struct, isGPU, epsilon)

if nargin<3; epsilon = 0; end;

num_net_layer = length(net_struct) - 1;
net = repmat(struct,num_net_layer,1);
for i = 1:num_net_layer    
    if isGPU
        net(i).W = gpuArray.zeros(net_struct(i+1),net_struct(i),'single');
        net(i).b = gpuArray.zeros(net_struct(i+1),1,'single');        
    else
        net(i).W = zeros(net_struct(i+1),net_struct(i),'single');
        net(i).b = zeros(net_struct(i+1),1,'single');        
    end
    
    % this is for initializing net_grad_ssqr in ada_sgd
    if epsilon ~=0
        net(i).W = net(i).W + epsilon;
        net(i).b = net(i).b + epsilon;
    end
end
