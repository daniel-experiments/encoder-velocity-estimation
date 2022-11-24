classdef PITracker < AbstractEstimator
    %PITracker
    %   Estimates V and P using a PI controller.
    %   P is the reference, V is the "controlled" quantity, V and P are
    %   outputs.
    %   Via MATLAB pidTuner:
    %   Settling(s): OS%:   Phase Margin/Bandwidth:  Kp:         Ki:
    %   0.1000       34.8%  45 deg @ 5208.8 deg/s      64.2824       5943.8577    
    %   0.0100                                        642.8243     584385.7696   UNSTABLE
    %   0.0010                                       6428.2435   58438576.9576   UNSTABLE
    %   0.1000       14.5%  75 deg @ 5958.8 deg/s     100.6173       2808.3664   
    %   0.1000       1.56%  85 deg @ 1925.1 deg/s      33.5744         19.7318
    %

    properties
        name
        timestep
        
        kp
        ki
        pi_controller
        integrator
        p_old
        v_old
    end
    
    methods
        %ConstantTimeEstimator Constructor
        %Inputs:
        %  timestep:  Time (seconds) between calls to estimate().
        %  timeconst: Tau, where 1/tau = cutoff frequency
        function obj = PITracker(timestep, kp, ki)
            obj.name = sprintf('PITrackingLoop(kp=%.0f,ki=%.0f)', kp, ki);
            obj.timestep = timestep;
            obj.kp = kp;
            obj.ki = ki;
            obj.reset();
        end
        
        function [p_est, v_est, a_est] = estimate(obj, p_meas)
            err = p_meas - obj.p_old;
            v_est = obj.pi_controller.step(err);
            p_est = obj.integrator.step(v_est);
            a_est = (v_est - obj.v_old)/obj.timestep;

            obj.p_old = p_est;
            obj.v_old = v_est;
        end

        function reset(obj)
            obj.pi_controller = DiscretePIController(obj.timestep, obj.kp, obj.ki);
            obj.integrator = DiscreteIntegrator(obj.timestep,1);
            obj.p_old = 0;
            obj.v_old = 0;
        end
    end
end

