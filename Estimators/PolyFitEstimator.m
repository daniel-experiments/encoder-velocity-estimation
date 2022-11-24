classdef PolyFitEstimator < AbstractEstimator
    %CONSTANTTIMEESTIMATOR
    %   Estimates v=dx/dt, where dt is the duration since the last change
    %   in x.
    
    properties
        name = "PolyFit"
        timestep
        timeout

        ti
        t_buf
        x_buf
        p1
        p2
        p3
    end
    
    methods
        % VariableTimeEstimator Constructor
        % Inputs:
        %   timestep: Time (seconds) between calls to estimate().
        %   timeout:  Time (seconds) to wait for a new position measurement
        %               before declaring v=0.
        function obj = PolyFitEstimator(timestep, timeout)
            obj.timestep = timestep;
            obj.timeout = timeout;
            obj.reset();
        end
        
        function [p_est, v_est, a_est] = estimate(obj, p_meas)
            obj.ti = obj.ti + obj.timestep;

            % If position has changed or timeout has elapsed,
            % update the fitting curve.
            if (p_meas ~= obj.x_buf.peek_newest()) || ...
               (obj.ti - obj.t_buf.peek_newest() > obj.timeout)
                obj.x_buf.push_pop(p_meas);
                obj.t_buf.push_pop(obj.ti);
                x = obj.x_buf.oldest_to_newest(); % x(1) refers to oldest sample x
                t = obj.t_buf.oldest_to_newest(); % t(1) refers to oldest sample t
                t12 = t(1)-t(2);
                t13 = t(1)-t(3);
                t23 = t(2)-t(3);
                obj.p1 = x(1)/(t12*t13);
                obj.p2 = x(2)/(t12*t23);
                obj.p3 = x(3)/(t13*t23);
            end

            % Calculate estimates based on the fitting curve
            t = obj.t_buf.oldest_to_newest(); % t(1) refers to oldest sample t
            t1i = t(1)-obj.ti;
            t2i = t(2)-obj.ti;
            t3i = t(3)-obj.ti;
            p_est = obj.p1*t2i*t3i - obj.p2*t1i*t3i + obj.p3*t1i*t2i;
            v_est = -obj.p1*(t2i+t3i) + obj.p2*(t1i+t3i) - obj.p3*(t1i+t2i);
            a_est = obj.p1*2 - obj.p2*2 + obj.p3*2;
        end

        function reset(obj)
            obj.ti = 0;
            obj.x_buf = RingBuffer(3);
            obj.t_buf = RingBuffer(3);
            obj.t_buf.push_pop(0);
            obj.t_buf.push_pop((obj.timestep)/2);
            obj.p1 = 0;
            obj.p2 = 0;
            obj.p3 = 0;
        end

    end
    
end

