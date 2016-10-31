function output = getOutputFromNet(net,data,opts)

num_net_layer = length(net);
num_data_layer = num_net_layer+1; % count input layer in

if opts.isDropout
    drop_ratio = opts.drop_ratio;
    drop_scale = 1/(1-drop_ratio);
else
    drop_scale = 1;
end

for ii = 1:num_data_layer
    if ii == 1
        net_activation = data';
    else
        net_potential = bsxfun(@plus, drop_scale*net(ii-1).W*net_activation, net(ii-1).b);
%         net_potential = bsxfun(@plus, (1-drop_ratio)*net(ii-1).W*net_activation, net(ii-1).b);

        if ii == num_data_layer
            net_activation = compute_unit_activation(net_potential, opts.unit_type_output);
        else
            net_activation = compute_unit_activation(net_potential, opts.unit_type_hidden);
        end
    end
end

output = net_activation';
