function grad = compute_unit_gradient(net_activation,unit_type)
    switch unit_type
        case 'sigm'            
            grad = net_activation.*(1-net_activation); 
        case 'relu'
            grad = single(net_activation>0);
        case 'softmax'
        case 'lin'
            grad = 1;
        case 'tanh'
        otherwise
            error(['unknown activation function:' unit_type])
    end
end
