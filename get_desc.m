function desc = get_desc(results, var)
    desc = results.Properties.VariableDescriptions{     ...
        contains(results.Properties.VariableNames, var) ...
    };
    if isempty(desc)
        desc = var;
    end
end

