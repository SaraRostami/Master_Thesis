function [] = mvpa_across_time_pseudo_trial(class1,class2,chnls,classifier,folds,metric,repeat,titlename,categories)
    
%     class1=mmf{1};class2=mnf{1};
%     classifier='lda';folds=2;metric='accuracy';repeat=2;
%     
    % creat pseudo-trials
    num = min(length(class1.trial), length(class1.trial));%number of pseudo-trials
%     psdo_len = min(length(class1.trial), length(class1.trial));%length of pseudo-trials
    for i=1:num 
    %rng(i);
        class1_randomIndexes = randperm(length(class1.trial), 10);
        cfg = [];
        cfg.trials = class1_randomIndexes;
        class1_pseudo_trial = ft_timelockanalysis(cfg, class1);
        if i == 1
            shuffled_class1 = class1_pseudo_trial;
        else
            shuffled_class1 = ft_appenddata(cfg, shuffled_class1, class1_pseudo_trial);
        end

        %house
        class2_randomIndexes = randperm(length(class2.trial), 10);
        cfg = [];
        cfg.trials = class2_randomIndexes;
        class2_pseudo_trial = ft_timelockanalysis(cfg, class2);
        if i == 1
            shuffled_class2 = class2_pseudo_trial;
        else
            shuffled_class2 = ft_appenddata(cfg, shuffled_class2, class2_pseudo_trial);
        end
        fprintf('-----------------------%d----------------------------\n',i);
    end
    
    
    for i=1:length(shuffled_class1.trial)
        shuffled_class1.trial{i} = movmean(shuffled_class1.trial{i},12,2);%1000/250 x 12 = 48 ms (window size)
    end
    
    for i=1:length(shuffled_class2.trial)
        shuffled_class2.trial{i} = movmean(shuffled_class2.trial{i},12,2);
    end

    cfg = [] ;
    cfg.demean          = 'yes';
    cfg.baselinewindow  = [-0.2 0.05];
    cfg.method           = 'mvpa';
    cfg.features         = 'chan';
    cfg.channel          = chnls;
    cfg.mvpa.classifier  = classifier;
    cfg.mvpa.cv = 'kfold';
%     cfg.avgovertime     = 'yes';
%     cfg.latency         = [0.15, 0.25]; 
    cfg.mvpa.metric      = metric;
    cfg.latency          = [-0.1, 0.6];
    cfg.mvpa.k           = folds;
    cfg.mvpa.repeat      = repeat;
    cfg.design           = [ones(length(shuffled_class1.time),1); zeros(length(shuffled_class2.time),1)];
    
    stat = ft_timelockstatistics(cfg, shuffled_class1, shuffled_class2);
    stat.mvpa.perf= stat.mvpa.perf  - mean(stat.mvpa.perf(1:50)) + 0.5;
    mv_plot_result(stat.mvpa, stat.time)
    title(sprintf('%s (%s)',titlename, categories))
%     saveas(gcf,sprintf('sub3_mvpa_across_time_%s(%s).png',titlename,categories))
    
end