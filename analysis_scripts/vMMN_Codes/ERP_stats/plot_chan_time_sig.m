function [] = plot_chan_time_sig(stat_cond, cond1,cond2,titlename)
    cfg = [];
    cfg.operation = 'subtract';
    cfg.parameter = 'avg';
    grandavg_effect = ft_math(cfg, cond1, cond2);
    chan_labels = grandavg_effect.label;
    significance_matrix = stat_cond;
    actual_data = grandavg_effect.avg;


    % Identify left-lobe (odd-ending) and right-lobe (even-ending) electrodes
    left_indices = find(cellfun(@(x) mod(str2double(x(regexp(x, '\d+$'))), 2) == 1, chan_labels));
    right_indices = find(cellfun(@(x) mod(str2double(x(regexp(x, '\d+$'))), 2) == 0, chan_labels));

    % Extract data for each region
    left_data = actual_data(left_indices, :);
    right_data = actual_data(right_indices, :);

    left_significance = significance_matrix(left_indices, :);
    right_significance = significance_matrix(right_indices, :);

    left_labels = chan_labels(left_indices);
    right_labels = chan_labels(right_indices);

    % Downsample the data to 32 intervals (averaging every 25ms)
    downsampled_left_data = zeros(length(left_indices), 32);
    downsampled_right_data = zeros(length(right_indices), 32);

    for i = 1:32
        downsampled_left_data(:, i) = mean(left_data(:, (i-1)*6+1:i*6), 2);
        downsampled_right_data(:, i) = mean(right_data(:, (i-1)*6+1:i*6), 2);
    end

    % Normalize the downsampled data to the range of -1 to +1
    normalized_left_data = (downsampled_left_data - mean(downsampled_left_data(:))) / max(abs(downsampled_left_data(:) - mean(downsampled_left_data(:))));
    normalized_right_data = (downsampled_right_data - mean(downsampled_right_data(:))) / max(abs(downsampled_right_data(:) - mean(downsampled_right_data(:))));

    normalized_left_data = downsampled_left_data;
    normalized_right_data = downsampled_right_data;
    
    % Create masked data matrices
    masked_left_data = normalized_left_data;
    masked_right_data = normalized_right_data;

    masked_left_data(left_significance == 0) = NaN;
    masked_right_data(right_significance == 0) = NaN;

    % Plot the heatmaps
    figure;

    % Plot left brain region
    subplot(1, 2, 1);
    h1 = imagesc(masked_left_data);
    title('Left Brain Region');
    cmap = [linspace(0, 1, 128)', linspace(0, 1, 128)', ones(128, 1); % Blue to White
            ones(128, 1), linspace(1, 0, 128)', linspace(1, 0, 128)']; % White to Red
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(left_labels));
    yticklabels(left_labels);
    xticks(1:4:32); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*25 - 200), 1:4:32, 'UniformOutput', false));
    xlabel('Time (ms)');
    ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h1, 'AlphaData', ~isnan(masked_left_data));

    hold on;
    xline(8, 'k--', 'LineWidth', 1);


    % Plot right brain region
    subplot(1, 2, 2);
    h2 = imagesc(masked_right_data);
    title('Right Brain Region');
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(right_labels));
    yticklabels(right_labels);
    xticks(1:4:32); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*25 - 200), 1:4:32, 'UniformOutput', false));
    xlabel('Time (ms)');
    ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h2, 'AlphaData', ~isnan(masked_right_data));

    % Add vertical line at 0ms for right brain region
    hold on;
    xline(8, 'k--', 'LineWidth', 1); % 8 corresponds to 0ms since 8 * 25ms = 200ms

    % Add single colorbar next to the right plot
    colorbar('eastoutside');
    ylabel(colorbar, 'Normalized Amplitude (\muV)', 'FontSize', 12);

    % Adjust the space between plots
    subplot(1, 2, 1);
    pos1 = get(gca, 'Position'); % Position of left subplot
    subplot(1, 2, 2);
    pos2 = get(gca, 'Position'); % Position of right subplot

    % Decrease the space between the plots
    pos1(3) = pos1(3); % Increase the width of left plot
    pos2(1) = pos2(1) - 0.05; % Move right plot to the left
    pos2(3) = pos2(3) * 1.4; % Increase the width of right plot

    set(subplot(1, 2, 1), 'Position', pos1);
    set(subplot(1, 2, 2), 'Position', pos2);

    % Add the title for the entire figure
    sgtitle(titlename);

    % Adjust the figure for better readability
    set(gcf, 'Position', [100, 100, 1400, 600]); % Increase the width for better spacing

end