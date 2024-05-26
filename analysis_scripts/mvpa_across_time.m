function [] = mvpa_across_time(class1,class2,chnls,classifier,folds,metric,repeat,titlename,categories)
    cfg = [] ;
    cfg.method           = 'mvpa';
    cfg.features         = 'chan';
    cfg.channel          = chnls;
    cfg.mvpa.classifier  = classifier;
%     cfg.avgovertime     = 'yes';
%     cfg.latency         = [0.15, 0.25]; 
    cfg.mvpa.metric      = metric;
    cfg.latency          = [-0.2, 0.6];
    cfg.mvpa.k           = folds;
    cfg.mvpa.repeat      = repeat;
    cfg.design           = [ones(length(class1.time),1); zeros(length(class2.time),1)];

    stat = ft_timelockstatistics(cfg, class1, class2);
    mv_plot_result(stat.mvpa, stat.time)
    title(sprintf('Classification %s %s (%s)',metric,titlename, categories))
    saveas(gcf,sprintf('sub5_mvpa_across_time_%s(%s).png',titlename,categories))
    
end