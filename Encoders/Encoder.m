classdef Encoder
    properties
        resolution  % Counts per revolution
    end

    methods
        function obj = Encoder(resolution)
            obj.resolution = resolution;
        end

        function counts = sample(obj, deg)
            counts = floor(deg/360*obj.resolution);
        end

        function degrees = cnt_to_deg(obj, counts)
            degrees = counts/obj.resolution*360;
        end
    end

end