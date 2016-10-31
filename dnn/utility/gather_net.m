function net_cpu = gather_net(net_gpu)

net_cpu = net_gpu;
for i = 1:length(net_cpu)
    net_cpu(i).W = gather(net_cpu(i).W);
    net_cpu(i).b = gather(net_cpu(i).b);
end
