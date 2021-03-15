clc
clear

sig_pl_fpn = sig_seed(31:59, :, plFPNcommu);
sig_pl_dmn = sig_seed(31:59, :, plDMNcommu);
fpnmean = mean(sig_pl_fpn, 3);
dmnmean = mean(sig_pl_dmn, 3);

%% Generate phase signal
phase_seed = zeros(59, 140, 90);
for k = 1: 59
    for m = 1: 90
        test1 = sig_seed(k, :, m);
        % This is used for storing pos of locmax and locmin. 1 for max or
        % min
        log_locmax = logical(zeros(1, 140));
        log_locmin = logical(zeros(1, 140));
        
        if test1(1) > mean(test1(1: 5))
            log_locmax(1) = true;
            initmaxflag = true;      % assume 90 degree phase in intial state
        else
            log_locmin(1) = true;
            initmaxflag = false;
        end
        ii = 1;
        for i = 6: 135    % Ignore some initial stages and final stages 4 the sake of index overflow
            % The first 2 conditions are only used once
            if test1(i) > test1(i-1) && test1(i) > test1(i+1) && test1(i) > test1(i-5) && test1(i) > test1(i+5) && initmaxflag == false && ii == 1
                log_locmax(i) = true;
                ii = 2;
                flag0 = true;
                flag1 = false;
            end
            if test1(i) < test1(i-1) && test1(i) < test1(i+1) && test1(i) < test1(i-5) && test1(i) < test1(i+5) && initmaxflag == true && ii == 1
                log_locmin(i) = true;
                ii = 2;
                flag0 = false;
                flag1 = true;
            end
            if test1(i) > test1(i-1) && test1(i) > test1(i+1) && test1(i) > test1(i-5) && test1(i) > test1(i+5) && ii ~= 1 && flag0 == false && flag1 == true
                log_locmax(i) = true;
                flag0 = true;
                flag1 = false;
            end
            if test1(i) < test1(i-1) && test1(i) < test1(i+1) && test1(i) < test1(i-5) && test1(i) < test1(i+5) && ii ~= 1 && flag0 == true && flag1 == false
                log_locmin(i) = true;
                flag0 = false;
                flag1 = true;
            end
        end
        % Store the position
        pos_locmin = find(log_locmin == 1);
        pos_locmax = find(log_locmax == 1);
        phasemat = zeros(1, 140);
        phasemat(log_locmin) = -90;
        phasemat(log_locmax) = 90;
        
        if initmaxflag == true
            % If the initial phases are the same, then the only difference is the
            % length of sep_space.
            if length(pos_locmax) > length(pos_locmin)
                sep_space = zeros(1, 2*(length(pos_locmax)-1));
            end
            if length(pos_locmax) == length(pos_locmin)
                sep_space = zeros(1, 2*(length(pos_locmax)-1)+1);
            end
            
            for i = 1: length(sep_space)
                if mod(i,2)==1
                    sep_space(i) = pos_locmin(1+((i-1)/2))-pos_locmax(1+((i-1)/2));
                end
                if mod(i, 2)==0
                    sep_space(i) = pos_locmax(1+(i/2))-pos_locmin(i/2);
                end
            end
        end
        
        
        if initmaxflag == false
            if length(pos_locmin) > length(pos_locmax)
                sep_space = zeros(1, 2*(length(pos_locmin)-1));
            end
            if length(pos_locmin) == length(pos_locmax)
                sep_space = zeros(1, 2*(length(pos_locmin)-1)+1);
            end
            for i = 1: length(sep_space)
                if mod(i, 2) == 1
                    sep_space(i) = pos_locmax(1+((i-1)/2))-pos_locmin(1+((i-1)/2));
                end
                if mod(i, 2) == 0
                    sep_space(i) = pos_locmin(1+(i/2))-pos_locmax(i/2);
                end
            end
        end
        
        index4sep = 1;      % clock
        % Wait for a second. Any good way to specify the degree?
        % For convenience, set phase after the last locmax or locmin as 0
        for i =1: sum(sep_space)+1
            if i == sum(sep_space)+1
               phasemat(i: 140) = 0;
               break
            end
            if phasemat(i) == 90
                phasemat(i: i+sep_space(index4sep)) = [90: -180/sep_space(index4sep): -90];
                index4sep = index4sep + 1;
            end
            if phasemat(i) == -90
                phasemat(i: i+sep_space(index4sep)) = [-90: 180/sep_space(index4sep):90];
                index4sep = index4sep + 1;
            end
        end
        phase_seed(k, :, m) = phasemat;
    end
end
% Trim the phase mat. The phase of the intial and the final part is
% difficult to determine.
phase_seed_trim = phase_seed(:, 21:120, :);

