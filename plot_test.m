function plot_test(test)
    clf;
    
    subplot(3,2,1);
    plot_p(test);

    subplot(3,2,2);
    plot_p_fft(test);
    
    subplot(3,2,3);
    plot_v(test);

    subplot(3,2,4);
    plot_v_fft(test);
      
    subplot(3,2,5);
    plot_a(test);

    subplot(3,2,6);
    plot_a_fft(test);
end

function plot_p(test)
    plot(test.t, test.p_err, '-r',       ...
         test.t, test.p_est, '-b',       ...
         test.t, test.p_actual, '-k',    ...
         'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Position Estimate: %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(p))=%.2f, mean(err(p)=%.2f, rms(err(p))=%.2f', ...
              test.p_err_max, test.p_err_mean, test.p_err_rms) );
    legend('Error', 'Estimate', 'Actual P');
    xlabel('Time (s)');
    ylabel('Position (deg)');
end

function plot_p_err(test)
    plot(test.t, test.p_err, '-r', ...
         [test.t(1),test.t(end)], [test.p_err_mean,test.p_err_mean], '-k',...
         'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Position Error (deg): %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(p))=%.2f, mean(err(p)=%.2f, rms(err(p))=%.2f', ...
              test.p_err_max, test.p_err_mean, test.p_err_rms) );
    xlabel('Time (s)');
    ylabel('Error (deg)');
end

function plot_p_fft(test)
    plot(test.freq, test.p_fft, '-b', 'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Position Error (deg): %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(p))=%.2f, mean(err(p)=%.2f, rms(err(p))=%.2f', ...
              test.p_err_max, test.p_err_mean, test.p_err_rms) );
    xlabel('Error Frequency (Hz)');
    ylabel('Magnitude');
end

function plot_v(test)
    plot(test.t, test.v_err, '-r',       ...
         test.t, test.v_est, '-b',       ...
         ...%test.t, test.v_lpf, '-g',  ...
         test.t, test.v_actual, '-k',    ...
         'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Velocity Estimate: %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(v))=%.2f, mean(err(v)=%.2f, rms(err(v))=%.2f', ...
              test.v_err_max, test.v_err_mean, test.v_err_rms) );
    legend('Error', 'Estimate', 'Actual V');
    xlabel('Time (s)');
    ylabel('Velocity (deg/s)');
end

function plot_v_err(test)
    plot(test.t, test.v_err, '-r',   ...
        [test.t(1),test.t(end)], [test.v_err_mean,test.v_err_mean], '-k',...
         'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Velocity Error (deg/s): %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(v))=%.2f, mean(err(v)=%.2f, rms(err(v))=%.2f', ...
              test.v_err_max, test.v_err_mean, test.v_err_rms) );
    xlabel('Time (s)');
    ylabel('Error (deg/s)');
end

function plot_v_fft(test)
    plot(test.freq, test.v_fft, '-b', 'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Velocity Error (deg/s): %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(v))=%.2f, mean(err(v)=%.2f, rms(err(v))=%.2f', ...
              test.v_err_max, test.v_err_mean, test.v_err_rms) );
    xlabel('Error Frequency (Hz)');
    ylabel('Magnitude');
end

function plot_a(test)
    plot(test.t, test.a_err, '-r',       ...
         test.t, test.a_est, '-b',       ...
         test.t, test.a_actual, '-k',    ...
         'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Acceleration Estimate: %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(a))=%.2f, mean(err(a)=%.2f, rms(err(a))=%.2f', ...
              test.a_err_max, test.a_err_mean, test.a_err_rms) );
    legend('Error', 'Estimate', 'Actual A');
    xlabel('Time (s)');
    ylabel('Acceleration (deg/s/s)');
end

function plot_a_err(test)
    plot(test.t, test.a_err, '-r',     ...
        [test.t(1),test.t(end)], [test.a_err_mean,test.a_err_mean], '-k',...
         'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Acceleration Error (deg/s/s): %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(a))=%.2f, mean(err(a)=%.2f, rms(err(a))=%.2f', ...
              test.a_err_max, test.a_err_mean, test.a_err_rms) );
    xlabel('Time (s)');
    ylabel('Error (deg/s/s)');
end

function plot_a_fft(test)
    plot(test.freq, test.a_fft, '-b', 'LineWidth', 1);
    axis padded;
    grid on;
    grid minor;
    title(    sprintf('%s Acceleration Error (deg/s/s): %s(%.1f deg/s)',  ...
              test.estimator_name, test.traj_type, test.v_max) );
    subtitle( sprintf('max(err(a))=%.2f, mean(err(a)=%.2f, rms(err(a))=%.2f', ...
              test.a_err_max, test.a_err_mean, test.a_err_rms) );
    xlabel('Error Frequency (Hz)');
    ylabel('Magnitude');
end
