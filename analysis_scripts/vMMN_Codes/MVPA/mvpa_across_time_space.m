function [] = mvpa_across_time_space(class1,class2,chnls,classifier,folds,metric,repeat,titlename,category)

    for i=1:length(class1.trial)
        class1.trial{i} = movmean(class1.trial{i},6,2);
    end
    
    for i=1:length(class2.trial)
        class2.trial{i} = movmean(class2.trial{i},6,2);
    end
%     for i=1:min(length(class1.trial),length(class1.trial))
%         a = class1.trial{i};
%         class2.trial{i}(:,1:75)=a(:,1:75);
%     end
    
    cfg = [] ;
    cfg.method        = 'mvpa';
    cfg.features      = [];
    cfg.mvpa.classifier  = classifier;
    cfg.channel=chnls;
    cfg.mvpa.metric      = metric;
    cfg.latency          = [-0.1, 0.6];
    cfg.mvpa.k           = folds;
    cfg.mvpa.repeat      = repeat;
    cfg.design        = [ones(length(class1.trial),1); 2*ones(length(class2.trial),1)];
    

    
    stat = ft_timelockstatistics(cfg, class1, class2);
    mv_plot_result(stat.mvpa, stat.time)
    set(gca, 'YTick', 1:1:length(stat.label), 'YTickLabel', stat.label(1:1:end));
    title(sprintf('%s (%s)',titlename, category))
%     saveas(gcf,sprintf('sub3_mvpa_across_time_space_%s(%s).jpg',titlename,category))
    
end