%% Specifications 
close all

Ts = 1e-3;          % sec
responsetime = 0.2; % sec
dcerror = 0.02;     % perc
peakerror = 1.03;   % fract relative
peak = 0.1;         % abs deg
tSettle = 0.2;      % sec

%% Run autotune for pitch

Rtrack = TuningGoal.Tracking('r', 'pitch', responsetime, dcerror, peakerror);
Rreject = TuningGoal.StepRejection('tau', 'pitch', peak, tSettle);

[C_pitch, T_pitch, Sc_pitch] = design_robust_pid(tfu_pitch, 'pitch',...
                                                 Ts, Rtrack, Rreject);

% plot results
figure('color', 'white');
subplot(2, 1, 1)
step(T_pitch, 0.35);
ylim([-0.01, 1.3])
grid('minor');
subplot(2, 1, 2)
step(Sc_pitch, 0.35);
grid('minor');

figure('color', 'white');
viewGoal([Rtrack, Rreject], T_pitch)

% get discretized controller
Cz_pitch = c2d(C_pitch, Ts, 'tustin');

%% Run autotune for roll

Rtrack = TuningGoal.Tracking('r', 'roll', responsetime, dcerror, peakerror);
Rreject = TuningGoal.StepRejection('tau', 'roll', peak, tSettle);
    
[C_roll, T_roll, Sc_roll] = design_robust_pid(tfu_roll, 'roll',...
                                              Ts, Rtrack, Rreject);

% plot results
figure('color', 'white');
subplot(2,1,1)
step(T_roll, 0.35);
ylim([-0.01, 1.3])
grid('minor');
subplot(2,1,2)
step(Sc_roll, 0.35);
grid('minor');

figure('color', 'white');
viewGoal([Rtrack, Rreject], T_roll)

% get discretized controller
Cz_roll = c2d(C_roll, Ts, 'tustin');