function [] = mvpa_across_time_space(class1,class2,classifier,folds,metric,repeat,titlename,category)
    cfg = [] ;
    cfg.method        = 'mvpa';
    cfg.features      = [];
    cfg.mvpa.classifier  = classifier;
    cfg.mvpa.metric      = metric;
    cfg.latency          = [-0.2, 0.6];
    cfg.mvpa.k           = folds;
    cfg.mvpa.repeat      = repeat;
    cfg.design        = [ones(length(class1.trial),1); 2*ones(length(class2.trial),1)];
    
    stat = ft_timelockstatistics(cfg, class1, class2);
    mv_plot_result(stat.mvpa, stat.time)
    set(gca, 'YTick', 1:2:length(stat.label), 'YTickLabel', stat.label(1:2:end));
    title(sprintf('%s (%s)',titlename, category))
    saveas(gcf,sprintf('sub5_mvpa_across_time_space_%s(%s).png',titlename,category))
    
end