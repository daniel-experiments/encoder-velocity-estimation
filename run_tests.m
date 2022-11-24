addpath("Encoders/", "Estimators/", "TrajectoryGenerators/", "TransferFunctions/", "Results/");


%% Constants; same for every test case:
timestep = 0.001;          % Rate Estimators will sample the input signal
t_max = 1.0;               % Run each test for 3 simulated seconds.
t = 0:timestep:t_max;      % Simulation time vector  

cut_time = 0.2;            % Remove first and last cut_time seconds of data
                           % before calculating err_max and err_rms

batch_size = 10000;        % Split large tests into batches of this size
results_directory = "Results";
results_prefix = "PITrackerResults_";


%% Test variables; create a testcase for each unique combination of these:
clear vars;
vars.estimator = [ VariableTimeEstimator(timestep, 0.2),            ...
                   ConstantTimeEstimator(timestep, 10*timestep), ...
                   PolyFitEstimator(timestep, 0.2), ...                   
                   FirstOrderLowPassFilter(timestep, 0.1), ...
                   PITracker(timestep, 64.2824, 5943.8577), ... % SettingTime=0.1s, OS=34.8%
                   PITracker(timestep, 100.6173, 2808.3664), ... % SettingTime=0.1s, OS=14.5%
                   PITracker(timestep, 33.5744, 19.7318)  ... % SettingTime=0.1s, OS=1.56%
                 ];
vars.traj_gen =  [ VelocityStepGenerator()         ...
                   ...VelocityRampGenerator(),        ...
                   ...VelocityTrapezoidGenerator(),    ...
                 ];
vars.rpm = [1:1:500];

vars.encoder_resolution = 360;    % Counts per revolution
%vars.kp = logspace(1,3,50);
%vars.ki = logspace(1,5,100);


%% Generate tests
fprintf('Generating tests...\n');
test_defs = generate_tests(vars);
global num_tests num_complete
num_tests = length(test_defs);
num_complete = 0;
counter = parallel.pool.DataQueue;         % for tracking progress
afterEach(counter, @increment_progress);
batch_start_idx=[1:batch_size:num_tests];  % divide tests evenly into batches
num_batches = length(batch_start_idx);


%% Run simulation for every test and calculate results
num_complete = 0;
fprintf('Running %d tests in %d batches...\n', num_tests, num_batches);
for batch = 1:num_batches
    first_test = batch_start_idx(batch);
    last_test = num_tests;
    if batch ~= num_batches
        last_test = batch_start_idx(batch+1)-1;
    end   
    
    clear tests results;
    tests = test_defs(first_test:last_test); % Array of tests in this batch
    
    % Run tests in parallel within the batch
    parfor k = 1:length(tests)
        % Generate estimator for this testcase
        %tests(k).estimator = PITracker(timestep, tests(k).kp, tests(k).ki);
    
        % Generate trajectory for this testcase
        tests(k).traj_type = tests(k).traj_gen.name;
        tests(k).v_max = tests(k).rpm/60*360;
        tests(k).t = t;
        [                       ...
            tests(k).p_actual,  ...
            tests(k).v_actual,  ...
            tests(k).a_actual   ...
        ] = ...
        tests(k).traj_gen.generate( ...
            tests(k).t, ...
            0, ...
            0, ...
            tests(k).v_max ...
        );
        
        % Other attributes
        tests(k).estimator_name = tests(k).estimator.name;
        tests(k).encoder = Encoder(tests(k).encoder_resolution);
    
        % Given the system parameters and some actual trajectory p_actual,
        % estimate p, v, a.
        [                       ...
            tests(k).p_est,     ...
            tests(k).v_est,     ...
            tests(k).a_est      ...
        ] =                     ...
        simulate(               ...
            tests(k).encoder,   ...
            tests(k).estimator, ...
            tests(k).p_actual   ...
        );
        
        % Filtered estimates
        %wpass = pi()/(deg2rad(tests(r).v_max)*(1/timestep)/2);
        %tests(r).p_lpf = lowpass(tests(r).p_est, wpass);
        %tests(r).v_lpf = lowpass(tests(r).v_est, wpass);
        %tests(r).a_lpf = lowpass(tests(r).a_est, wpass);
    
        % Error over time
        tests(k).p_err = tests(k).p_actual - tests(k).p_est;
        tests(k).v_err = tests(k).v_actual - tests(k).v_est;
        tests(k).a_err = tests(k).a_actual - tests(k).a_est;
    
        % FFT of error
        fs = (1/timestep);    % FFT Sampling frequency (Hz)
        p_fft = abs(fft(tests(k).p_err, fs)); % Amplitudes  
        v_fft = abs(fft(tests(k).v_err, fs));
        a_fft = abs(fft(tests(k).a_err, fs));
        freq = (0:length(p_fft)-1)*fs/length(p_fft);    % Frequencies
        tests(k).p_fft = p_fft(1:ceil(length(p_fft)/2));  % Take only first half
        tests(k).v_fft = v_fft(1:ceil(length(v_fft)/2));
        tests(k).a_fft = a_fft(1:ceil(length(a_fft)/2));
        tests(k).freq  = freq(1:ceil(length(p_fft)/2));

        % Peak frequency and amplitude of error
        [tests(k).p_fft_max_amp, freq_idx] = max(tests(k).p_fft);
        tests(k).p_fft_max_freq = tests(k).freq(freq_idx);
        [tests(k).v_fft_max_amp, freq_idx] = max(tests(k).v_fft);
        %fprintf('%d: %.1f Hz, %d\n',k, tests(k).v_fft_max_amp, freq_idx);
        tests(k).v_fft_max_freq = tests(k).freq(freq_idx);
        [tests(k).a_fft_max_amp, freq_idx] = max(tests(k).a_fft);
        tests(k).a_fft_max_freq = tests(k).freq(freq_idx);
    
        % Percent error over time
        tests(k).p_err_pct = tests(k).p_err./tests(k).p_actual.*100;
        tests(k).v_err_pct = tests(k).v_err./tests(k).v_actual.*100;
        tests(k).a_err_pct = tests(k).a_err./tests(k).a_actual.*100;
        
        % Trim vectors
        cut_idx = floor(cut_time/timestep)+1;
        tests(k).p_err(1:cut_idx) = NaN;
        tests(k).v_err(1:cut_idx) = NaN;
        tests(k).a_err(1:cut_idx) = NaN;
        tests(k).p_err_pct(1:cut_idx) = NaN;
        tests(k).v_err_pct(1:cut_idx) = NaN;
        tests(k).a_err_pct(1:cut_idx) = NaN;
    
        % Max, mean, (rms) error during test
        tests(k).p_err_max = max(abs(tests(k).p_err));
        tests(k).p_err_max_pct = max(abs(tests(k).p_err_pct));
        tests(k).p_err_mean = mean(tests(k).p_err, 'omitnan');
        tests(k).p_err_mean_pct = mean(tests(k).p_err_pct, 'omitnan');
        tests(k).p_err_rms = rms(tests(k).p_err, 'omitnan');
        tests(k).p_err_rms_pct = rms(tests(k).p_err_pct, 'omitnan');
    
        tests(k).v_err_max = max(abs(tests(k).v_err));
        tests(k).v_err_max_pct = max(abs(tests(k).v_err_pct));
        tests(k).v_err_mean = mean(tests(k).v_err, 'omitnan');
        tests(k).v_err_mean_pct = mean(tests(k).v_err_pct, 'omitnan');
        tests(k).v_err_rms = rms(tests(k).v_err, 'omitnan');
        tests(k).v_err_rms_pct = rms(tests(k).v_err_pct, 'omitnan');
    
        tests(k).a_err_max = max(abs(tests(k).a_err));
        tests(k).a_err_max_pct = max(abs(tests(k).a_err_pct));
        tests(k).a_err_mean = mean(tests(k).a_err, 'omitnan');
        tests(k).a_err_mean_pct = mean(tests(k).a_err_pct, 'omitnan');
        tests(k).a_err_rms = rms(tests(k).a_err, 'omitnan');
        tests(k).a_err_rms_pct = rms(tests(k).a_err_pct, 'omitnan');
    
        send(counter, k);
    end    

    %% Create results table
    fprintf('Collating results...\n');
    results = struct2table(tests);
    results = removevars(results, { ...
        't',                                ... % sim time vector
        'estimator', 'encoder', 'traj_gen'  ... % objects
        'p_actual', 'v_actual', 'a_actual', ... % trajectory vectors
        'p_est', 'v_est', 'a_est', ...          % estimate vectors
        'p_err', 'v_err', 'a_err', ...          % error vectors
        'freq', 'p_fft', 'v_fft', 'a_fft', ...  % fft vectors
        'p_err_pct', 'v_err_pct', 'a_err_pct'   % percent error vectors
    });
    results = sortrows(results, 'estimator_name');
    
    
    %% Write results file
    results_filename = sprintf('%s/%s%d.tsv', results_directory, results_prefix, batch);
    fprintf('Writing output file: %s\n', results_filename);
    try
        writetable(results, results_filename, 'WriteVariableNames', true, ...
            'Delimiter', '\t', 'FileType', 'text');
    catch exception
        fprintf('Error writing to file: %s\n', results_filename);
    end

end % Advance to next batch of tests


function increment_progress(~)
    global num_complete num_tests;
    num_complete = num_complete + 1;
    fprintf('Completed test: %d/%d\n', num_complete, num_tests);
end
