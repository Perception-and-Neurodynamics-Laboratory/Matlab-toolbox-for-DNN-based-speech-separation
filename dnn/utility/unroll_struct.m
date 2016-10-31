function [ data, label ] = unroll_struct( in_struct )
   data = []; 
   label = [];
   fprintf(1,'input_struct_size = %d\n',size(in_struct,2));
   for i=1:length(in_struct)
        data = [data; transpose(in_struct(i).features)];
        label = [label; transpose(in_struct(i).IBM)];
   end
end

