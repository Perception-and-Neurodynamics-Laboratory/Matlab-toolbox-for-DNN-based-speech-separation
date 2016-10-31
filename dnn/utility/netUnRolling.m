function theta = netUnRolling(net)

theta = [];
for ll = 1:length(net);
    theta = [theta; net(ll).W(:); net(ll).b(:)];
end