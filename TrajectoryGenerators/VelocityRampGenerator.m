classdef VelocityRampGenerator < AbstractTrajectoryGenerator

    properties
        name = "VelocityRamp"
    end

    methods
        function [p, v, a] = generate(~, t, p0, v0, v_step)
            p = zeros(size(t));
            v = zeros(size(t));
            a = zeros(size(t));
            
            % Constant acceleration for the whole interval
            const_a = (v_step)/(t(end) - t(1));
            a(1:end-1) = repmat(const_a, 1, length(t)-1);
        
            % Integrate twice to get V and P
            p(1) = p0;
            v(1) = v0;
            dt = t(2)-t(1);
            for i=2:length(t)
                v(i) = round( v(i-1)+a(i-1)*dt, 5);
                p(i) = round( p(i-1)+v(i-1)*dt, 5);
            end
        end

    end

end
