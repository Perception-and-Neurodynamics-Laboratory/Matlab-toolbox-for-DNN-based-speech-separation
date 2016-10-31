function [forward_path drop_mask]= forwardPass(net,data,opts)

num_net_layer = length(net);
num_data_layer = num_net_layer+1; % count input layer in

forward_path = cell(num_data_layer,1);
drop_mask = cell(num_data_layer,1);

if opts.isDropout
    drop_ratio = opts.drop_ratio;
    drop_scale = 1/(1-drop_ratio);
else
    drop_scale = 1;
end


for ii = 1:num_data_layer
    if ii == 1
        net_activation = data';
        drop_flag = opts.isDropout && opts.isDropoutInput; %sometimes it's better not to drop inputs
    else
        drop_flag = opts.isDropout && (ii<=num_net_layer); % never dropout outputs
        net_potential = bsxfun(@plus, drop_scale*net(ii-1).W*net_activation, net(ii-1).b);               
        if ii == num_data_layer
            net_activation = compute_unit_activation(net_potential,opts.unit_type_output);
        else
            net_activation = compute_unit_activation(net_potential,opts.unit_type_hidden);
        end
    end
    
    if drop_flag
        if opts.isGPU
            drop_mask_per_layer = gpuArray.rand(size(net_activation),'single')<(1-drop_ratio); %faster than rand on CPU
        else
            drop_mask_per_layer = rand(size(net_activation),'single')<(1-drop_ratio);
        end        
        net_activation = net_activation.*drop_mask_per_layer; % drop hid units, for *each* data
    else
        if opts.isGPU
            drop_mask_per_layer = gpuArray.ones(size(net_activation),'single');
        else
            drop_mask_per_layer = ones(size(net_activation),'single');
        end
    end
    
    drop_mask{ii} = drop_mask_per_layer;
    forward_path{ii} = net_activation;
end
