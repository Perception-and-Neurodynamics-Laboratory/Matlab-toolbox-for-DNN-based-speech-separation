function y = relu(x)
   
% slow version
%    y = x;
%    y(y<=0) = 0;

% faster version: make use of matrix opts
   mask = single(x>0);
   y = x.*mask;
end
