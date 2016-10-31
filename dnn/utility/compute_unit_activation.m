function net_activation = compute_unit_activation(net_potential,unit_type)

switch unit_type
    case 'sigm'
        net_activation = sigmoid(net_potential);
    case 'lin'
        net_activation = net_potential;
    case 'relu'
        net_activation = relu(net_potential);
    case 'tanh'
    case 'softmax'
        net_activation = softmax(net_potential);
    otherwise
        error(['unknown activation function:' unit_type])
end

