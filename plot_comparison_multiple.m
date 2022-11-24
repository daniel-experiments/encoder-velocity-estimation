function plot_comparison_multiple(results, x_var, y_var, compare_var, subplot_var, varargin)
    
    interpreter = 'none';
    % interpreter = 'latex'

    direction = 'col';

    x_desc = get_desc(results, x_var);
    x_unit = get_unit(results, x_var);
    x_label_str = [x_desc, x_unit];
    y_desc = get_desc(results, y_var);
    y_unit = get_unit(results, y_var);
    y_label_str = [y_desc, y_unit];  
    compare_desc = get_desc(results, compare_var);
    compare_unit = get_unit(results, compare_var);
    subplot_desc = get_desc(results, subplot_var);
    subplot_unit = get_unit(results, subplot_var);
    

    if length(varargin) >= 1
        direction = varargin(1);
    end
    if length(varargin) >= 2
        x_label_str = varargin(2);
    end
    if length(varargin) >= 3
        y_label_str = varargin(3);
    end

    % Plot all subplot_vals in different subplots
    results = sortrows(results, subplot_var);
    subplot_vals = unique(results.(subplot_var));
    num_subplots = length(subplot_vals);
    for s = 1:num_subplots
        % Make subplot, showing only results for subplot_var = subplot_val
%         if strcmp(direction, 'col')
%             ax=subplot(num_subplots, 1, s);
%         else
%             ax=subplot(1, num_subplots, s);
%         end
        nexttile;
        subplot_val = subplot_vals(s);
        subtable = filter_table(results, subplot_var, subplot_val);
        
        % Within subplot, plot x_var and y_var for each value of compare_var
        title_str = sprintf('Comparison of %s with %s=%s%s: %s vs %s', ...
                         compare_desc, ...
                         subplot_desc, subplot_val, subplot_unit,  ...
                         x_desc, y_desc );
        if strcmp(interpreter, 'latex')
            title_str = to_latex(title_str);
            x_label_str = to_latex(x_label_str);
            y_label_str = to_latex(y_label_str);
        end

        plot_comparison(subtable, x_var, y_var, compare_var, ...
            title_str, x_label_str, y_label_str);
    end
    
end
