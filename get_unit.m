function unit = get_unit(results, var)
    unit = results.Properties.VariableUnits{     ...
        contains(results.Properties.VariableNames, var) ...
    };
    if ~isempty(unit)
        unit = [' (', unit, ')'];
    end
end

