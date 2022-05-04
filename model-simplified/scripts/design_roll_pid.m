%% Design controller

%% define the tunable controller
Gc = tunablePID('Gc', 'PID');
Gc.Kp.Minimum = 0;    Gc.Kp.Maximum = inf;
Gc.Ki.Minimum = 0;    Gc.Ki.Maximum = inf;
Gc.Kd.Minimum = 0;    Gc.Kd.Maximum = inf;
Gc.Tf.Minimum = Ts; Gc.Tf.Maximum = 20 * Ts;    % N = 1/Tf
Gc.TimeUnit = 'seconds';
Gc.InputName = 'e';
Gc.OutputName = 'tau';

%% define requirements
responsetime = 0.2;
dcerror = 0.02;
peakerror = 1.03;

peak = 0.1;
tSettle = 0.2;

%% Create uncertain loop
tfu_roll.InputName = 'tau';
tfu_roll.OutputName = 'roll';
Sum = sumblk('e = r - roll');
T = connect(tfu_roll, Gc, Sum,'r','roll', 'tau');
Rtrack = TuningGoal.Tracking('r', 'roll', responsetime, dcerror, peakerror);
Rreject = TuningGoal.StepRejection('tau', 'roll', peak, tSettle);

%% Tune system
tuneopts = systuneOptions('RandomStart', 5);

Gcl = systune(T, Rtrack, Rreject, tuneopts);

tunedValue = getTunedValue(Gcl);
Gc_roll = tunedValue.Gc;
Gc_roll.InputName = 'e';
Gc_roll.OutputName = 'tau';

T = connect(tfu_roll, Gc_roll, Sum, 'r','roll', 'tau');
Sc = getIOTransfer(T,'tau','roll');

%% plot results
close all
figure('color', 'white');
subplot(2,1,1)
step(T, 0.35);
ylim([-0.01, 1.3])
grid('minor');
subplot(2,1,2)
step(Sc, 0.35);
grid('minor');

figure('color', 'white');
viewGoal([Rtrack, Rreject], T)

%% get discretized controller
Gcz_roll = c2d(Gc_roll, Ts, 'tustin');