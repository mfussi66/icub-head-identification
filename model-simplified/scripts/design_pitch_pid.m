%% Design controller

%% define the tunable controller
Gc = tunablePID('Gc', 'PID');
Gc.Kp.Minimum = 0;    Gc.Kp.Maximum = inf;
Gc.Ki.Minimum = 0;    Gc.Ki.Maximum = inf;
Gc.Kd.Minimum = 0;    Gc.Kd.Maximum = inf;
Gc.Tf.Minimum = Ts;   Gc.Tf.Maximum = 20 * Ts;    % N = 1/Tf
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
tfu_pitch.InputName = 'tau';
tfu_pitch.OutputName = 'pitch';
Sum = sumblk('e = r - pitch');
T = connect(tfu_pitch, Gc, Sum,'r','pitch', 'tau');
Rtrack = TuningGoal.Tracking('r', 'pitch', responsetime, dcerror, peakerror);
Rreject = TuningGoal.StepRejection('tau', 'pitch', peak, tSettle);

%% Tune system
tuneopts = systuneOptions('RandomStart', 5, 'UseParallel', true);

Gcl = systune(T,Rtrack, Rreject, tuneopts);

tunedValue = getTunedValue(Gcl);
Gc_pitch = tunedValue.Gc;
Gc_pitch.InputName = 'e';
Gc_pitch.OutputName = 'tau';

T = connect(tfu_pitch, Gc_pitch, Sum, 'r','pitch', 'tau');
Sc = getIOTransfer(T,'tau','pitch');

%% plot results
figure('color', 'white');
step(T, 0.35);
ylim([-0.01, 1.3])
grid('minor');
step(Sc, 0.35);
grid('minor');

figure('color', 'white');
viewGoal([Rtrack, Rreject], T)

%% get discretized controller
Gcz_pitch = c2d(Gc_pitch, Ts, 'tustin');