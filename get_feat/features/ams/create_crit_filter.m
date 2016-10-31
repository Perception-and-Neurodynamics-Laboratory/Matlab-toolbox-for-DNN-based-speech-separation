function [crit_filter CB2FFT] = create_crit_filter(nFFT,num_crit,Srate,opt)
%% Critical Band Indices
% nFFT = 256;
% Srate = 8000;
% num_crit = 25;
% opt = 1: CB 25 channel, preset
% opt = 2: mel spacing
crit_filter = zeros(num_crit,nFFT/2);

if opt == 1
    cent_freq(1)  = 50.0000;   bandwidth(1)  = 70.0000;
    cent_freq(2)  = 120.000;   bandwidth(2)  = 70.0000;
    cent_freq(3)  = 190.000;   bandwidth(3)  = 70.0000;
    cent_freq(4)  = 260.000;   bandwidth(4)  = 70.0000;
    cent_freq(5)  = 330.000;   bandwidth(5)  = 70.0000;
    cent_freq(6)  = 400.000;   bandwidth(6)  = 70.0000;
    cent_freq(7)  = 470.000;   bandwidth(7)  = 70.0000;
    cent_freq(8)  = 540.000;   bandwidth(8)  = 77.3724;
    cent_freq(9)  = 617.372;   bandwidth(9)  = 86.0056;
    cent_freq(10) = 703.378;   bandwidth(10) = 95.3398;
    cent_freq(11) = 798.717;   bandwidth(11) = 105.411;
    cent_freq(12) = 904.128;   bandwidth(12) = 116.256;
    cent_freq(13) = 1020.38;   bandwidth(13) = 127.914;
    cent_freq(14) = 1148.30;   bandwidth(14) = 140.423;
    cent_freq(15) = 1288.72;   bandwidth(15) = 153.823;
    cent_freq(16) = 1442.54;   bandwidth(16) = 168.154;
    cent_freq(17) = 1610.70;   bandwidth(17) = 183.457;
    cent_freq(18) = 1794.16;   bandwidth(18) = 199.776;
    cent_freq(19) = 1993.93;   bandwidth(19) = 217.153;
    cent_freq(20) = 2211.08;   bandwidth(20) = 235.631;
    cent_freq(21) = 2446.71;   bandwidth(21) = 255.255;
    cent_freq(22) = 2701.97;   bandwidth(22) = 276.072;
    cent_freq(23) = 2978.04;   bandwidth(23) = 298.126;
    cent_freq(24) = 3276.17;   bandwidth(24) = 321.465;
    cent_freq(25) = 3597.63;   bandwidth(25) = 346.136;

    % equal weights, non-overlap grouping strategy
    for i = 1:num_crit
        low_f(i) = cent_freq(i) - bandwidth(i)/2;
        up_f(i) = cent_freq(i) + bandwidth(i)/2;
        lower_ind(i) = ceil(low_f(i)/Srate*nFFT);
        upper_ind(i) = ceil(up_f(i)/Srate*nFFT);
        if i>1
            if lower_ind(i)<=upper_ind(i-1)
                lower_ind(i) = upper_ind(i-1) + 1;
            end
        end
        if upper_ind(i)<lower_ind(i)
            upper_ind(i) = lower_ind(i);
        end
        crit_filter(i,lower_ind(i):upper_ind(i)) = 1;%/(upper_ind(i) - lower_ind(i) + 1);
    end

    CB2FFT = crit_filter';

    for i = 1:nFFT/2
        S = sum(CB2FFT(i,:));
        if S>0
            CB2FFT(i,:) = CB2FFT(i,:)/S;
        end
    end

else
    [lower cent_freq upper] = mel(num_crit,0,Srate/2);
    bandwidth = round(upper - lower);
    cent_freq = round(cent_freq);

%     bw_min      = bandwidth (1);
%     min_factor = exp (-30.0 / (2.0 * 2.303));

%     for i = 1:num_crit
%         f0 = (cent_freq(i)/(Srate/2)) * (nFFT/2);
%         all_f0(i) = floor(f0);
%         bw = (bandwidth(i)/(Srate/2)) * (nFFT/2);
%         norm_factor =1;% log(bw_min) - log(bandwidth(i));
%         j = 0:1:(nFFT/2)-1;
%         crit_filter(i,:) = exp (-11 *(((j - floor(f0)) ./bw/2).^2) + norm_factor);
%     end

    for i = 1:num_crit
        low_f(i) = cent_freq(i) - bandwidth(i)/2;
        up_f(i) = cent_freq(i) + bandwidth(i)/2;
        lower_ind(i) = ceil(low_f(i)/Srate*nFFT);
        upper_ind(i) = ceil(up_f(i)/Srate*nFFT);
        if i>1
            if lower_ind(i)<=upper_ind(i-1)
                lower_ind(i) = upper_ind(i-1) + 1;
            end
        end
        if upper_ind(i)<lower_ind(i)
            upper_ind(i) = lower_ind(i);
        end
        crit_filter(i,lower_ind(i):upper_ind(i)) = 1;%/(upper_ind(i) - lower_ind(i) + 1);
    end

    % initialize the inverse filter
    CB2FFT = crit_filter';

    for i = 1:nFFT/2
        S = sum(CB2FFT(i,:));
        if S>0
            CB2FFT(i,:) = CB2FFT(i,:)/S;
        end
    end
end

%
return;
% figure
ff = (1:nFFT/2);%*Srate/2/(nFFT/2);
for i =1 :num_crit
    plot(ff, crit_filter(i,:));
    hold on
end
% ylim([0 1.2])
hold off

return;