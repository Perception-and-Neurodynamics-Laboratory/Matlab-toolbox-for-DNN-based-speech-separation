function [nm,mu,std] = meanVarNormalize(data)
% data: mxd
% mean+var norm for training set
%%
mu = mean(data);
std = sqrt(var(data));

% mean removal
mean0 = bsxfun(@minus, data, mu);
% variance normalization
nm = bsxfun(@rdivide, mean0, std);
