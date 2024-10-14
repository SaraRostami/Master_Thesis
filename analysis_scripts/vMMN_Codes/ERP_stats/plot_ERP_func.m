function [] = plot_ERP_func(chnls,cond1,cond2,legend1,legend2,titlename,i)
    % smoothing the lines
%     difference_wave.avg = movmean(difference_wave.avg,12,2);
%     cond1.avg = movmean(cond1.avg,5,2);
%     cond2.avg = movmean(cond2.avg,5,2);
    
    latency = [-0.2 0.6];
    cfg           = [];
    cfg.latency= latency;
    cfg.channel = chnls;
    cfg.operation = 'x2-x1';
    cfg.parameter = 'avg';
%     cfg.lpfilter = 'yes';
%     cfg.lpfreq = 20;
%     cfg.hpfilter = 'yes';
%     cfg.hpfreq = 1.5;
    difference_wave = ft_math(cfg, cond1, cond2);

    cfg         = [];
    cfg.channel = chnls;
    cfg.latency= latency;
    
%     cfg.lpfilter = 'yes';
%     cfg.lpfreq = 20;
%     cfg.hpfilter = 'yes';
%     cfg.hpfreq = 1.5;
    cfg.xlim = latency;
    ft_singleplotER(cfg, cond1,cond2,difference_wave);
    y_limits = get(gca, 'YLim');
%     x_limits = get(gca, 'XLim');
    cfg.ylim    = y_limits; % Volts
    hold on
    xlabel('Time (s)')
    ylabel('Electric Potential (uV)')
    title(titlename)
    plot([cond1.time(1), cond1.time(end)], [0 0], 'k--') % add horizontal line
    plot([0 0], cfg.ylim, 'k--') % vert. l
    legend3 = sprintf('%s-%s',legend2, legend1);
    legend({legend1, legend2,legend3}, 'Location','northwest')

    img_name = sprintf('grandERP_%s_%s_%s.png',legend1, legend2,i);
%     print('-dpng',img_name);
    
    
end