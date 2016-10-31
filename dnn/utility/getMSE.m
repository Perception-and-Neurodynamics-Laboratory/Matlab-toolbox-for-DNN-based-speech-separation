function mse = getMSE(gnd, predlb)
    mse = mean( mean( (gnd-predlb).^2 ) );
end
