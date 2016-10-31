function W = initializeRandWSparse(nhid, nvis, isSpecNorm, radius)

if nargin < 3;
    isSpecNorm = 0;
    radius = nan;
end

W = zeros(nhid,nvis,'single');

for i = 1:nhid
    seq = randperm(nvis,15);
    W(i,seq) = randn(1,15,'single');
end

if isSpecNorm
   [~,v] = eig(W);
   W = W/max(diag(abs(v))); % spec-radius = 1
   W = radius*W; % set to the specified radius
end
