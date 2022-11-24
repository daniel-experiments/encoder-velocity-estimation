function subtable = filter_table(big_table, var, vals)
%     var = convertStringsToChars(var);
%     vals = convertStringsToChars(vals);
    row_matches = find_matches(big_table.(var), vals);
    subtable = big_table(row_matches, :);
end

function row_matches = find_matches(col, compvals)
    row_matches = false(length(col), 1);
    for row = 1:length(col)
        rowval = col(row);
        if iscell(rowval)       % Unpack rowval
            rowval = rowval{1};
        end
        if isnumeric(rowval)
            for val_i = 1:numel(compvals)
                compval = compvals(val_i);  % unpack compval
                if iscell(compval)
                    compval = compval{1};
                end
                if abs(rowval - compval)<1.0e-5
                    row_matches(row,1) = true;
                end
                %fprintf('equality: %d, row: %d, rowval: %.1f, compval: %.1f\n',row_matches(row),row,rowval,compval);
            end
        elseif ischar(rowval) || isstring(rowval)
            if ~iscell(compvals)
                compvals = {compvals};  % pack compval
            end
            for val_i = 1:numel(compvals)
                compval = compvals{val_i};   % unpack compval
                if contains(rowval, compval)
                    row_matches(row,1) = true;
                end
                %fprintf('equality: %d, row: %d, rowval: %s, compval: %s\n',row_matches(row),row,rowval,compval);
            end
        end
    end
    
end