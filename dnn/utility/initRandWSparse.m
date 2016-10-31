function W = initRandWSparse(nhid, nvis, isSpecNorm, radius)

if nargin < 3;
    isSpecNorm = 0;
end

W = zeros(nhid,nvis);
P = 15; % only P units are set to nonzeros

for i = 1:nhid
    seq = randperm(nvis,P);
    W(i,seq) = randn(1,P,'single');
end
