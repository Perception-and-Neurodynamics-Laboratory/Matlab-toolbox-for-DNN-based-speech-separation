function net = randInitNet(net_struct, isSparse, isL2Norm, isGPU)

num_net_layer = length(net_struct) - 1;
net = repmat(struct,num_net_layer,1);
for i = 1:num_net_layer
    if isSparse
          net(i).W = initializeRandWSparse(net_struct(i+1),net_struct(i));
    else
        net(i).W = initRandW(net_struct(i+1), net_struct(i));
    end
    net(i).b = zeros(net_struct(i+1),1);
    
    % L2 weight norm normalization
    if isL2Norm
        tmp = net(i).W;
        net(i).W = tmp./repmat(sqrt(sum(tmp.^2,2)), 1, size(tmp,2)); 
    end

    net(i).W = single(net(i).W);
    net(i).b = single(net(i).b);
     
    if isGPU
        net(i).W = gpuArray(net(i).W);
        net(i).b = gpuArray(net(i).b);
    end
end
