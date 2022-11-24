classdef ConstantTimeEstimator < AbstractEstimator
    %CONSTANTTIMEESTIMATOR
    %   Estimates v=dx/dt, where dx=x(t)-x(t-dt) and dt is a fixed constant

    properties
        name
        timestep
        buffer_length
        
        dt
        p_buf
        v_buf
    end
    
    methods
        %ConstantTimeEstimator Constructor
        %Inputs:
        %  timestep:  Time (seconds) between calls to estimate().
        %  dt:        Time (seconds) to look backward in the history of
        %               position estimates ( x(t-dt) ).
        function obj = ConstantTimeEstimator(timestep, dt)
            obj.name = sprintf('ConstT(%dms)', dt*1000);
            obj.timestep = timestep;
            obj.buffer_length = ceil(dt/timestep);
            obj.dt = dt;
            
            obj.reset()
        end
        
        function [p_est, v_est, a_est] = estimate(obj, p_meas)
            % Push_pop pushes the most recent value and returns the oldest.
            p_est = p_meas;
            dx = p_est - obj.p_buf.push_pop(p_est);
            v_est = dx/obj.dt;
            dv = v_est - obj.v_buf.push_pop(v_est);
            a_est = dv/obj.dt;
        end

        function reset(obj)
            obj.p_buf = RingBuffer(obj.buffer_length);
            obj.v_buf = RingBuffer(obj.buffer_length);
            obj.dt = obj.buffer_length * obj.timestep;
        end
    end
end

