%% Search for a specified operating point for the model - lumped_neck.
%
% This MATLAB script is the command line equivalent of the trim model
% tab in linear analysis tool with current specifications and options.
% It produces the exact same operating points as hitting the Trim button.

% MATLAB(R) file generated by MATLAB(R) 9.11 and Simulink Control Design (TM) 6.0.
%
% Generated on: 21-Apr-2022 15:01:24

%% Specify the model name
model = 'lumped_neck_with_motor_roll';

roll_operating_points = [-20, 0, 20]; % degrees

%% Create the operating point specification object.
% Create the options
opt = findopOptions('DisplayReport','iter');

ls = cell(1,length(roll_operating_points));
op_points_roll = cell(1,length(roll_operating_points));
for i = 1:length(roll_operating_points)
   [ls{i}, op_points_roll{i}] = linearize_roll(model, roll_operating_points(i), opt);
end

%% plot of poles and zeros
figure()
pzmap(ls{:})
grid on

figure()
step(ls{:}, 1)
grid minor
legend({'-20°','0°', '20°'}, 'location', 'northwest')
ylabel('Roll (deg)')
title('Step response of linearized pitch model at different operating points')
subtitle('from roll torque to roll angle')
%% Build uncertain system

% print zpk form
zpk(ls{1})
zpk(ls{2})
zpk(ls{3})

j = 1;
positive_poles_matrix = [];
for idx = 1:length(roll_operating_points)
    i = 1;
    l = zpk(ls{idx});
    for p = l.P{1}'
        if p > 0.0
            positive_poles_matrix(i, j) = p;
            i = i + 1;
        end
    end
    j = j + 1;
end

nominal_pole_index = intersect(...
    find(positive_poles_matrix ~=(min(positive_poles_matrix))), ...
    find(positive_poles_matrix ~=(max(positive_poles_matrix)))...
);

nominal_pole = mean(positive_poles_matrix(nominal_pole_index));

%mps = ureal('mech_poles', 7.79, 'range', [6.426, 8]); % 2 poles: one positive, one negative
%uz = ureal('unstable_zero', 8.074, 'range', [6.796, 8.1]);

uncertain_stable_p1 = ureal('stable_p1', -72.3, 'range', [-72.35, -72.3 * 0.95]);
uncertain_stable_p2 = ureal('stable_p2', -10.05, 'range', [-10.07, -10.05 * 0.95]);
uncertain_unstable_p = ureal('unstable_p', nominal_pole, 'range', [min(positive_poles_matrix), max(positive_poles_matrix)]);

s = tf('s'); tfu_roll = uss(3.0702e07 * (s+10)/ ((s+1.597e04)*(s - uncertain_stable_p1)*(s - uncertain_stable_p2) * (s - uncertain_unstable_p)));

%% Discretize models
% Ts = 1e-3;
% 
% ld = cell(1, length(pitch_operating_points));
% 
% for i = 1:length(pitch_operating_points)
%     ld{i} = c2d(ls{i}, Ts, 'tustin');
% end
% 
% print zpk form
% zpk(ld{1})
% zpk(ld{2})
% zpk(ld{3})
% 
% mp_z = ureal('mech_pole', 0.9922, 'range', [0.991, 0.9936]);
% uz_z = ureal('unstable_zero', 1.007, 'range', [1.0065, 1.008]);
% up_z = ureal('unstable_pole_1', 1.007, 'range', [1.0065, 1.008]);
% up2_z = ureal('unstable_pole_2', 1.008, 'range', [1.006, 1.0085]);
% 
% k = 0.0004086;
% 
% z = tf('z');
% 
% tfu_z = k * (z + 1)^2 * (z - uz_z)/ ((z - mp_z) * (z - up_z) * (z - up2_z));
% 
% tfu_z.Ts = 1e-3;

% figure()
% step(ld{:}, 1)
% grid minor
% legend({'-40°','0°', '22°'}, 'location', 'northwest')
% ylabel('Pitch (deg)')
% title('Step response of linearized pitch model at different operating points')
% subtitle('from pitch torque to pitch angle')
