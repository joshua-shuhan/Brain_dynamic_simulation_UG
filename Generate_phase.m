clc
clear

sig_pl_fpn = sig_seed(31:59, :, plFPNcommu);
sig_pl_dmn = sig_seed(31:59, :, plDMNcommu);
fpnmean = mean(sig_pl_fpn, 3);
dmnmean = mean(sig_pl_dmn, 3);
Hilbertsigphase = zeros(59, 140, 90);
for i = 1:59
    for j = 1:90
        sig = sig_seed(i, :, j);
        if mean(sig) > 0
            sig = sig - abs(mean(sig));
        end
        if mean(sig) < 0
            sig = sig + abs(mean(sig));
        end
        sigphase = (unwrap(angle(hilbert(sig))));
        Hilbertsigphase(i, :, j) = sigphase;
    end
end
