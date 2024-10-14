conds = {'erps_mm','erps_nn','erps_mn','erps_nm'};
subjects = [2, 3, 4, 5, 6, 9, 10];
for i = 1:length(conds)
    eval(sprintf('%s = cell(1, length(subjects));', conds{i}));
end

for i=1:length(subjects)
%     clearvars -except i subjects ft_data1 cfg;
%     clc;
    if subjects(i) == 2 || subjects(i) == 3 || subjects(i) == 5
        filename = sprintf('C:\\SaraDrive\\Work\\M.S\\Thesis\\Group_level_Analysis\\subjects_data\\channels_reordered\\final\\sub%d_final_preprocessed_new.set', subjects(i));
    else
        filename = sprintf('C:\\SaraDrive\\Work\\M.S\\Thesis\\Group_level_Analysis\\subjects_data\\channels_reordered\\final\\sub%d_final_preprocessed.set', subjects(i));
    end
    cfg = []; 
%     cfg.demean          = 'yes';
%     cfg.baselinewindow  = [-0.2 0];
    cfg.dataset = filename;
    hdr = ft_read_header(filename);
    event = ft_read_event(filename);
    ft_data1 = ft_preprocessing(cfg);
    ft_data1.hdr = hdr;
    
    % make a struct to save the data
%     erps = struct();
%     data_conditions = struct();
%     data_conditions.subjectID = sprintf('sub%d',subjects(i));
%     erps.subjectID = sprintf('sub%d',subjects(i));

    % Extracting Conditions and Calculating erps

    % mm
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mm'));
    mm = ft_selectdata(cfg, ft_data1);
    erps_mm{i} = ft_timelockanalysis(cfg, ft_data1);
    
    % nn
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nn'));
    nn = ft_selectdata(cfg, ft_data1);
    erps_nn{i} = ft_timelockanalysis(cfg, ft_data1);
    
    % mn
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mn'));
    mn = ft_selectdata(cfg, ft_data1);
    erps_mn{i} = ft_timelockanalysis(cfg, ft_data1);
    
    % nm
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nm'));
    nm = ft_selectdata(cfg, ft_data1);
    erps_nm{i} = ft_timelockanalysis(cfg, ft_data1);
    disp(sprintf('------------------------------%d---------------------------------------',subjects(i)));
end
%% Calculating grands
cfg                      = [];
cfg.channel              = 'all';
cfg.latency              = 'all';
cfg.parameter            = 'avg';
grandavg_mm        = ft_timelockgrandaverage(cfg, erps_mm{:});
grandavg_nn       = ft_timelockgrandaverage(cfg,erps_nn{:});
grandavg_mn       = ft_timelockgrandaverage(cfg, erps_mn{:});
grandavg_nm       = ft_timelockgrandaverage(cfg, erps_nm{:});
%% plot ERPs
% Plot the results
erps_mm{1, 1}.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = erps_mm{1, 1}.elec;   
layout = ft_prepare_layout(cfg);
cfg              = [];
cfg.layout       = layout;
% cfg.layout               = 'EEG1010.lay';
cfg.interactive          = 'yes';
cfg.showoutline          = 'yes';
cfg.showlabels           = 'yes';
ft_multiplotER(cfg, grandavg_mm, grandavg_mn);
hold on
title('MM vs. MN (Conventional vMMN)')
%%
cfg           = [];
cfg.operation = 'x2-x1';
cfg.parameter = 'avg';

difference_wave = ft_math(cfg, grandavg_mm, grandavg_mn);
cfg        = [];
cfg.layout = layout;
cfg.showoutline          = 'yes';
cfg.showlabels           = 'yes';
figure
ft_multiplotER(cfg, difference_wave);
hold on
title('MN - MM');
%% multiple ERP topo plots
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
sgtitle('MN - MM')
%%
intervals_range = [0.1:0.05:0.6];
% intervals_range = [0.4];
for i=1:length(intervals_range)-1
    for j=1:126
        chan = j;
        % find the time points for the effect of interest in the grand average data
        timesel_FIC = find(grandavg_mm.time >= intervals_range(i) & grandavg_mm.time <= intervals_range(i+1));
        timesel_FC  = find(grandavg_mn.time >= intervals_range(i) & grandavg_mn.time <= intervals_range(i+1));

        % select the individual subject data from the time points and calculate the mean
        for isub = 1:7
            valuesFIC(isub) = mean(erps_mn{isub}.avg(chan,timesel_FIC));
            valuesFC(isub)  = mean(erps_nm{isub}.avg(chan,timesel_FC));
        end

        % % plot to see the effect in each subject
        % M = [valuesFIC(:) valuesFC(:)];
        % figure; plot(M', 'o-'); xlim([0.5 2.5])
        % legend({'subj1', 'subj2', 'subj3', 'subj4', 'subj5', 'subj6', ...
        %         'subj7', 'subj8', 'subj9', 'subj10'}, 'location', 'EastOutside');


        p = signrank(valuesFIC, valuesFC);
        if p<0.05
            sig_values_wilcoxon.mn_nm(chan,i+6) = 1;%sig_values_wilcoxon.mnf_mmf(chan,i+12) = 1;
        end
    end
end
%%
plot_chan_time_sig4(sig_values_wilcoxon.mn_nm,grandavg_mn,grandavg_nm,'MN - NM');