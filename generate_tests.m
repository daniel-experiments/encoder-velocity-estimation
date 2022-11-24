function tests = generate_tests(vars)
% generate_tests
% Inputs:
%   vars:   struct, organized as:
%       .varname1=[...]
%       .varname2=[...]
% Outputs:
%   tests:  array of structs which represents the cartesian product of all
%             values in "vars".
% Ex:
%   vars.str=['a', 'b'];
%   vars.num=[1, 2, 3];
%   tests = generate_tests(vars);
% Yeilds: 6x1 struct array
%   tests(1).testcase: 1, tests(1).str: 'a',  tests(1).num: 1
%   tests(1).testcase: 2, tests(2).str: 'b',  tests(2).num: 1
%   tests(1).testcase: 3, tests(3).str: 'a',  tests(3).num: 2
%   tests(1).testcase: 4, tests(4).str: 'b',  tests(4).num: 2
%   tests(1).testcase: 5, tests(5).str: 'a',  tests(5).num: 3
%   tests(1).testcase: 6, tests(6).str: 'b',  tests(6).num: 3

    elements = struct2cell(vars)';
    combinations = cell(1, numel(elements));
    [combinations{:}] = ndgrid(elements{:});
    combinations = cellfun(@(x) x(:), combinations,'uniformoutput',false);
    nums={[1:size(combinations{1},1)]'};
    combinations=[nums,combinations];
    C=[];
    for e=1:numel(combinations)
        E=combinations(e);
        C=[C, mat2cell(E{:}, ones(size(E{1})))];
    end
    tests = cell2struct(C, [{'testcase'}; fieldnames(vars)], 2);
end