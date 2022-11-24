classdef DiscretePIController < DiscreteTransferFunction
    %DISCRETEINTEGRATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        kp
        ki
    end
    
    methods
        function obj = DiscretePIController(timestep, kp, ki, varargin)
            %DISCRETETRANFERFUNCTION Construct an instance of this class
            %   Detailed explanation goes here
            numer = [kp, ki];
            denom = [1, 0];
            obj = obj@DiscreteTransferFunction(timestep, numer, denom, varargin{:});
            obj.kp = kp;
            obj.ki = ki;
        end

    end
end

