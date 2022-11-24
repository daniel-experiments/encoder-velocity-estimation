function plot_comparison(results, x_var, y_var, compare_var, varargin)
    
    interpreter = 'none';
    % interpreter = 'latex'
    
    x_desc = get_desc(results, x_var);
    x_unit = get_unit(results, x_var);
    x_label_str = [x_desc, x_unit];
    y_desc = get_desc(results, y_var);
    y_unit = get_unit(results, y_var);
    y_label_str = [y_desc, y_unit];  
    compare_desc = get_desc(results, compare_var);
    compare_unit = get_unit(results, compare_var);
    compare_str = [compare_desc, compare_unit];  
    
    title_str = sprintf('Comparison of %s: %s vs %s', ...
                         compare_desc, x_desc, y_desc );  
   
    if strcmp(interpreter, 'latex')
        title_str = to_latex(title_str);
        x_label_str = to_latex(x_label_str);
        y_label_str = to_latex(y_label_str);
    end
    
    if length(varargin) >= 1
        title_str = varargin(1);
    end
    if length(varargin) >= 2
        x_label_str = varargin(2);
    end
    if length(varargin) >= 3
        y_label_str = varargin(3);
    end

    % Plot all compare_vals on the same plot
    hold on
    results = sortrows(results, compare_var);
    compare_vals = unique(results.(compare_var));
    num_comparisons = length(compare_vals);
    for idx = 1:num_comparisons
        % Plot x_var and y_var for a specific compare_val
        compare_val = compare_vals(idx);
        subtable = filter_table(results, compare_var, compare_val);
        subtable = sortrows(subtable, x_var);
        x_vals = subtable.(x_var)';
        y_vals = subtable.(y_var)';
        plot(x_vals, y_vals, 'LineWidth', 1);
    end
    axis padded;
    grid on;
    grid minor;
    title(title_str, 'Interpreter', interpreter);
    xlabel(x_label_str, 'Interpreter', interpreter);
    ylabel(y_label_str, 'Interpreter', interpreter);
    legend(compare_vals, 'Interpreter', 'none');
    hold off
    
end
