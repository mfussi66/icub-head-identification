%% Run multiple simulations with different head weights to evaluated the needed torque

close all

mass_percentages = [1, 2, 4, 6, 8, 10];

ratio = 161.68;

NECK_TRUTH_ASSEMBLY_DataFile;

for value = mass_percentages

    [mass, moi] = change_head_mass(smiData, 'multiplicative', value);
    
    %smiData.Solid(5).Mass = mass;
    %smiData.Solid(5).MoI = moi;
    
    out = sim('NECK_TRUTH_ASSEMBLY');
    
    subplot(2, 1, 1)
    plot(out.tau.Time, out.tau.Data(:,1) / 161.68, 'LineWidth', 1.1);
    ylabel('Torque on motor 0 [Nm]');
    hold on 
    grid on
    subplot(2, 1, 2)
    plot(out.tau.Time, out.tau.Data(:, 2) / 161.68, 'LineWidth', 1.1);
    ylabel('Torque on motor 0 [Nm]');
    xlabel('Time [sec]');
    hold on 
    grid on
end
sgtitle('Torque with head mass multiplicative factors'); 

subplot(2, 1, 1)
yline(0.08, 'r--');
yline(-0.08, 'r--');
yline(0.016, 'k--');
yline(-0.016, 'k--');
ylim([-0.1 0.1]);
subplot(2, 1, 2)
yline(0.08, 'r--');
yline(-0.08, 'r--');
yline(0.016, 'k--');
yline(-0.016, 'k--');
ylim([-0.1 0.1]);

legend({'1', '2','4', '6', '8', '10'}, 'Location' , 'southeast');
