function [mva_data,mu,std] = meanVarArmaNormalize(data,order)
% mean/var norm + ARMA filtering

[mv_data,mu,std] = meanVarNormalize(data);
mva_data = doARMA(mv_data,order);
end
