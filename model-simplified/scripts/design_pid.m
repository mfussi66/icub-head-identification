%% Design controller

% define the tunable controller
Gc = tunablePID('Gc', 'PID');
Gc.Kp.Minimum = 0;    Gc.Kp.Maximum = inf;
Gc.Ki.Minimum = 0;    Gc.Ki.Maximum = inf;
Gc.Kd.Minimum = 0;    Gc.Kd.Maximum = inf;
Gc.Tf.Minimum = 2*0.001; Gc.Tf.Maximum = 10*0.001;    % N = 1/Tf
Gc.TimeUnit = 'seconds';
Gc.InputName = 'e';
Gc.OutputName = 'u';

% define requirements
responsetime = 0.03;
dcerror = 0.01;
peakerror = 1.3;

peak = 0.1;
tSettle = 1;

tt = mech_tf_static * tfu;
tt.InputName = 'u';
tt.OutputName = 'y';

d = AnalysisPoint('d');
Sum = sumblk('e = r - y');
T = connect(tt, Gc, Sum, 'r','y');
Rtrack_1 = TuningGoal.Tracking('r', 'y', responsetime, dcerror, peakerror);
Rreject_1 = TuningGoal.StepRejection('d', 'y', getIOTransfer(T,'u', 'y'));

tuneopts = systuneOptions('RandomStart', 10);

Gcl = systune(T, Rtrack_1, Rreject_1, tuneopts);
tunedValue = getTunedValue(Gcl);
Gc = tunedValue.Gc;
Gc.InputName = 'e';
Gc.OutputName = 'u';
T = connect(tt, Gc, Sum, 'r','y');

% plot results
figure('color', 'white');
%h1 = subplot(2, 1, 1);
%h2 = subplot(2, 1, 2);

stepplot(T);
title('Step Response');
grid('minor');

%% get discretized controller

Gcz = c2d(Gc, 0.001, 'tustin');
