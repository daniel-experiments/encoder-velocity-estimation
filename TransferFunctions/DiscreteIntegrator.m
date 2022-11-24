classdef DiscreteIntegrator < DiscreteTransferFunction
    %DISCRETEINTEGRATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        order
    end
    
    methods
        function obj = DiscreteIntegrator(timestep, order, varargin)
            %DiscreteIntegrator Construct an instance of this class
            %   Detailed explanation goes here
            numer = [zeros(1,length(order)), 1];
            denom = [1, zeros(1,length(order))];
            obj = obj@DiscreteTransferFunction(timestep, numer, denom, varargin{:});
            obj.order = order;
        end

    end
end

