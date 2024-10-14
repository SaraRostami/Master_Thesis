function [] = plot_ERP_func3(chnls,cond1,cond2,cond3,legend1,legend2,legend3, titlename,ylm,i)
    cfg         = [];
    cfg.channel = chnls;
    cfg.xlim = [-0.2 0.6];
    cfg.ylim    = ylm; % Volts
%     clmap = [0 0 1; 1 0 0];
%     cfg.colormap = 'jet';
    % figure
    ft_singleplotER(cfg, cond1,cond2, cond3);
    hold on
    xlabel('Time (s)')
    ylabel('Electric Potential (uV)')
    title(titlename)
    plot([cond1.time(1), cond1.time(end)], [0 0], 'k--') % add horizontal line
    plot([0 0], cfg.ylim, 'k--') % vert. l
    legend({legend1, legend2, legend3}, 'Location','northwest')

    img_name = sprintf('grandERP_%s_%s_%s%s.png',legend1, legend2,legend3,i);
    print('-dpng',img_name);
    
    
end