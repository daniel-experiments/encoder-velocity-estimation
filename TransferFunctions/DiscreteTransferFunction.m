classdef DiscreteTransferFunction < matlab.mixin.Heterogeneous & handle
    
    properties
        timestep
        ctf       % Continuous-time transfer function object (tf(....) )
        dtf       % Discrete-time transfer function object (c2d(....) )
        u_coeffs  % Numerator coefficients of dtf
        y_coeffs  % Denominator coefficients of dtf
        u_buf
        y_buf
    end

    methods
        function obj = DiscreteTransferFunction(timestep, numer, denom, varargin)
            %DISCRETETRANFERFUNCTION Construct an instance of this class
            %   Detailed explanation goes here
            obj.timestep = timestep;
            obj.ctf = tf(numer,denom);
            dtf = c2d(obj.ctf, timestep, 'tustin');
            dtf.variable='z^-1';
            obj.dtf = dtf;
            obj.u_coeffs = dtf.numerator{:};
            obj.y_coeffs = dtf.denominator{:}(2:end).*-1;
            obj.reset(varargin{:});
        end
        
        function y_i = step(obj, u_i)
            obj.u_buf.push_pop(u_i);

            y_i = dot(...
                obj.u_coeffs,                   ...
                obj.u_buf.newest_to_oldest()     ...
            )  +  dot(                          ...
                obj.y_coeffs,                   ...
                obj.y_buf.newest_to_oldest()     ...
            );
            
            obj.y_buf.push_pop(y_i);
        end

        function reset(obj, varargin)
            obj.u_buf = RingBuffer(length(obj.u_coeffs));
            obj.y_buf = RingBuffer(length(obj.y_coeffs));

            if length(varargin) >= 1        
                u_inits = varargin{1};
                for i = 1:(length(obj.u_coeffs)-1)
                    obj.u_buf.push_pop(u_inits(i));
                end
            end
            if length(varargin) == 2      
                y_inits = varargin{2};
                for i = 1:length(obj.y_coeffs)
                    obj.y_buf.push_pop(y_inits(i));
                end
            end

        end
    end

end

