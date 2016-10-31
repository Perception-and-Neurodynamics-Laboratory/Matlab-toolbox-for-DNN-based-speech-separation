function [perf,perf_str] = checkPerformanceOnData_no_print_wiener(net,data,label,opts)
global feat noise;
num_samples = size(data,1);

if ~opts.eval_on_gpu
    for i = 1:length(net)
        net(i).W = gather(net(i).W);
        net(i).b = gather(net(i).b);
        data = gather(data);
    end
end
noise_feat = sprintf('%-15s', [noise ' ' feat]);
output = getOutputFromNetSplit(net,data,5,opts);

mse = getMSE(output, label);

perf = mse; perf_str = 'MSE';
fprintf(1,[ '#MSE# ' noise_feat ' MSE: ' num2str(mse,'%0.4f')  '\n']);
