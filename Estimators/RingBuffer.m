classdef RingBuffer < handle
    
    properties
        buf
        idx     % points to oldest element
        len
    end
    
    methods
        function obj = RingBuffer(len)
            obj.buf = zeros(1, len);
            obj.idx = 1;
            obj.len = len;
        end

       
        function oldest = push_pop(obj, new_elem)
            %oldest = push_pop(obj, new_elem) Push new element into the
            % buffer, popping the oldest element to make room.
            if obj.len == 0
                oldest = [];
            else
                oldest = obj.buf(obj.idx);
                obj.buf(obj.idx) = new_elem;
                obj.idx = RingBuffer.inc_and_wrap(obj.idx, 1, obj.len);
            end
        end

        function newest = peek_newest(obj)
            %peek_newest() Returns most recent element pushed to the buffer
            if obj.len == 0
                newest = [];
            else
                newest = obj.buf(RingBuffer.dec_and_wrap(obj.idx, 1, obj.len));
            end
        end

        function oldest = peek_oldest(obj)
            %peek_oldest() Returns oldest element pushed to the buffer
            if obj.len == 0
                oldest = [];
            else
                oldest = obj.buf(obj.idx);
            end
        end

        function len = length(obj)
            %length() Returns length of the buffer
            len = obj.len;
        end

        function ordered_buf = oldest_to_newest(obj)
            %oldest_to_newest() Returns the entire buffer, in order from
            %oldest to newest
            if obj.len == 0
                ordered_buf = [];
            else
                idx = obj.idx; % points to oldest element
                ordered_buf = zeros(1, obj.len);
                for ordered_idx = 1:obj.len
                    ordered_buf(ordered_idx) = obj.buf(idx);
                    idx = RingBuffer.inc_and_wrap(idx, 1, obj.len);
                end
            end
        end

        function ordered_buf = newest_to_oldest(obj)
            %newest_to_oldest() Returns the entire buffer, in order from
            %newest to oldest
            if obj.len == 0
                ordered_buf = [];
            else
                idx = obj.idx; % points to oldest element
                ordered_buf = zeros(1, obj.len);
                for ordered_idx = obj.len():-1:1
                    ordered_buf(ordered_idx) = obj.buf(idx);
                    idx = RingBuffer.inc_and_wrap(idx, 1, obj.len);
                end
            end
        end
    end

    methods(Static)

        function new_n = inc_and_wrap(n, min, max)
            new_n = n+1;
            if new_n > max
                new_n = min;
            end
        end

        function new_n = dec_and_wrap(n, min, max)
            new_n = n-1;
            if new_n < min
                new_n = max;
            end
        end

    end
end

