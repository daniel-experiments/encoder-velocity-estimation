%% Compare Performance
clf;
results = guess_descriptions(results);
results = guess_units(results);
tiledlayout(3,length(vars.traj_gen));
subplot_var = 'traj_type';      % Different for each subplot in the row
compare_var = 'estimator_name'; % In each subplot, plot multiple together
x_var = 'v_max';                % X axis variable
y_var = 'p_err_mean';            % Y axis variable
plot_comparison_multiple(results, x_var, y_var, compare_var, subplot_var);

y_var = 'v_err_mean';            % Y axis variable
plot_comparison_multiple(results, x_var, y_var, compare_var, subplot_var);

y_var = 'a_err_mean';            % Y axis variable
plot_comparison_multiple(results, x_var, y_var, compare_var, subplot_var);





%% Helper functions

function new_table = guess_descriptions(old_table)
    vars=old_table.Properties.VariableNames;
    descs=cell(size(vars));
    
    for i=1:length(vars)
        desc=vars{i};

        if endsWith(desc, '_name')
            desc = desc(1:end-length('_name'));
            desc(1) = upper(desc(1));
        end
        if endsWith(desc, '_pct')
            desc = desc(1:end-length('_pct'));
            desc = ['%', desc];
        end
        if endsWith(desc, '_max')
            desc = desc(1:end-length('_max'));
            desc = ['max(', desc, ')'];
        end
        if endsWith(desc, '_mean')
            desc = desc(1:end-length('_mean'));
            desc = ['mean(', desc, ')'];
        end
        if endsWith(desc, '_rms')
            desc = desc(1:end-length('_rms'));
            desc = ['RMS(', desc, ')'];
        end
        if endsWith(desc, '_fft')
            desc = desc(1:end-length('_fft'));
            desc = ['FFT(', desc, ')'];
        end
        [name, startidx, endidx]=regexp(desc, '\w+_err', 'once', 'match', 'start', 'end');
        if ~isempty(startidx)
            basename = name(1:end-length('_rms'));
            desc = [desc(1:startidx-1), 'err(', basename, ')', desc(endidx+1:end)];
        end

        descs{i} = desc;
    end
    
    new_table = old_table;
    new_table.Properties.VariableDescriptions=descs;
end

function new_table = guess_units(old_table)
    vars=old_table.Properties.VariableNames;
    units=cell(size(vars));
    
    for i=1:length(vars)
        var=vars{i};
        units{i} = '';

        if contains(var, 'p_') && ~contains(var, '_pct')
            units{i} = 'deg';
        elseif contains(var, 'x_') && ~contains(var, '_pct')
            units{i} = 'deg';
        elseif contains(var, 'v_') && ~contains(var, '_pct')
            units{i} = 'deg/s';
        elseif contains(var, 'x_d') && ~contains(var, '_pct')
            units{i} = 'deg/s';
        elseif contains(var, 'a_') && ~contains(var, '_pct')
            units{i} = 'deg/s/s';
        elseif contains(var, 'x_dd') && ~contains(var, '_pct')
            units{i} = 'deg/s/s';
        elseif strcmp(var, 't')
            units{i} = 's';
        end
    end
    
    new_table = old_table;
    new_table.Properties.VariableUnits=units;
end
