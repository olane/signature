function [ output_args ] = plot_passthrough_test_batch( set, len, succ, tot, plotname, filename, errorbars )

    % Note: set isn't actually used at the moment. Averages are calculated
    % for all results with the same length.
    
    % Saves as an eps file in the docs/figs folder, filename should end in
    % '.eps' 
    
    % Calculate the averages
    
    param_matrix = len';
    
    param_vals = unique(param_matrix, 'rows');
    
    new_len = zeros(length(param_vals(:,1)), 1);
    new_succ = zeros(length(param_vals(:,1)), 1);
    new_tot = zeros(length(param_vals(:,1)), 1);
    std_dev = zeros(length(param_vals(:,1)), 1);
    
    for i = 1:length(param_vals(:, 1));
        
        this_len = param_matrix(i);
        
        indices = (param_matrix(:) == this_len);
        
        new_len(i) = this_len;
        
        new_tot(i) = mean(tot(indices));
        new_succ(i) = mean(succ(indices));
        
        std_dev(i) = std(succ(indices));
        
    end

    
    len = new_len';
    succ = new_succ';
    tot = new_tot';
    std_dev = std_dev';
    
    
    percentages = succ ./ tot * 100;
    
    % Plot the results

    width = 600;
    height = 750;
    x0 = 0;
    y0 = 0;
    
    figure('NumberTitle', 'off', ...
           'Units','pixels',...
           'Position',[x0 y0 width height],...
           'PaperPositionMode','auto');
       
    hold on;
    
    ylim([0, 100]);

    ax = gca;
    ax.XTick = unique(len);
    
    ax.FontSize = 20;
    ax.Units = 'normalized';
    ax.Position = [.15 .2 .75 .7];
    ax.YGrid = 'on';
    
    xlabel('Clip length (s)');
    ylabel('Percentage match rate');
       
    title(plotname);
 
    if(errorbars)
        errorbar(len, percentages, std_dev, ...
             '-or', 'MarkerSize', 8);
    else
        plot(len, percentages, ...
             '-or', 'MarkerSize', 8);
    end
        
    hold off;
    
    saveas(gca, ['./docs/figs/' filename], 'epsc');

end


