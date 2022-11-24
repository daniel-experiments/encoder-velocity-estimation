classdef VelocityTrapezoidGenerator < AbstractTrajectoryGenerator

    properties
        name = "VelocityTrapezoid"
    end

    methods
        function [p, v, a] = generate(~, t, p0, v0, v_step)
            p = zeros(size(t));
            v = zeros(size(t));
            a = zeros(size(t));
            
            
            %Divide time vector into equal thirds
            [~, len, idx] = equal_length_subarrays(t, 3);
            first_third = [idx(1):idx(2)-1];
            last_third  = [idx(3):idx(4)-1];

            % First interval: Positive accel
            % Second interval: 0 accel, constant v
            % Third interval: Negative accel
            const_a = (v_step)/(t(first_third(end)) - t(1));
            a(first_third) = repmat(const_a, 1, len);
            a(last_third) = repmat(-const_a, 1, len);
        
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
