classdef (Abstract) AbstractTrajectoryGenerator < matlab.mixin.Heterogeneous & handle
    
    properties (Abstract)
        name
    end

    methods (Abstract)
        [p, v, a] = generate(~, t, p0, v0, param)
    end

end


