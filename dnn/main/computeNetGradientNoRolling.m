function [cost, net_gradients] = computeNetGradientNoRolling(net, data, label, opts)
num_net_layer = length(net);
unit_type_output = opts.unit_type_output;
unit_type_hidden = opts.unit_type_hidden;

[forward_path drop_mask] = forwardPass(net, data, opts);
num_sample = size(data,1);
output = forward_path{num_net_layer+1}';
%% cost function: mse, xentropy, softmax_xentropy
switch opts.cost_function
    case 'mse'
        cost = 0.5*sum(sum((label-output).^2))/num_sample;
        output_delta = -(label-output).*compute_unit_gradient(output,unit_type_output);
    case 'xentropy'
        cost = -mean(label.*log(output) + (1-label).*log(1-output));
        if strcmp(unit_type_output,'sigm');
            output_delta = -(label-output);
        else
            output_delta = -(label-output)./(output.*(1-output)).*compute_unit_gradient(output,unit_type_output);
        end
    case 'softmax_xentropy'
        cost = -sum(sum(label.*log(output)))/num_sample;
        assert(strcmp(unit_type_output,'softmax'));
        output_delta = -(label-output);
end
%% backprop
net_gradients = zeroInitNet(opts.net_struct,opts.isGPU);

upper_layer_delta = output_delta;
for ll = num_net_layer: -1: 1
    net_gradients(ll).W = (forward_path{ll}*upper_layer_delta)'/num_sample;
    net_gradients(ll).b = mean(upper_layer_delta)';
    
    upper_layer_delta = ((upper_layer_delta*net(ll).W)'.*drop_mask{ll}.*compute_unit_gradient(forward_path{ll},unit_type_hidden))';
end
