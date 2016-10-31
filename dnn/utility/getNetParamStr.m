function str = getNetParamStr(opts)

str = '';

for i = 1:length(opts.net_struct)
    str = [str,num2str(opts.net_struct(i)),'.'];
end

str = [str, opts.unit_type_hidden];
str = [str,'.',opts.learner];
if opts.isDropout
    str = [str,'.dropout' ];
else
    str = [str,'.no_dropout'];
end
