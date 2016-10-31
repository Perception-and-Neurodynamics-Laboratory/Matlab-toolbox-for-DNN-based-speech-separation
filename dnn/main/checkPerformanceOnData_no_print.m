function [perf,perf_str] = checkPerformanceOnData_no_print(net,data,label,opts)

if ~opts.eval_on_gpu
    for i = 1:length(net)
        net(i).W = gather(net(i).W);
        net(i).b = gather(net(i).b);
        data = gather(data);
    end
end

output = getOutputFromNetSplit(net,data,5,opts);

prediction = single(output>0.5);

[current_acc,hit,fa] = getHITFA(label(:),prediction(:));
perf = hit - fa; perf_str = 'HIT-FA';
