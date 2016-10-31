function [net,rest] = netRolling(theta, net_struct)
% from vector to net

nLayer = length(net_struct) - 1;
net = repmat(struct,nLayer,1);
pos = 1;
for ii = 1: nLayer
    vis = net_struct(ii);
    hid = net_struct(ii+1);
    net(ii).W = reshape(theta(pos:pos+vis*hid-1), hid, vis);
    pos = pos+vis*hid;
    
    net(ii).b = theta(pos:pos+hid-1);
    pos = pos+hid;   
end
rest = theta(pos:end);
