function [] = plot_chan_time_sig4(stat_cond, cond1,cond2,titlename)
    cfg = [];
    cfg.operation = 'subtract';
    cfg.parameter = 'avg';
    grandavg_effect = ft_math(cfg, cond1, cond2);
    chan_labels = grandavg_effect.label;
    significance_matrix = stat_cond;
    actual_data = grandavg_effect.avg;

    % Identify different brain regions based on channel names
    frontal_indices = find(startsWith(chan_labels, 'F') | startsWith(chan_labels, 'A'));
    occipital_indices = find(startsWith(chan_labels, 'O'));
    parietal_indices = find(startsWith(chan_labels, 'P'));
    central_indices = find(startsWith(chan_labels, 'C'));
    temporal_indices = find(startsWith(chan_labels, 'T'));

    % Extract data for each region
    frontal_data = actual_data(frontal_indices, :);
    occipital_data = actual_data(occipital_indices, :);
    parietal_data = actual_data(parietal_indices, :);
    central_data = actual_data(central_indices, :);
    temporal_data = actual_data(temporal_indices, :);

    
    frontal_significance = significance_matrix(frontal_indices, :);
    occipital_significance = significance_matrix(occipital_indices, :);
    parietal_significance = significance_matrix(parietal_indices, :);
    central_significance = significance_matrix(central_indices, :);
    temporal_significance = significance_matrix(temporal_indices, :);
    
    
    
    frontal_labels = chan_labels(frontal_indices);%frontal_indices
    occipital_labels = chan_labels(occipital_indices);
    parietal_labels = chan_labels(parietal_indices);
    central_labels = chan_labels(central_indices);
    temporal_labels = chan_labels(temporal_indices);

    % Downsample the data to 32 intervals (averaging every 25ms) -> 16 intervals (50 ms)
    downsampled_frontal_data = zeros(length(frontal_indices), 16);
    downsampled_occipital_data = zeros(length(occipital_indices), 16);
    downsampled_parietal_data = zeros(length(parietal_indices), 16);
    downsampled_central_data = zeros(length(central_indices), 16);
    downsampled_temporal_data = zeros(length(temporal_indices), 16);

    for i = 1:16
        downsampled_frontal_data(:, i) = mean(frontal_data(:, (i-1)*8+1:i*8), 2);
        downsampled_occipital_data(:, i) = mean(occipital_data(:, (i-1)*8+1:i*8), 2);
        downsampled_parietal_data(:, i) = mean(parietal_data(:, (i-1)*8+1:i*8), 2);
        downsampled_central_data(:, i) = mean(central_data(:, (i-1)*8+1:i*8), 2);
        downsampled_temporal_data(:, i) = mean(temporal_data(:, (i-1)*8+1:i*8), 2);
    end

    % Normalize the downsampled data to the range of -1 to +1
%     normalized_frontal_data = (downsampled_frontal_data - mean(downsampled_frontal_data(:))) / max(abs(downsampled_frontal_data(:) - mean(downsampled_frontal_data(:))));
%     normalized_occipital_data = (downsampled_occipital_data - mean(downsampled_occipital_data(:))) / max(abs(downsampled_occipital_data(:) - mean(downsampled_occipital_data(:))));
%     normalized_parietal_data = (downsampled_parietal_data - mean(downsampled_parietal_data(:))) / max(abs(downsampled_parietal_data(:) - mean(downsampled_parietal_data(:))));
%     normalized_central_data = (downsampled_central_data - mean(downsampled_central_data(:))) / max(abs(downsampled_central_data(:) - mean(downsampled_central_data(:))));
%     normalized_temporal_data = (downsampled_temporal_data - mean(downsampled_temporal_data(:))) / max(abs(downsampled_temporal_data(:) - mean(downsampled_temporal_data(:))));

    normalized_frontal_data = downsampled_frontal_data;
    normalized_occipital_data = downsampled_occipital_data;
    normalized_parietal_data =downsampled_parietal_data;
    normalized_central_data = downsampled_central_data;
    normalized_temporal_data =downsampled_temporal_data;

    % Create masked data matrices
    masked_frontal_data = normalized_frontal_data;
    masked_occipital_data = normalized_occipital_data;
    masked_parietal_data = normalized_parietal_data;
    masked_central_data = normalized_central_data;
    masked_temporal_data = normalized_temporal_data;

    masked_frontal_data(frontal_significance == 0) = NaN;
    masked_occipital_data(occipital_significance == 0) = NaN;
    masked_parietal_data(parietal_significance == 0) = NaN;
    masked_central_data(central_significance == 0) = NaN;
    masked_temporal_data(temporal_significance == 0) = NaN;

    % Plot the heatmaps
    figure;

    % Plot Frontal region
    subplot(2, 2, 1);
    h1 = imagesc(masked_frontal_data);
    title('Frontal Region');
    cmap = [linspace(0, 1, 128)', linspace(0, 1, 128)', ones(128, 1); % Blue to White
            ones(128, 1), linspace(1, 0, 128)', linspace(1, 0, 128)']; % White to Red
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(frontal_labels));
    yticklabels(frontal_labels);
    xticks([1,3,5,7,9,11,13,15,15.8]); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*50 - 200), [1,3,5,7,9,11,13,15], 'UniformOutput', false));
%     xlabel('Time (ms)');
    ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h1, 'AlphaData', ~isnan(masked_frontal_data));

    % Add vertical line at 0ms for frontal region
    hold on;
    xline(5, 'k--', 'LineWidth', 1); % 8 corresponds to 0ms since 8 * 25ms = 200ms(4 ~ 50 ms)
    % Add minor x-ticks and faded vertical lines
    ax1 = gca;
    ax1.XMinorTick = 'on';
    ax1.XAxis.MinorTickValues = 1:15; % Minor ticks at each 25ms interval
    for x = 1:15
        xline(x, '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); % Faded vertical lines
    end

    % Plot Occipital region
    subplot(2, 2, 3);
    h2 = imagesc(masked_occipital_data);
    title('Occipital Region');
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(occipital_labels));
    yticklabels(occipital_labels);
    xticks([1,3,5,7,9,11,13,15,15.8]); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*50 - 200), [1,3,5,7,9,11,13,15], 'UniformOutput', false));
    xlabel('Time (ms)');
    ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h2, 'AlphaData', ~isnan(masked_occipital_data));

    % Add vertical line at 0ms for occipital region
    hold on;
    xline(5, 'k--', 'LineWidth', 1); % 8 corresponds to 0ms since 8 * 25ms = 200ms

    % Add minor x-ticks and faded vertical lines
    ax2 = gca;
    ax2.XMinorTick = 'on';
    ax2.XAxis.MinorTickValues = 1:15; % Minor ticks at each 25ms interval
    for x = 1:15
        xline(x, '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); % Faded vertical lines
    end

    % Plot Parietal region
    subplot(2, 2, 2);
    h3 = imagesc(masked_parietal_data);
    title('Parietal Region');
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(parietal_labels));
    yticklabels(parietal_labels);
    xticks([1,3,5,7,9,11,13,15,15.8]); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*50 - 200), [1,3,5,7,9,11,13,15], 'UniformOutput', false));
%     xlabel('Time (ms)');
%     ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h3, 'AlphaData', ~isnan(masked_parietal_data));

    % Add vertical line at 0ms for parietal region
    hold on;
    xline(5, 'k--', 'LineWidth', 1); % 8 corresponds to 0ms since 8 * 25ms = 200ms

    % Add minor x-ticks and faded vertical lines
    ax3 = gca;
    ax3.XMinorTick = 'on';
    ax3.XAxis.MinorTickValues = 1:15; % Minor ticks at each 25ms interval
    for x = 1:15
        xline(x, '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); % Faded vertical lines
    end

    % Plot Central region
    subplot(2, 2, 4);
    h4 = imagesc(masked_central_data);
    title('Central Region');
    colormap(gca, cmap);
    caxis([-1 1]);
    yticks(1:length(central_labels));
    yticklabels(central_labels);
    xticks([1,3,5,7,9,11,13,15,15.8]); % Show fewer x-tick labels
    xticklabels(arrayfun(@(x) sprintf('%dms', (x-1)*50 - 200), [1,3,5,7,9,11,13,15], 'UniformOutput', false));
    xlabel('Time (ms)');
%     ylabel('EEG Channels');
    set(gca, 'FontSize', 10, 'TickLength', [0 0]);
    set(h4, 'AlphaData', ~isnan(masked_central_data));

    % Add vertical line at 0ms for central region
    hold on;
    xline(5, 'k--', 'LineWidth', 1); % 8 corresponds to 0ms since 8 * 25ms = 200ms

    % Add minor x-ticks and faded vertical lines
    ax4 = gca;
    ax4.XMinorTick = 'on';
    ax4.XAxis.MinorTickValues = 1:15; % Minor ticks at each 25ms interval
    for x = 1:15
        xline(x, '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.5); % Faded vertical lines
    end

    % Add single colorbar next to the central plot
    cb = colorbar('eastoutside');
    ylabel(cb, 'Normalized Amplitude (\muV)', 'FontSize', 12);

    % Adjust the space between plots
    subplot(2, 2, 1);
    pos1 = get(gca, 'Position'); % Position of frontal subplot
    subplot(2, 2, 2);
    pos2 = get(gca, 'Position'); % Position of occipital subplot
    subplot(2, 2, 3);
    pos3 = get(gca, 'Position'); % Position of parietal subplot
    subplot(2, 2, 4);
    pos4 = get(gca, 'Position'); % Position of central subplot

    % Decrease the space between the plots
    pos1(3) = pos1(3) * 1.02; % Increase the width of frontal plot
    pos2(1) = pos2(1) - 0.05; % Move occipital plot to the left
    pos2(3) = pos2(3) * 1.02; % Increase the width of occipital plot
    pos3(3) = pos3(3) * 1.02; % Increase the width of parietal plot
    pos4(1) = pos4(1) - 0.05; % Move central plot to the left
    pos4(3) = pos4(3) * 1.4; % Increase the width of central plot

    % Increase height and decrease vertical space between plots
    pos1(4) = pos1(4) * 1.16;
    pos2(4) = pos2(4) * 1.16;
    pos3(4) = pos3(4) * 1;
    pos4(4) = pos4(4) * 1.16;
    pos1(2) = pos1(2) - 0.05;
    pos2(2) = pos2(2) - 0.05;
    pos3(2) = pos3(2) - 0.05;
    pos4(2) = pos4(2) - 0.05;

    
    
    set(subplot(2, 2, 1), 'Position', pos1);
    set(subplot(2, 2, 2), 'Position', pos2);
    set(subplot(2, 2, 3), 'Position', pos3);
    set(subplot(2, 2, 4), 'Position', pos4);


    % Add the title for the entire figure
    sgtitle(titlename);

    % Adjust the figure for better readability
    set(gcf, 'Position', [100, 100, 1400, 800]); % Increase the width for better spacing

end
