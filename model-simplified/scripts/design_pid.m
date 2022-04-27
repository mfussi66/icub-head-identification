

%% Ctrl

% define the tunable controller
Gc = tunablePID('Gc', 'PID', Ts);
Gc.IFormula = 'trapezoidal';
Gc.DFormula = 'trapezoidal';
Gc.Kp.Minimum = 0;    Gc.Kp.Maximum = inf;
Gc.Ki.Minimum = 0;    Gc.Ki.Maximum = inf;
Gc.Kd.Minimum = 0;    Gc.Kd.Maximum = inf;
Gc.Tf.Minimum = 2*Ts; Gc.Tf.Maximum = 10*Ts;    % N = 1/Tf
Gc.TimeUnit = 'seconds';

% define requirements
responsetime = 0.2;
dcerror = 0.1;
peakerror = 1.2;

peak = 0.1;
tSettle = 1;

d = AnalysisPoint('d1');
Gcl0_1 = feedback(ld{1} * d * Gc, 1);
Gcl0_1.InputName = 'r';
Gcl0_1.OutputName = 'y1';
Rtrack_1 = TuningGoal.Tracking('r', 'y1', responsetime, dcerror, peakerror);
Rreject_1 = TuningGoal.StepRejection('d1', 'y1', peak, tSettle);

d = AnalysisPoint('d2');
Gcl0_2 = feedback(ld{2} * d * Gc, 1);
Gcl0_2.InputName = 'r';
Gcl0_2.OutputName = 'y';
Rtrack_2 = TuningGoal.Tracking('r', 'y', responsetime, dcerror, peakerror);
Rreject_2 = TuningGoal.StepRejection('d2', 'y', peak, tSettle);

d = AnalysisPoint('d3');
Gcl0_3 = feedback(ld{3} * d * Gc, 1);
Gcl0_3.InputName = 'r';
Gcl0_3.OutputName = 'y';
Rtrack_3 = TuningGoal.Tracking('r', 'y', responsetime, dcerror, peakerror);
Rreject_3 = TuningGoal.StepRejection('d3', 'y', peak, tSettle);

aa = [Gcl0_1 Gcl0_2 Gcl0_3];

tuneopts = systuneOptions('RandomStart', 10);

Gcl = systune(aa, [Rtrack_1, Rtrack_2, Rtrack_3], [Rreject_1, Rreject_2, Rreject_3], tuneopts);
tunedValue = getTunedValue(Gcl);
Gc = tunedValue.Gc;


% plot results
figure('color', 'white');
h1 = subplot(2, 1, 1);
h2 = subplot(2, 1, 2);

stepplot(h1, Gcl);
title('Step Response');
grid('minor');

stepplot(h2, getIOTransfer(Gcl, 'd', 'y'));
title('Step Disturbance Rejection');
grid('minor');

linkaxes([h1 h2], 'x');
