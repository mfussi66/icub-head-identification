%% Define neck waypoints

wp = [ 0, 25, 25, -25, -25, -25, -25, 25, 25, 0;
       0, 11, 11,  11,  11, -11, -11, -11, -11, 0];

tp = 0:size(wp, 2)-1;

vel_bounds = zeros(size(wp));
accel_bounds = zeros(size(wp));