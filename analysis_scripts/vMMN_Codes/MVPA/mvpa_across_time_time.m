function [] = mvpa_across_time_time(class1,class2,classifier,folds,metric,repeat,titlename,category)
    cfg = [] ;
    cfg.method        = 'mvpa';
    cfg.features      = 'chan';
    cfg.generalize       = 'time';
    cfg.mvpa.classifier  = classifier;
    cfg.mvpa.metric      = metric;
    cfg.latency          = [-0.2, 0.6];
    cfg.mvpa.k           = folds;
    cfg.mvpa.repeat      = repeat;
    cfg.design        = [ones(length(class1.trial),1); 2*ones(length(class2.trial),1)];
    
    stat = ft_timelockstatistics(cfg, class1, class2);
    mv_plot_result(stat.mvpa, stat.time)
    plot([0 0], [-0.2, 0.6], 'k--') % vert. l
%     set(gca, 'YTick', 1:6, 'YTickLabel', [0 0.1 0.2 0.3 0.4 0.5]);
    title(sprintf('%s (%s)',titlename, category))
    
end