function W = initRandW(nhid,nvis)

r  = 6 / sqrt(nhid+nvis+1);  
W  = rand(nhid, nvis,'single') * 8 * r - 4*r;
