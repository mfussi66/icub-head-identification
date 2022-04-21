function [sys, op] = linearize_pitch(model, pitch_op_point, options, display_step) 

sprintf('Finding operating point for pitch=%.1f', pitch_op_point)

opspec = operspec(model);
% - The defaults for all states are Known = false, SteadyState = true,
%   Min = -Inf, Max = Inf, dxMin = -Inf, and dxMax = Inf.

% State (1) - lumped_neck/Joints/Config/Solver Configuration/EVAL_KEY/INPUT_1_1_1
% - Default model initial conditions are used to initialize optimization.

% State (2) - lumped_neck/Joints/Config/Solver Configuration/EVAL_KEY/INPUT_2_1_1
% - Default model initial conditions are used to initialize optimization.

% State (3) - lumped_neck/Joints/pitch_revolute
% - Default model initial conditions are used to initialize optimization.
opspec.States(3).x = deg2rad(pitch_op_point);
opspec.States(3).Known = true;
opspec.States(3).SteadyState = false;
opspec.States(3).dxMin = 0;
opspec.States(3).dxMax = 0;

% State (4) - lumped_neck/Joints/pitch_revolute
% - Default model initial conditions are used to initialize optimization.
opspec.States(4).Known = true;
opspec.States(4).SteadyState = false;

% State (5) - lumped_neck/Joints/roll_revolute
opspec.States(5).x = 0;
opspec.States(5).Known = true;
opspec.States(5).SteadyState = false;
opspec.States(5).dxMin = 0;
opspec.States(5).dxMax = 0;

% State (6) - lumped_neck/Joints/roll_revolute
% - Default model initial conditions are used to initialize optimization.
opspec.States(6).Known = true;
opspec.States(6).SteadyState = false;

%% Set the constraints on the inputs in the model.
% - The defaults for all inputs are Known = false, Min = -Inf, and
% Max = Inf.

% Input (1) - lumped_neck/up
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(1).Known = true;

% Input (2) - lumped_neck/ur
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(2).Known = true;

%% Set the constraints on the outputs in the model.
% - The defaults for all outputs are Known = false, Min = -Inf, and
% Max = Inf.

% Output (1) - lumped_neck/yp
% - Default model initial conditions are used to initialize optimization.
opspec.Outputs(1).y = pitch_op_point;
opspec.Outputs(1).Known = true;

% Output (2) - lumped_neck/yr
% - Default model initial conditions are used to initialize optimization.
opspec.Outputs(2).Known = true;


%% Perform the operating point search.
[op, ~] = findop(model, opspec, options);

%% Specify the analysis I/Os
% Create the analysis I/O variable IOs2
io(1) = linio('lumped_neck/up',1,'input');
io(2) = linio('lumped_neck/Joints',1,'output');

% Linearize the model in continous time
sys = linearize(model, io, op);

if (display_step == 1)
    step(sys)
end

end