function [subarrs, len, idx] = equal_length_subarrays(arr, divisions)
%EQUAL_LENGTH_SUBARRAYS Divide array into equal-length subarrays.
%Discards elements at the end of arr which can't be distributed evenly.
%   
%   [subarrs, len, idx] = equal_length_subarrays(arr, divisions)
%
%   Inputs:
%     arr:        1xN array to split into subarrays
%     divisions:  number of subarrays to produce
%   Outputs:
%     subarrs:    DxL matrix, where D=divisions and L=len, and the
%                 elements are taken columnwise from arr.
%
%     len:        length of each subarray
%
%     idx:        1xD+1 Array of indices mapping to the first elements in
%                 each subarray of arr. For example,
%                   arr(idx(1)) is the first element in subarr(1),
%                   arr(idx(divisions)) is the first element in the last
%                     subarr,
%                   arr(idx(divisions+1)) is the first element in the
%                     unused portion at the end of arr 
%
    len = floor((length(arr)-1)/divisions);
    idx=1:len:length(arr);
    subarrs=zeros(divisions, len);
    for row=1:divisions
        subarrs(row,:) = arr(idx(row):idx(row+1)-1);
    end
end

