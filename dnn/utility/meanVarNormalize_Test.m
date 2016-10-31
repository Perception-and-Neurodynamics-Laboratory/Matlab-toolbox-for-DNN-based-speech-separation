function nm = MeanVarNormalize_Test(data,mu,std)
% mean+var norm for test data using previously obtained mean/var values

%%
% mean removal
mean0 = bsxfun(@minus,data,mu);
% variance normalization
nm = bsxfun(@rdivide,mean0,std);
% treatment when std==0
nm(isnan(nm)) = 0; 