function [lower,center,upper]= mel(N,low,high)

% This function returns the lower, center and upper freqs
% of the filters equally spaced in mel-scale
% Input: N - number of filters
%        low - (left-edge) 3dB point of the first filter
%        high - (right-edge) 3dB point of the last filter
%
% Copyright (c) 1996 by Philipos C. Loizou
%

 ac=1000; fc=800;

 DBG=0;
 LOW =ac*log(1+low/fc);
 HIGH=ac*log(1+high/fc);
 N1=N+1;
 e1=exp(1);
 if DBG==1
         f=low:100:high;
         plot(f,ac*log(1+f/fc));
         grid
         hold on
 end
 fmel(1:N1)=LOW+[1:N1]*(HIGH-LOW)/N1;
 cen2 = fc*(e1.^(fmel/ac)-1);
 lower=zeros(1,N); upper=zeros(1,N); center=zeros(1,N);

 lower(1:N)=cen2(1:N);
 upper(1:N)=cen2(2:N+1);
 center(1:N) = 0.5*(lower+upper); %cen2(1:N);


 if DBG==1,
  diff(center)
  plot(center,fmel(1:N),'ro');
 end;