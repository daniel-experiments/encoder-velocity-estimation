classdef VelocityStepGenerator < AbstractTrajectoryGenerator

    properties
        name = "VelocityStep"
    end

    methods
        function [p, v, a] = generate(~, t, p0, v0, v_step)
            p = zeros(size(t));
            v = zeros(size(t));
            a = zeros(size(t));
            
            
            % Accelerate to v0 + v_step immediately
            v0 = v0+v_step;
        
       
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
