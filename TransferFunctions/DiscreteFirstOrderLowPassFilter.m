classdef DiscreteFirstOrderLowPassFilter < DiscreteTransferFunction
    %DiscreteFirstOrderLowPassFilter Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        freq
        tau
        alpha
    end
    
    methods
        function obj = DiscreteFirstOrderLowPassFilter(timestep, timeconstant, varargin)
            %DiscreteFirstOrderLowPassFilter Construct an instance of this class
            %   Detailed explanation goes here
            a = 1-exp(-timestep/timeconstant);
            numer = [0,1];
            denom = [a,1];
            obj = obj@DiscreteTransferFunction(timestep, numer, denom, varargin{:});
            
            obj.freq = 1/timeconstant;
            obj.tau = timeconstant;
            obj.alpha = a;
        end

    end
end

