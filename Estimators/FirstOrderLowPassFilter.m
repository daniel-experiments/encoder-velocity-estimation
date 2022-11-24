classdef FirstOrderLowPassFilter < AbstractEstimator
    %CONSTANTTIMEESTIMATOR
    %   Estimates v=dx/dt, where dx=x(t)-x(t-dt) and dt is a fixed constant

    properties
        name
        timestep
        
        tau
        alpha
        dt
        
        p_est
        v_est
    end
    
    methods
        %ConstantTimeEstimator Constructor
        %Inputs:
        %  timestep:  Time (seconds) between calls to estimate().
        %  timeconst: Tau, where 1/tau = cutoff frequency
        function obj = FirstOrderLowPassFilter(timestep, timeconstant)
            obj.name = sprintf('FirstOrderLPF(tau=%.1fms)', timeconstant*1000);
            obj.timestep = timestep;
            obj.tau = timeconstant;
            obj.alpha = 1-exp(-obj.timestep/obj.tau);
            obj.dt = obj.timestep;
            obj.reset()
        end
        
        function [p_est, v_est, a_est] = estimate(obj, p_meas)
            dx = (p_meas - obj.p_est)*obj.alpha;
            p_est = obj.p_est+dx;
            v_est = dx/obj.dt;
            dv = (v_est - obj.v_est);
            a_est = dv/obj.dt;

            obj.p_est = p_est;
            obj.v_est = v_est;
        end

        function reset(obj)
            obj.p_est = 0;
            obj.v_est = 0;
        end
    end
end

