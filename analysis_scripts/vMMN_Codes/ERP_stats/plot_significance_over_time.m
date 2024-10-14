function plot_significance_over_time(significance_matrix, actual_data, chan_labels, selected_channels,titlename)
    % This function plots the significance values over time for the specified channels
    % significance_matrix: 126x32 matrix with values -1, 0, and 1
    % actual_data: 126x200 matrix with actual amplitude values
    % chan_labels: 126x1 cell array of channel names
    % selected_channels: cell array of channel names to be plotted

    % Find the indices of the selected channels
    selected_indices = find(ismember(chan_labels, selected_channels));

    % Extract data for the selected channels
    selected_data = actual_data(selected_indices, :);
    
%     selected_data = movmean(selected_data,2,2);%smoothhhhh%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    selected_significance = significance_matrix(selected_indices, :);
    selected_labels = chan_labels(selected_indices);

    % Downsample the data to 32 intervals (averaging every 25ms)
    downsampled_selected_data = zeros(length(selected_indices), 16);
    for i = 1:16
        downsampled_selected_data(:, i) = mean(selected_data(:, (i-1)*12+1:i*12), 2);%changed to mean
    end


    % Normalize the downsampled data to the range of -1 to +1
    data_mean = mean(downsampled_selected_data(:));
    data_range = max(abs(downsampled_selected_data(:) - data_mean));
    normalized_selected_data = (downsampled_selected_data - data_mean) / data_range;
    
    
    
    normalized_selected_data = downsampled_selected_data;

    % Create masked data matrices
    masked_selected_data = normalized_selected_data;
    masked_selected_data(selected_significance == 0) = NaN;

    % Plot the heatmap
    figure;
    h = imagesc(masked_selected_data);
    title(titlename);
    cmap = [linspace(0, 1, 128)', linspace(0, 1, 128)', ones(128, 1); % Blue to White
            ones(128, 1), linspace(1, 0, 128)', linspace(1, 0, 128)']; % White to Red
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(selected_labels));
    yticklabels(selected_labels);
    xticks(1:2:16); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*50 - 200), 1:2:16, 'UniformOutput', false));
    xlabel('Time (ms)');
    ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h, 'AlphaData', ~isnan(masked_selected_data));

    % Add vertical line at 0ms
    hold on;
    xline(5, 'k--', 'LineWidth', 1); % 8 corresponds to 0ms since 8 * 25ms = 200ms

    % Add minor x-ticks and faded vertical lines
    ax = gca;
    ax.XMinorTick = 'on';
    ax.XAxis.MinorTickValues = 1:16; % Minor ticks at each 25ms interval
    for x = 1:16
        xline(x, '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); % Faded vertical lines
    end

    % Add single colorbar
    cb = colorbar('eastoutside');
    ylabel(cb, 'Normalized Amplitude (\muV)', 'FontSize', 12);
end
