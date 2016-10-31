function net = randinitWbSparse(netstruct, isNorm)

if nargin < 2; isNorm = 0; end;

nLayer = length(netstruct)-1;

net = repmat(struct,nLayer,1);
for i = 1: nLayer
    net(i).W = initializeRandWSparse(netstruct(i+1),netstruct(i));
    net(i).b = zeros(netstruct(i+1),1);
    
    if isNorm
        tmp = net(i).W;
        net(i).W = tmp ./ repmat(sqrt(sum(tmp.^2,2)), 1, size(tmp,2)); 
    end
    
end
