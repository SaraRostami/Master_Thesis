function [] = plot_ERP_func4(chnls,cond1,cond2,cond3,cond4,legend1,legend2,legend3,legend4,titlename,i)
    cfg         = [];
    cfg.channel = chnls;
    

%     clmap = [0 0 1; 1 0 0];
%     cfg.colormap = 'jet';
    % figure
    ft_singleplotER(cfg, cond1,cond2,cond3,cond4);
    y_limits = get(gca, 'YLim');
    x_limits = get(gca, 'XLim');
    cfg.ylim    = y_limits; % Volts
    cfg.xlim = x_limits;
    hold on
    xlabel('Time (s)')
    ylabel('Electric Potential (uV)')
    title(titlename)
    plot([cond1.time(1), cond1.time(end)], [0 0], 'k--') % add horizontal line
    plot([0 0], cfg.ylim, 'k--') % vert. l
    legend({legend1, legend2, legend3, legend4}, 'Location','northwest')

    img_name = sprintf('grandERP_%s_%s_%s_%s_%s.png',legend1, legend2,legend3,legend4,i);
%     print('-dpng',img_name);
    
    
end