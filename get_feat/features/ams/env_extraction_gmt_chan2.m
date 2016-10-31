function env = env_extraction_gmt_chan2(SIG,choice)
%%
R = 4; %decimation factor, R times shorter


dSIG = SIG;

if strcmp(choice, 'abs')
    ENV = abs(dSIG);
elseif strcmp(choice, 'square')
%     ENV = abs(dSIG.^2);
    ENV = abs(dSIG.^2);
else
    printf('Unkownm envelope detection strategy\n');
    exit;
end

env = decimate(ENV,R,'fir');



