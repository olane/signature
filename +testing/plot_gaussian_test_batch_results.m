function plot_gaussian_test_batch_results( snr, len, succ, tot, plotname )

    figure('Name', plotname, 'NumberTitle', 'off');
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
        
        % Plot them (with a unique marker each time)
        plot(these_snrs, these_percentages, ...
             markers{mod(i,numel(markers))}, 'MarkerSize', 8);
        
        % Add line to legend
        legend_entries(i) = {sprintf('%i seconds', len_val)} ;
        
        i = i + 1;
        
    end

    ax = gca;
    ax.XTick = unique(snr);
    
    ax.FontSize = 12;
    
    xlabel('Signal to Noise ratio (dB)');
    ylabel('Percentage match rate');
    
    legend('String', legend_entries, ...
           'Location', 'southeast', ...
           'FontSize', 12);
    
    hold off;
end

