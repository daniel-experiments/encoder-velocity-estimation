classdef VariableTimeEstimator < AbstractEstimator
    %CONSTANTTIMEESTIMATOR
    %   Estimates v=dx/dt, where dt is the duration since the last change
    %   in x.
    
    properties
        name = "VariableTime"
        timestep
        timeout

        dt
        old_p
        old_v
        old_a
    end
    
    methods
        % VariableTimeEstimator Constructor
        % Inputs:
        %   timestep: Time (seconds) between calls to estimate().
        %   timeout:  Time (seconds) to wait for a new position measurement
        %               before declaring v=0.
        function obj = VariableTimeEstimator(timestep, timeout)
            obj.timestep = timestep;
            obj.timeout = timeout;
            obj.reset();
        end
        
        function [p_est, v_est, a_est] = estimate(obj, p_meas)
            obj.dt = obj.dt+obj.timestep;
            p_est = p_meas;

            % Wait for position to change before calculating v=dx/dt.
            % Assume v=0 if position hasn't changed in a long time.
            if (p_est ~= obj.old_p) || (obj.dt >= obj.timeout)
                dx = p_est - obj.old_p; % dx=deg(1 count) for very slow inputs
                v_est = dx/obj.dt;
                dv = v_est - obj.old_v;
                a_est = dv/obj.dt;
        
                obj.dt = 0;
                obj.old_p = p_est;
                obj.old_v = v_est;
                obj.old_a = a_est;
            
            % p_meas hasn't changed during this timestep. Assume v and a
            % haven't changed.
            else
                v_est = obj.old_v;
                a_est = obj.old_a;
            end
        end

        function reset(obj)
            obj.dt = 0;
            obj.old_p = 0;
            obj.old_v = 0;
            obj.old_a = 0;
        end

    end
    
end

