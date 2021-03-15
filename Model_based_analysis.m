clc
clear

phase_seed_trim_diff = zeros(59, 100, 90, 90);
for i = 1 : 59
    for j = 1: 90
        for k = 1: 90
            phase_seed_trim_diff(i, :, j, k) = phase_seed_trim(i, :, j) - phase_seed_trim(i, :, k);
        end
    end
end

func_pattern = zeros(59, 5, 90, 90);
sin_phase_seed_trim_diff = sind(phase_seed_trim_diff);
% sin_Tmean_phase_diff is the functional pattern (average over time)
sin_Tmean_phase_diff = squeeze(mean(sin_phase_seed_trim_diff, 2));
sin_Tmean_PL = sin_Tmean_phase_diff(31:59, :, :);

%% Estimate natural frequency
sin_seed = sind(phase_seed_trim);
sin_seed_fft = zeros(59, 50, 90);
for i = 1:59
    for j = 1:90
        var = abs(fft(sin_seed(i, :, j)));
        sin_seed_fft(i, :, j) = var(1:50);
    end
end

natural_freq = zeros(59, 90);
for i = 1:59
    for j = 1:90
        [~, pos] = max(sin_seed_fft(i, :, j));
        natural_freq(i, j) = pi * pos * 0.5 / 50; % Omega
        % In APP:Signal Analyzer, multiply the x coord with 1/Fs (=2) gives the same result
    end
end

%% Order parameter comparison
phase_seed_trim_rad = phase_seed_trim * pi / 180;

PL_fpn_phase_rad = phase_seed_trim_rad(31:59, :, plFPNcommu);
PL_fpn_order_para = zeros(29, 100);
for i = 1:29
    for j = 1:100
        PL_fpn_order_para(i, j) = mean(exp(1i * PL_fpn_phase_rad(i, j, :)));
    end
end
PL_fpn_R = abs(PL_fpn_order_para);

PL_dmn_phase_rad = phase_seed_trim_rad(31:59, :, plDMNcommu);
PL_dmn_order_para = zeros(29, 100);
for i = 1:29
    for j = 1:100
        PL_dmn_order_para(i, j) = mean(exp(1i * PL_dmn_phase_rad(i, j, :)));
    end
end
PL_dmn_R = abs(PL_dmn_order_para);

OT_fpn_phase_rad = phase_seed_trim_rad(1:30, :, plFPNcommu);
OT_fpn_order_para = zeros(30, 100);
for i = 1:30
    for j = 1:100
        OT_fpn_order_para(i, j) = mean(exp(1i * OT_fpn_phase_rad(i, j, :)));
    end
end
OT_fpn_R = abs(OT_fpn_order_para);

OT_dmn_phase_rad = phase_seed_trim_rad(1:30, :, plDMNcommu);
OT_dmn_order_para = zeros(30, 100);
for i = 1:30
    for j = 1:100
        OT_dmn_order_para(i, j) = mean(exp(1i * OT_dmn_phase_rad(i, j, :)));
    end
end
OT_dmn_R = abs(OT_dmn_order_para);

clear var
variance_PL_fpn = var(PL_fpn_R, 0, 2);
variance_OT_fpn = var(OT_fpn_R, 0, 2);
% variance_PL_dmn = var(PL_dmn_R,0,2);
% variance_OT_dmn = var(OT_dmn_R,0,2);
var_data = [variance_PL_fpn' NaN; variance_OT_fpn']
boxplot2(var_data')
hold on
scatter(1 * ones(1, length(variance_PL_fpn)), variance_PL_fpn, 30, '*', 'blue');
hold on
scatter(2 * ones(1, length(variance_OT_fpn)), variance_OT_fpn, 30, '*', 'red');

