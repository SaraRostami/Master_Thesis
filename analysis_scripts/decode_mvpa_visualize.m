% Parameters
chnls = 'all';  % replace with actual channels if needed
classifier = 'lda';
folds = 5;
metric = 'accuracy';
repeat = 2;

mvpa_all_stats = struct();

% Call mvpa_across_time for each condition and category

% expected_f and expected_if have fewer data points -> we should bootstrap
mvpa_all_stats.ef = mvpa_across_time(expected_f, unexpected_f, chnls, classifier, folds, metric, repeat);
mvpa_all_stats.eh = mvpa_across_time(expected_h, unexpected_h, chnls, classifier, folds, metric, repeat);
mvpa_all_stats.ei = mvpa_across_time(expected_if, unexpected_if, chnls, classifier, folds, metric, repeat);
mvpa_all_stats.rf = mvpa_across_time(repeat_f, alternate_f, chnls, classifier, folds, metric, repeat);
mvpa_all_stats.rh = mvpa_across_time(repeat_h, alternate_h, chnls, classifier, folds, metric, repeat);
mvpa_all_stats.ri = mvpa_across_time(repeat_if, alternate_if, chnls, classifier, folds, metric, repeat);

ymin = min([min(mvpa_all_stats.ef.mvpa.perf - mvpa_all_stats.ef.mvpa.perf_std),min(mvpa_all_stats.eh.mvpa.perf - mvpa_all_stats.eh.mvpa.perf_std),min(mvpa_all_stats.ei.mvpa.perf - mvpa_all_stats.ei.mvpa.perf_std),min(mvpa_all_stats.rf.mvpa.perf - mvpa_all_stats.rf.mvpa.perf_std),min(mvpa_all_stats.rh.mvpa.perf - mvpa_all_stats.rh.mvpa.perf_std),min(mvpa_all_stats.ri.mvpa.perf - mvpa_all_stats.ri.mvpa.perf_std)]);
ymax = max([max(mvpa_all_stats.ef.mvpa.perf + mvpa_all_stats.ef.mvpa.perf_std),max(mvpa_all_stats.eh.mvpa.perf + mvpa_all_stats.eh.mvpa.perf_std),max(mvpa_all_stats.ei.mvpa.perf + mvpa_all_stats.ei.mvpa.perf_std),max(mvpa_all_stats.rf.mvpa.perf + mvpa_all_stats.rf.mvpa.perf_std),max(mvpa_all_stats.rh.mvpa.perf + mvpa_all_stats.rh.mvpa.perf_std),max(mvpa_all_stats.ri.mvpa.perf + mvpa_all_stats.ri.mvpa.perf_std)]);

%%

fnr = fieldnames(mvpa_all_stats);
color_line = [0, 0.4470, 0.7410];
color_shade = [0.3010, 0.7450, 0.9330];

figure()


for i=1:length(fnr)
    if strcmp('e',fnr{i}(1))
        cond = 'Expectation';
    else
        cond = 'Repetition Supression';
    end
    if strcmp('f',fnr{i}(2))
        cat = 'Face';
    elseif strcmp('h',fnr{i}(2))
        cat = 'House';
    else
        cat = 'Inverse Face';
    end
    subplot(2, 3, i);
    ph = shadedErrorBar(mvpa_all_stats.(fnr{i}).time, mvpa_all_stats.(fnr{i}).mvpa.perf, mvpa_all_stats.(fnr{i}).mvpa.perf_std);
    hold on
    set(ph.mainLine, 'LineWidth', 0.75, 'Color', color_line);            % modify the mean line  
    set(ph.patch, 'facealpha', 0.3,'facecolor', color_shade); %modify shaded region
    plot([mvpa_all_stats.(fnr{i}).time(1), mvpa_all_stats.(fnr{i}).time(end)], [0.5 0.5], 'k--') % add horizontal line
    % hold on
    plot([0 0],[ymin ymax] , 'k-')
    ylim([ymin ymax]);
    title(sprintf('%s - %s', cond, cat));
end
sgtitle('Sub3 - with Re-referencing')