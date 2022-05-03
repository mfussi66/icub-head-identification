%% Design controller

%% define the tunable controller
Gc = tunablePID('Gc', 'PID');
Gc.Kp.Minimum = 0;    Gc.Kp.Maximum = inf;
Gc.Ki.Minimum = 0;    Gc.Ki.Maximum = inf;
Gc.Kd.Minimum = 0;    Gc.Kd.Maximum = inf;
Gc.Tf.Minimum = 0.5 * Ts; Gc.Tf.Maximum = 20 * Ts;    % N = 1/Tf
Gc.TimeUnit = 'seconds';
Gc.InputName = 'e';
Gc.OutputName = 'u';

%% define requirements
responsetime = 0.2;
dcerror = 0.1;
peakerror = 1.0;

peak = 0.1;
tSettle = 0.2;

%% Create uncertain loop
tfu_pitch.InputName = 'u';
tfu_pitch.OutputName = 'y';
Sum = sumblk('e = r - y');
T = connect(tfu_pitch, Gc, Sum,'r','y', 'u');
Rtrack = TuningGoal.Tracking('r', 'y', responsetime, dcerror, peakerror);
Rreject = TuningGoal.StepRejection('u', 'y', peak, tSettle);

%% Tune system
tuneopts = systuneOptions('RandomStart', 5);

Gcl = systune(T, Rtrack, Rreject, tuneopts);

tunedValue = getTunedValue(Gcl);
Gc_pitch = tunedValue.Gc;
Gc_pitch.InputName = 'e';
Gc_pitch.OutputName = 'u';

T = connect(tfu_pitch, Gc_pitch, Sum, 'r','y', 'u');
S = getIOTransfer(T,'u','y');

%% plot results
figure('color', 'white');
subplot(2,1, 1)
step(T);
ylim([-0.01, 1.3])
grid('minor');
subplot(2,1, 2)
step(S);
grid('minor');

%% get discretized controller
Gcz_pitch = c2d(Gc_pitch, Ts, 'tustin');