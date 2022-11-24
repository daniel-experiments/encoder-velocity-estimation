classdef (Abstract) AbstractEstimator < matlab.mixin.Heterogeneous & handle
    
    properties (Abstract)
        name
        timestep
    end

    methods (Abstract)
        [p_est, v_est, a_est] = estimate(obj, p_meas)
        reset(obj)
    end

end

