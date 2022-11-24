function [p_est, v_est, a_est] = simulate(enc, est, p_actual)
    % simulate
    %   Simulates the system defined by:
    %               _____          ___              _____
    %   p_actual-->| enc |--cnt-->| k |-->p_meas-->| est |-->p,v,a_est
    %              |_____|        |___|            |_____|
    % 
    %   p_actual:   Actual position (degrees) over time
    %   enc:        Encoder measuring p_actual
    %   cnt:        Encoder count
    %   k:          Gain = 360/enc.resolution
    %   p_meas:     Measured position (degrees)
    %   est:        Estimator
    %   p,v,a_est:  Estimate of position, velocity, and acceleration of the
    %                 original p_actual signal
    % 
    % Inputs:
    %   enc:  Encoder object
    %   est:  Estimator object
    %   p_actual: array of positions (degrees) at each timestep
    % OUTPUT:
    %   p_est - array of estimated positions (deg)
    %   v_est - array of estimated velocities (deg/s)
    %   a_est - array of estimated accelerations (deg/s/s)
    
    est.reset();

    k = 360/enc.resolution;
    
    p_est = zeros(size(p_actual));   % Estimates of P (deg)
    v_est = zeros(size(p_actual));   % Estimates of V (deg/s)
    a_est = zeros(size(p_actual));   % Estimates of A (deg/s/s)
    
    for i = 1:length(p_actual)
        cnt = enc.sample(p_actual(i));
        p_meas = cnt*k;
        [p_est(i), v_est(i), a_est(i)] = est.estimate(p_meas);
    end
    
end
