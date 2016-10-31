function [nm, mu, std] = mean_var_norm(data)
% mean/var norm w.r.t features

% NOTE: when data is a single point, the following still
%       performs mean/var norm, but w.r.t. that single point
%       rather than features. --> change to mean(data,1); var(data,1)
%       esstially the same as mean_var_norm_row

% mean removal
% tmp = data-repmat(mean(data),size(data,1),1);
mu = mean(data);

%bsxfun element-wise binary operation, data - mu
tmp = bsxfun(@minus,data,mu);

% variance normalization
% nm = tmp ./ repmat(sqrt(var(data)),size(data,1),1);
std = sqrt(var(data));
nm = bsxfun(@rdivide,tmp,std);
% nm = tmp;
