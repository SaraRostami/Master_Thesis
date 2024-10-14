function [] = plot_ERP_significant(stat,grandERP1,grandERP2,legend1,legend2,titlename,smooth,chnls)
    
    cond1 = grandERP1;
    cond2 = grandERP2;


    if smooth == 1 % smoothing the lines
        cond1.avg = movmean(cond1.avg,12,2);
        cond2.avg = movmean(cond2.avg,12,2);
    end
    
    grandERP1.elec.coordsys = 'eeglab';
    cfg = [];
    cfg.elec = grandERP1.elec;   
    layout = ft_prepare_layout(cfg);


    % get relevant values
%     pos_cluster_pvals = [stat.posclusters(:).prob];
%     pos_clust = find(pos_cluster_pvals < 0.06);
%     pos       = ismember(stat.posclusterslabelmat, pos_clust);
% 
%     neg_cluster_pvals = [stat.negclusters(:).prob];
%     neg_clust = find(neg_cluster_pvals < 0.06);
%     neg       = ismember(stat.negclusterslabelmat, neg_clust);
    
%     neg = stat.negclusterslabelmat == 1;% | stat.negclusterslabelmat == 2;% cheetingggggggggggggggggg
%     pos = stat.posclusterslabelmat == 1;% cheetingggggggggggggggggg
    
    

%     sig_chnls_idx = find(any(pos, 2)| any(neg, 2));
%     sig_chnls = stat.label(sig_chnls_idx);

%     sig_times = any(pos, 1)| any(neg, 1);
%     stat_mask = zeros(126,length(stat.time));
%     for i=1:length(sig_chnls_idx)
%         stat_mask(sig_chnls_idx(i),:)= sig_times;
%     end
    
%     new_mask= [zeros(length(stat.label),ceil((stat.time(1)-(-0.2))*250)) stat.mask zeros(length(stat.label),200 - ceil(((stat.time(end)-(-0.2))*250)+1))];
%     new_mask= [zeros(length(stat.label),ceil((stat.time(1)-(-0.2))*250)) stat_mask];% cheeeetinggggggggg
    new_mask = stat;
    sig_chnls = find(any(new_mask,2));

    cfg = [];
    cfg.operation = 'subtract';
    cfg.parameter = 'avg';
    cfg.operation = 'x2-x1';
    diff_wave    = ft_math(cfg, cond1, cond2);
    cfg=[];
    % cfg.lpfilter = 'yes';
    % cfg.lpfreq = 20;
    % cfg.hpfilter = 'yes';
    % cfg.hpfreq = 2;
    
%     cfg.channel = stat.label;
    cfg.channel = grandERP1.label;
    diff_wave = ft_selectdata(cfg,diff_wave);
    cond1 = ft_selectdata(cfg,cond1);
    cond2 = ft_selectdata(cfg,cond2);
    cond1.mask = new_mask;
    cond2.mask = new_mask;
    diff_wave.mask = new_mask; % adding mask to ERP


    figure

    cfg               = [];
    cfg.layout        = layout;
    cfg.maskparameter = 'mask';
    cfg.maskstyle     = 'box';
    cfg.maskfacealpha = 0.5; % transparency of mask
    tang_et_al = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
    
    if ~strcmp(chnls,'sig')
        sig_chnls = chnls;
    end
    
    cfg.channel = sig_chnls;
    cfg.xlim = [-0.1 0.6];



    ft_singleplotER(cfg, cond1, cond2, diff_wave);
    legend3 = sprintf('%s-%s',legend2, legend1);
%     legend({legend1, legend2,legend3}, 'Location','northwest')
    hold on;
    y_limits = get(gca, 'YLim');
    cfg.ylim    = y_limits; % Volts
    hold on
    xlabel('Time (s)')
    ylabel('Electric Potential (uV)')
%     title(sprintf('%s (%s - %s)',titlename,legend2,legend1));
    plot([cond1.time(1), cond1.time(end)], [0 0], 'k--') % hor. line
    hold on;
    plot([0 0], cfg.ylim, 'k--') % vert. l
%     img_name = sprintf('stat_ERP_%s_%s_%d.png',legend1, legend2,i);
%     print('-dpng',img_name);
    
    
end