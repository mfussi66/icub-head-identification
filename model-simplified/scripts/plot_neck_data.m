%% Plot neck data
tiledlayout(2, 1)
nexttile
plot(out.pitch, 'LineWidth', 1.0);
hold on
plot(out.ref.Time, out.ref.Data(1,:), '--', 'LineWidth', 1.0);
title('Pitch angle')
ylabel('pitch [deg]')
xlabel('time [sec]')
legend({'value', 'setpoint'});
grid on
nexttile
plot(out.roll, 'LineWidth', 1.1);
hold on
plot(out.ref.Time, out.ref.Data(2,:), '--', 'LineWidth', 1.1);
title('Roll angle')
ylabel('roll [deg]')
legend({'value', 'setpoint'});
xlabel('time [sec]')
legend({'value', 'setpoint'});
grid on

% exportgraphics(gcf, 'pitchroll_combined.png')

tiledlayout(2, 1)
nexttile
plot(out.voltage.Time, out.voltage.Data(:, 1), 'LineWidth', 1.1);
title('Motor 0 voltage percentage')
ylabel('Voltage [V]')
grid on
nexttile
plot(out.voltage.Time, out.voltage.Data(:, 2), 'LineWidth', 1.1);
title('Motor 1 voltage percentage')
ylabel('Voltage [V]')
xlabel('time [sec]')
grid on

% exportgraphics(gcf, 'tau_combined.png')
