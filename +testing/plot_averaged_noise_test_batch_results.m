function plot_averaged_noise_test_batch_results( set, snr, len, succ, tot, plotname, filename, errorbars )

    % Note: set isn't actually used at the moment. Averages are calculated
    % for all results with the same length and same snr.
    
    % Saves as an eps file in the docs/figs folder, filename should end in
    % '.eps' 
    
    % Calculate the averages
    
    param_matrix = horzcat(snr', len');
    
    param_vals = unique(param_matrix, 'rows');
    
    new_snr = zeros(length(param_vals(:,1)), 1);
    new_len = zeros(length(param_vals(:,1)), 1);
    new_succ = zeros(length(param_vals(:,1)), 1);
    new_tot = zeros(length(param_vals(:,1)), 1);
    std_dev = zeros(length(param_vals(:,1)), 1);
    
    for i = 1:length(param_vals(:, 1));
        
        this_snr = param_matrix(i, 1);
        this_len = param_matrix(i, 2);
        
        indices = (param_matrix(:,1) == this_snr & param_matrix(:,2) == this_len);
        
        new_snr(i) = this_snr;
        new_len(i) = this_len;
        
        new_tot(i) = mean(tot(indices));
        new_succ(i) = mean(succ(indices));
        
        std_dev(i) = std(succ(indices));
        
    end

    
    snr = new_snr';
    len = new_len';
    succ = new_succ';
    tot = new_tot';
    std_dev = std_dev';
    
    % Plot the results

    width = 1200;
    height = 750;
    x0 = 0;
    y0 = 0;
    
    figure('Name', plotname, ...
           'NumberTitle', 'off', ...
           'Units','pixels',...
           'Position',[x0 y0 width height],...
           'PaperPositionMode','auto');
       
    hold on;
    
    percentages = succ ./ tot * 100;
    len_vals = unique(len);
    
    legend_entries = cell(length(len_vals), 1);
    markers = {'-+k','-or','-xb','-^c','-*k','-sr','-db','-vc','->b','-<r','-pb','-hc'};
    i = 1;
    
    for len_val = len_vals
        
        % Find the locations we're looking at for this length value
        indices = find(len == len_val);
        
        % Grab the relevant values
        these_snrs = snr(indices);
        these_percentages = percentages(indices);
        these_std_devs = std_dev(indices);
        
        % Plot them (with a unique marker each time)
        if(errorbars)
            errorbar(these_snrs, these_percentages, these_std_devs, ...
                 markers{mod(i,numel(markers))}, 'MarkerSize', 8);
        else
            plot(these_snrs, these_percentages, ...
                 markers{mod(i,numel(markers))}, 'MarkerSize', 8);
        end
        
        % Add line to legend
        legend_entries(i) = {sprintf('%i seconds', len_val)} ;
        
        i = i + 1;
        
    end

    ax = gca;
    ax.XTick = unique(snr);
    
    ax.FontSize = 20;
    ax.Units = 'normalized';
    ax.Position = [.15 .2 .75 .7];
    ax.YGrid = 'on';
    
    xlabel('Signal to Noise ratio (dB)');
    ylabel('Percentage match rate');
    
    legend('String', legend_entries, ...
           'Location', 'southeast', ...
           'FontSize', 20);
       
    title(plotname);
    
    hold off;
    
    saveas(gca, ['./docs/figs/' filename], 'epsc');

end

