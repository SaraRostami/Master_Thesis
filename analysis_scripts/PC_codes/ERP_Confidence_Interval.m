%%
cfg           = [];
cfg.method    = 'analytic'; % using a parametric test
cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
cfg.correctm  = 'no'; % no multiple comparisons correction
cfg.alpha     = 0.05;

% cfg.design    = data_EEG_filt.trialinfo; % indicating which trials belong ...
                                         % to what category
                                         
cfg.design          = [ones(length(face.time),1); 2*ones(length(house.time),1)];
cfg.ivar      = 1; % indicating that the independent variable is found in ...
                   % first row of cfg.design
dat = ft_appenddata([], face, house);
stat_t = ft_timelockstatistics(cfg, dat);
%%
erp_face.mask = stat_t.mask; % adding mask to ERP
ft_data1.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = ft_data1.elec;   
layout = ft_prepare_layout(cfg);

figure

cfg               = [];
cfg.layout        = layout;
cfg.maskparameter = 'mask';
cfg.maskstyle     = 'box';
cfg.maskfacealpha = 0.5; % transparency of mask
cfg.channel       = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
cfg.ylim          = [-3 5]; % Volts

ft_singleplotER(cfg, erp_face, erp_house);

hold on
xlabel('Time (s)')
ylabel('Electric Potential (V)')
plot([erp_face.time(1), erp_house.time(end)], [0 0], 'k--') % hor. line
plot([0 0], cfg.ylim, 'k--') % vert. l
axes = gca;
% legend({'Face', 'House'});
% title('Cofidence Interval (Face vs. House)')


print -dpng singleplot_t_uncorrected.png
%%