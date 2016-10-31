function  out_index = count_struct( in_struct )
   out_index = zeros(length(in_struct),1);   
   for i=1:length(in_struct)
        out_index(i) = length(in_struct(i).IBM(1,:));
   end
end
