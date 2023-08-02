classdef visualization
    properties
        pixel_length
        resY
        new_dimX
    end

    methods
        function obj = calcola_pixel_length(obj, sound_speed,fs)
            obj.pixel_length = (sound_speed/(2*fs))*1000;
        end

        function obj = calcola_res_y(obj, dimY, scansione_meccanica)
            obj.resY = scansione_meccanica/dimY;
        end
    end
end

