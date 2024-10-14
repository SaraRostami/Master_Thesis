function [] = plot_ERP_func(chnls,cond1,cond2,legend1,legend2,titlename,ylm)
    cfg         = [];
    cfg.channel = chnls;
    cfg.xlim = [-0.2 0.6];
    cfg.ylim    = ylm; % Volts
    % figure
    ft_singleplotER(cfg, cond1,cond2);
    hold on
    xlabel('Time (s)')
    ylabel('Electric Potential (uV)')
    title(titlename)
    plot([cond1.time(1), cond1.time(end)], [0 0], 'k--') % add horizontal line
    plot([0 0], cfg.ylim, 'k--') % vert. l
    legend({legend1, legend2}, 'Location','southwest')

    print -dpng singleplot.png
    
end