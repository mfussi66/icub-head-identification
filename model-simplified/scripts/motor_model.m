%% Mechanical system before joint

% Write down variables with values
syms J1 J2 J3 J4 beta gamma b k R Kt

symvars = [J1 J2 J3 J4 beta gamma b k R Kt].';

driving_pulley_inertia = 0.021 * 1e-6; %kgm^2 
driven_pulley_inertia = 0.0913 * 1e-6; %kgm^2
harmonic_drive_inertia = 0.3 * 1e-6; %kgm^2
head_inertia = 0.21;
mech_filter_k = 200;
mech_filter_b = 20;
timing_belt_ratio = 1.68;
hd_ratio = 100;
Res = 1.9;
Ktv = 13.4 / 1000;

symvalues = [driving_pulley_inertia, driven_pulley_inertia, ...
           harmonic_drive_inertia, head_inertia, timing_belt_ratio, ...
           hd_ratio, mech_filter_b, mech_filter_k Res Ktv]';
tblvals = table(symvars, symvalues);


eta = beta * gamma;

Jt = J3/eta^2 + J2/(beta^2) + J1;

A = [         0           1/eta             -1;
     -k/(eta * Jt) -(b/eta^2 +Kt^2/R)/Jt   b/(eta * Jt);
     k/(J4)    b/(J4 * eta)       -b/(J4)];
C = [k b/eta -b];
B = [0; Kt/Jt/R; 0];


s = sym('s');
mech_tf_sym = simplify(C / (s*eye(3) - A) * B);

%% replace symbolic equation with values

mech_tf_sym = subs(mech_tf_sym, tblvals.symvars, tblvals.symvalues);

As = double(subs(A, tblvals.symvars, tblvals.symvalues));
Bs = double(subs(B, tblvals.symvars, tblvals.symvalues));
Cs = double(subs(C, tblvals.symvars, tblvals.symvalues));
Jtv = double(subs(Jt, tblvals.symvars, tblvals.symvalues));

mech_tf = syms2tf(mech_tf_sym);


%% Plot step
step(mech_tf); grid on; ylabel('\tau_o (Nm)'); 
title('\tau_i to \tau_o transfer function - DC gain=' + string(dcgain(mech_tf)))