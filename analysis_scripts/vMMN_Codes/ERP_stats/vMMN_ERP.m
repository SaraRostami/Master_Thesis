% Do so by averaging time-locked data across participants
subjects = [2,3,4,5,6,9,10];
% subjects = [3,4,6,9,10];

% Define the group names
groups1 = {'mmf', 'mnf', 'mmi', 'mni', 'mmh', 'mnh', 'nmf', 'nmi', 'nmh', 'nnf', 'nni', 'nnh','face','inface','house'};
groups = {'erps_mmf', 'erps_mnf', 'erps_mmi', 'erps_mni', 'erps_mmh', 'erps_mnh', 'erps_nmf', 'erps_nmi', 'erps_nmh', 'erps_nnf', 'erps_nni', 'erps_nnh','erps_face','erps_inface','erps_house'};

% Initialize the group cell arrays
for i = 1:length(groups1)
    eval(sprintf('%s = cell(1, length(subjects));', groups1{i}));
end

% Load the data for each condition
for i = 1:length(groups1)
    groupName1 = groups1{i};
    load(sprintf('GrandERP_%s.mat', groupName1));

end

for i = 1:length(groups)
    groupName = groups{i};
    groupName1 = groups1{i};
    eval(sprintf('%s = %s;', groupName, groupName1));

end
clear groups1 groupName1 mmf mmh mmi mnf mnh mni nmf nmh nmi nnf nnh nni face house inface
%%
% Calculate grand average for both conditions (standard, oddball) separately
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';

grandavg_face        = ft_timelockgrandaverage(cfg, erps_face{:});
grandavg_inface       = ft_timelockgrandaverage(cfg,erps_inface{:});
grandavg_house        = ft_timelockgrandaverage(cfg, erps_house{:});

grandavg_mmf        = ft_timelockgrandaverage(cfg, erps_mmf{:});
grandavg_mnf       = ft_timelockgrandaverage(cfg,erps_mnf{:});
grandavg_mmi        = ft_timelockgrandaverage(cfg, erps_mmi{:});
grandavg_mni       = ft_timelockgrandaverage(cfg, erps_mni{:});
grandavg_mmh       = ft_timelockgrandaverage(cfg, erps_mmh{:});
grandavg_mnh       = ft_timelockgrandaverage(cfg, erps_mnh{:});

grandavg_nmf        = ft_timelockgrandaverage(cfg, erps_nmf{:});
grandavg_nnf       = ft_timelockgrandaverage(cfg,erps_nnf{:});
grandavg_nmi        = ft_timelockgrandaverage(cfg, erps_nmi{:});
grandavg_nni       = ft_timelockgrandaverage(cfg, erps_nni{:});
grandavg_nmh       = ft_timelockgrandaverage(cfg, erps_nmh{:});
grandavg_nnh       = ft_timelockgrandaverage(cfg, erps_nnh{:});
%%
% [grandavg_mmf, grandavg_mnf] = ERP_pseudo_trial(group_mmf, group_mnf);
%%
% Plot the results
erps_mmf{1, 1}.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = erps_mmf{1, 1}.elec;   
layout = ft_prepare_layout(cfg);
cfg              = [];
cfg.layout       = layout;
% cfg.layout               = 'EEG1010.lay';
cfg.interactive          = 'yes';
cfg.showoutline          = 'yes';
cfg.showlabels           = 'yes';
ft_multiplotER(cfg, grandavg_mmf, grandavg_nnf);
hold on
title('MMF vs. NNF (Repetition Effect)')
%%
% Channel Selection -> 'MLx', 'MRx' and 'MZx' with x=C,F,O,P,T for left/right central, frontal, occipital, parietal and temporal
temp = {'T*'};% temporal
front = {'F*'};% frontal
occip = {'O*'};% occipital
frontotemp = [front,temp];
N170 = {'P1','P2','POz','Pz'};
P100 = {'Fz','FCz'};
tang_et_al = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
occip_pariet = {'PO7','PO8','P7','P8','POO9h','POO10h'};
FFA = {'C5','C6'};
frontotemp_exact= {'FT*'};
ft_circuit = [front,{'AF*'},frontotemp_exact];
LOT = {'T5','O1'};
ROT = {'T6','O2'};
% new = [{'AF*'},frontotemp_exact];
% (PO7, PO8, P7, P8, POO9h, POO10h)
% elecs = {'O2','OI1h','OI2h','POO10h'};
elecs = tang_et_al;%{'PO*','O*','PPO*'};
% plot_ERP_func4(elecs,grandavg_mmf,grandavg_mnf,grandavg_nnf,grandavg_nmf,'MMF','MNF','NNF','NMF','Face (Tang et. al.)','Face(tang_et_al)');
% plot_ERP_func4(elecs,grandavg_mmi,grandavg_mni,grandavg_nni,grandavg_nmi,'MMI','MNI','NNI','NMI','Inverse Face (Tang et. al.)','InFace(tang_et_al)');
% plot_ERP_func4(elecs,grandavg_mmh,grandavg_mnh,grandavg_nnh,grandavg_nmh,'MMH','MNH','NNH','NMH','House (Tang et. al.)','House(tang_et_al)');
plot_ERP_func(elecs,grandavg_mmf,grandavg_mnf,'MMF','MNF','Conventional vMMN (PO8)','Face(PO8)_Diff');
plot_ERP_func(elecs,grandavg_mmf,grandavg_nmf,'MMF','NMF','Expectation Effect (PO8)','Face(PO8)_Diff');
plot_ERP_func(elecs,grandavg_mmf,grandavg_nnf,'MMF','NNF','Repetition Effect (PO8)','Face(PO8)_Diff');

plot_ERP_func(elecs,grandavg_mmh,grandavg_mnh,'MMH','MNH','Conventional vMMN (PO8)','House(PO8)_Diff');
plot_ERP_func(elecs,grandavg_nnh,grandavg_nmh,'NNH','NMH','House (PO8)','House(PO8)_Diff');
plot_ERP_func(elecs,grandavg_mmi,grandavg_mni,'MMIF','MNIF','Conventional vMMN (PO8)','InverseFace(PO8)_Diff');
plot_ERP_func(elecs,grandavg_nni,grandavg_nmi,'NNIF','NMIF','Inverse Face (PO8)','InverseFace(PO8)_Diff');
% plot_ERP_func3('Cz',grandavg_cond1,grandavg_cond2,grandavg_cond3,'Face','Inverse Face','House','Face vs. Inverse Face vs. House (Cz)',[-3 2],'(Cz)');
% plot_ERP_func3('Fz',grandavg_cond1,grandavg_cond2,grandavg_cond3,'Face','Inverse Face','House','Face vs. Inverse Face vs. House (Fz)',[-5 1],'(Fz)');
% plot_ERP_func3('O1',grandavg_cond1,grandavg_cond2,grandavg_cond3,'Face','Inverse Face','House','Face vs. Inverse Face vs. House (O1)',[-2 7],'(O1)');
% plot_ERP_func3('O2',grandavg_cond1,grandavg_cond2,grandavg_cond3,'Face','Inverse Face','House','Face vs. Inverse Face vs. House (O2)',[-3 8], '(O2)');
% plot_ERP_func3('P8',grandavg_cond1,grandavg_cond2,grandavg_cond3,'Face','Inverse Face','House','Face vs. Inverse Face vs. House (P8)',[-3 5], '(P8)');
% plot_ERP_func3(occip_pariet,grandavg_cond1,grandavg_cond2,grandavg_cond3,'Face','Inverse Face','House','Face vs. Inverse Face vs. House (PO7, PO8, P7, P8, POO9h, POO10h)',[-3 6],'(occipit_pariet)');
%% Diffrence Wave ERPs between 2 conditions
cfg           = [];
cfg.operation = 'x2-x1';
cfg.parameter = 'avg';

difference_wave = ft_math(cfg, grandavg_mmf, grandavg_mnf);
cfg        = [];
cfg.layout = layout;
cfg.showoutline          = 'yes';
cfg.showlabels           = 'yes';
figure
ft_multiplotER(cfg, difference_wave);
hold on
% title('NNF - MMF (Repetition Effect)');
title('NNF - MMF (Repetition Effect)');

% print -dpng multiplot_diff.png
%%
cfg           = [];
cfg.operation = 'x2-x1';
cfg.parameter = 'avg';

difference_wave = ft_math(cfg, grandavg_mmh, grandavg_mnh);
% difference_wave2 = ft_math(cfg, grandavg_mmf, grandavg_mnf);
% difference_wave = ft_math(cfg, difference_wave1, difference_wave2);

cfg              = [];
cfg.layout       = layout;
cfg.xlim         = [0.55 0.6]; % [0.26 0.32] seconds
cfg.zlim         = [-1.5 1.5]; % Volts
cfg.colorbar     = 'yes';
cfg.colormap = 'jet';%'*RdBu';
cfg.colorbartext =  'Electric Potential Difference (uV)';

figure
ft_topoplotER(cfg, difference_wave);
title('Conventional vMMN: 0.55-0.6 sec')

% print -dpng MMN.png
% %% plot the ERP time-course as a movie
% figure
% 
% cfg        = [];
% cfg.layout = layout;
% cfg.colormap = '*RdBu';
% cfg.zlim = [-3 3];% universal_value for all face conditions and subjects = [-3 3], house = []
% cfg.baseline = [-0.2 0];
% cfg.baselinetype = 'absolute';
% 
% ft_movieplotER(cfg, grandavg_cond2);
%% multiple ERP topo plots
cfg           = [];
cfg.operation = 'x2-x1';
cfg.parameter = 'avg';

% difference_wave1 = ft_math(cfg, grandavg_nnf, grandavg_mnf);
% difference_wave2 = ft_math(cfg, grandavg_mmf, grandavg_mnf);
% difference_wave = ft_math(cfg, difference_wave1, difference_wave2);

difference_wave = ft_math(cfg, grandavg_mmf, grandavg_mnf);
cfg = [];
cfg.xlim = [-0.2:0.05:0.6];
% cfg.ylim = [15 20];
cfg.zlim = [-1 1]; % universal_value for all face conditions and subjects = [-3 3], house = [-6 6]
% cfg.baseline = [-0.2 0];
% cfg.baselinetype = 'absolute';
cfg.layout = layout;
cfg.comment = 'xlim';
cfg.colormap = 'jet';%'*RdBu';
cfg.commentpos = 'title';
% cfg.highlight = 'on';
% cfg.highlightchannel = find(stat_bonferroni.prob<0.05);
figure; 
ft_topoplotTFR(cfg,difference_wave);%difference_wave
colorbar;
hold on
% sgtitle('Unexpected - Expected (Face)')
sgtitle('vMMN - Expectation')% (Conventional vMMN) (Expectation Effect) (Repetition Effect)
%%

mmf_after = grandavg_mmf;

mmf_after.avg = movmean(mmf_after.avg,12,2);
cfg           = [];
cfg.channel = 'PO8';
ft_singleplotER(cfg, grandavg_mmf,mmf_after);
