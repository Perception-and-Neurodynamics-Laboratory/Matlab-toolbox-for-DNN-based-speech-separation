function [ mask ] = ideal( mat_s, mat_n, mixture_snr)
    [line, column] = size(mat_s);
    mask = zeros(line, column);
    for i=1:line
        for j=1:column
            if( ( 10*log10( mat_s(i,j)/mat_n(i,j) ) ) >= (mixture_snr-5) ) 
                mask(i,j) = 1;
            else
                mask(i,j) = 0;
            end
        end
    end
end

