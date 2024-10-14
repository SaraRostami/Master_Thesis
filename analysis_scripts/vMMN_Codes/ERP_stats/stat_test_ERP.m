%% parametric paired t-test

cfg = [];
cfg.method      = 'triangulation';                         % try 'distance' as well
%     cfg.template    = 'ctf151_neighb.mat';                % specify type of template
cfg.layout      = layout;                % specify layout of channels
% cfg.feedback    = 'yes';                              % show a neighbour plot
neighbours      = ft_prepare_neighbours(cfg, grandavg_face); % define neighbouring channels

intervals_range = [0.1:0.05:0.55];
% intervals_range = [0.4];
for i=1:length(intervals_range)

    cfg = [];
    cfg.channel = 'all';
    cfg.neighbours  = neighbours; %%%%%%%%%%%%
    cfg.latency = [intervals_range(i) intervals_range(i)+0.05];
    latency = cfg.latency;
    cfg.avgovertime = 'yes';
    cfg.parameter = 'avg';
    cfg.method = 'montecarlo';%montecarlo analytic
    cfg.statistic = 'ft_statfun_depsamplesT';
    cfg.alpha = 0.05;
    cfg.correctm = 'no';%cluster
%     cfg.correcttail = 'prob';
    cfg.numrandomization = 'all'; 
%     cfg.minnbchan        = 2; 

    Nsub = 7;
    cfg.design(1, 1:2*Nsub) = [ones(1, Nsub) 2*ones(1, Nsub)];
    cfg.design(2, 1:2*Nsub) = [1:Nsub 1:Nsub];
    cfg.ivar = 1; % the 1st row in cfg.design contains the independent variable
    cfg.uvar = 2; % the 2nd row in cfg.design contains the subject number

    stat_bonferroni = ft_timelockstatistics(cfg, erps_nnh{:}, erps_mmh{:});% 'mnh_nnh','nmh_mmh'
    stat_bonferroni1 = ft_timelockstatistics(cfg, erps_nmh{:}, erps_mmh{:});
%     sig_values_chan_time.nmh_nnh(find(stat_bonferroni.prob<0.05 & stat_bonferroni.stat>0),i+6) = 1;
%     sig_values_chan_time.nmh_nnh(find(stat_bonferroni.prob<0.05 & stat_bonferroni.stat<0),i+6) = -1;
%     sig_values_chan_time.mnf_nnf(stat_bonferroni.mask,i+6)=1;
    test_nnh_mmh2(stat_bonferroni.mask,i+6)=1;
%     test_nmh_mmh(stat_bonferroni1.mask,i+6)=1;

    % plot uncorrected "significant" channels
    cfg = [];
    cfg.operation = 'subtract';
    cfg.parameter = 'avg';
    grandavg_effect = ft_math(cfg, grandavg_mnh, grandavg_mmh);
    
%     cfg = [];
%     cfg.layout = layout;
%     cfg.colorgroups = 1:126;
%     cfg.linecolor = ones(126, 3) * 0.2; % light grey
%     cfg.linecolor(find(stat_bonferroni.prob<0.05 & stat_bonferroni.stat>0), 1) = 1; % red -> positive 
%     cfg.linecolor(find(stat_bonferroni.prob<0.05 & stat_bonferroni.stat<0), 3) = 1; % blue -> negative
%     % cfg.linecolor(find(h), 3) = 0;
% 
%     cfg.comment = 'no';
%     cfg.showoutline          = 'yes';
%     cfg.showlabels           = 'yes';
%     figure; ft_multiplotER(cfg, grandavg_effect)
%     title(sprintf('NMH - NNH: significant with Bonferroni Correction (time: %s-%s sec)',string(latency)))
%     saveas(gcf,sprintf('nmh_nnh_t_test(%s_%s).png',string(latency(1)), string(latency(2))));

%     cfg              = [];
%     cfg.layout       = layout;
%     cfg.xlim         = latency; % seconds
%     cfg.zlim         = [-1.5 1.5]; % Volts
%     cfg.colorbar     = 'yes';
%     cfg.colormap = 'jet';%'*RdBu';
%     cfg.colorbartext =  'Electric Potential Difference (uV)';
%     cfg.highlight = 'on';
% %     cfg.showlabels           = 'yes';
%     cfg.highlightchannel = find(stat_bonferroni.mask & stat_bonferroni1.mask);
%     figure
%     ft_topoplotER(cfg, grandavg_effect);
% %     title('Mismatch Negativity (MMN)')
%     title(sprintf('vMMN Expectation Effect (House): [%s, %s] sec',string(latency)))%
end
%%
test_nnh_mmh = zeros(126,16);
test_nnh_mmh2 = zeros(126,16);
test_nmh_mmh = zeros(126,16);
%% 
sig_values_chan_time = struct();
sig_values_chan_time.chan_label = grandavg_face.label;%
% groups1 = {'mnf_mmf', 'mni_mmi', 'mnh_mmh','nmf_nnf', 'nmi_nni', 'nmh_nnh','mnf_nnf','nmf_mmf','mni_nni','nmi_mmi','mnh_nnh','nmh_mmh','face_house','inface_face','inface_house'};
groups1 = {'mnf_mmf','mnf_nnf','mnf_nmf','mni_mmi','mni_nni','mni_nmi','mnh_mmh','mnh_nnh','mnh_nmh'};
for i = 1:length(groups1)
    eval(sprintf('sig_values_chan_time.%s = zeros(126,16);', groups1{i}));
end

sig_values_chan_time2 = struct();
sig_values_chan_time2.chan_label = grandavg_face.label;%
% groups1 = {'mnf_mmf', 'mni_mmi', 'mnh_mmh','nmf_nnf', 'nmi_nni', 'nmh_nnh','mnf_nnf','nmf_mmf','mni_nni','nmi_mmi','mnh_nnh','nmh_mmh','face_house','inface_face','inface_house'};
groups1 = {'mnf_mmf','mnf_nnf','mnf_nmf','mni_mmi','mni_nni','mni_nmi','mnh_mmh','mnh_nnh','mnh_nmh'};
for i = 1:length(groups1)
    eval(sprintf('sig_values_chan_time2.%s = zeros(126,200);', groups1{i}));
end
%%

%% transfer 16 intervals of significance into 200 timepoints
intervals_range = [0.1:0.05:0.6];
for i = 1:length(groups1)
    for j=1:length(intervals_range)-1
        timesel_FIC = find(grandavg_face.time >= intervals_range(j) & grandavg_face.time <= intervals_range(j+1));
        timesel_FC  = find(grandavg_house.time >= intervals_range(j) & grandavg_house.time <= intervals_range(j+1));
        eval(sprintf('a = sig_values_chan_time.%s(:,j+6);', groups1{i}));
        for k=1:length(timesel_FIC)
            eval(sprintf('sig_values_chan_time2.%s(:,timesel_FIC(k)) = a;', groups1{i}));
        end
    end
end
%%
save('sig_ERP_permutation_uncorrected_50ms_chan_time.mat', 'sig_values_chan_time');
save('sig_ERP_permutation_uncorrected_50ms_chan_time_200.mat', 'sig_values_chan_time2');
%% wilcoxon-signed rank test without correction

intervals_range = [0.1:0.05:0.6];
for i=1:length(intervals_range)-1
    cfg = [];
    cfg.operation = 'subtract';
    cfg.parameter = 'avg';
    grandavg_effect = ft_math(cfg, grandavg_nmf, grandavg_nnf);
   
    latency = [intervals_range(i) intervals_range(i+1)];
    cfg              = [];
    cfg.layout       = layout;
    cfg.xlim         = latency; % seconds
    cfg.zlim         = [-1.5 1.5]; % Volts
    cfg.colorbar     = 'yes';
    cfg.colormap = 'jet';%'*RdBu';
    cfg.colorbartext =  'Electric Potential Difference (uV)';
    cfg.highlight = 'on';
%     cfg.showlabels           = 'yes';
    cfg.highlightchannel = find(sig_values_wilcoxon.nmf_nnf(:,i+6));
    figure
    ft_topoplotER(cfg, grandavg_effect);
%     title('Mismatch Negativity (MMN)')
    title(sprintf('NMF - NNF: Wilcoxon Test (time: %s-%s sec)',string(latency)))
end
    
%% cluster-based permutation test
cfg = [];
cfg.channel     = 'all';
cfg.neighbours  = neighbours; % defined as above
cfg.latency     = [0.1 0.6];
cfg.avgovertime = 'no';
cfg.parameter   = 'avg';
cfg.method      = 'montecarlo';
cfg.statistic   = 'ft_statfun_depsamplesT';
cfg.alpha       = 0.05;
cfg.correctm    = 'cluster';
cfg.correcttail = 'prob';
cfg.numrandomization = 'all';  % there are 10 subjects, so 2^10=1024 possible permutations
cfg.minnbchan        = 2;      % minimal number of neighbouring channels

Nsub = 7;
cfg.design(1,1:2*Nsub)  = [ones(1,Nsub) 2*ones(1,Nsub)];
cfg.design(2,1:2*Nsub)  = [1:Nsub 1:Nsub];
cfg.ivar                = 1; % the 1st row in cfg.design contains the independent variable
cfg.uvar                = 2; % the 2nd row in cfg.design contains the subject number

stat = ft_timelockstatistics(cfg, erps_mni{:}, erps_mmi{:});

% make a plot
cfg = [];
cfg.highlightsymbolseries = ['*','*','.','.','.'];
cfg.layout = layout;
cfg.contournum = 0;
cfg.markersymbol = '.';
cfg.alpha = 0.05;
cfg.parameter='stat';
cfg.zlim = [-1.5 1.5];
% cfg.colorbar     = 'yes';
% ft_colormap('jet');
ft_clusterplot(cfg, stat);
%%
sig_values_chan_time = struct();
sig_values_chan_time.chan_label = grandavg_face.label;
groups1 = {'mnf_mmf', 'mni_mmi', 'mnh_mmh','nmf_nnf', 'nmi_nni', 'nmh_nnh','face_house','inface_face','inface_house','mnf_nnf','nmf_mmf','mni_nni','nmi_mmi','mnh_nnh','nmh_mmh','nnh_mmh','mmh_nnh','nnf_mmf','mmf_nnf','nni_mmi','mmi_nni'};
for i = 1:length(groups1)
    eval(sprintf('sig_values_chan_time.%s = zeros(126,16);', groups1{i}));
end

% save('sig_ERP_t_test_50ms_chan_time2.mat', 'sig_values_chan_time');
%%
grandavg_mmf.mask = stat_bonferroni.mask; % adding mask to ERP
stat.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = erps_mmf{1}.elec;   

%%
% cfg = [];
% grandavg_mmf1 = ft_timelockgrandaverage(cfg, erps_mmf1{:});
% grandavg_mnf1 = ft_timelockgrandaverage(cfg, erps_mnf1{:});

plot_ERP_significant(stat,grandavg_nnf,grandavg_nnh,'inface','house','vMMN',1,1)

%%
sig_values_wilcoxon = struct();
sig_values_wilcoxon.chan_label = grandavg_face.label;%
% groups1 = {'mnf_mmf', 'mni_mmi', 'mnh_mmh','nmf_nnf', 'nmi_nni', 'nmh_nnh','mnf_nnf','nmf_mmf','mni_nni','nmi_mmi','mnh_nnh','nmh_mmh','face_house','inface_face','inface_house'};
% groups1 = {'mn_mm','mn_nn','mn_nm'};
for i = 1:length(groups1)
    eval(sprintf('sig_values_wilcoxon.%s = zeros(126,16);', groups1{i}));
end
%%
intervals_range = [0.1:0.05:0.6];
for i = 1:length(groups1)
    for j=1:length(intervals_range)-1
        timesel_FIC = find(grandavg_face.time >= intervals_range(j) & grandavg_face.time <= intervals_range(j+1));
        timesel_FC  = find(grandavg_house.time >= intervals_range(j) & grandavg_house.time <= intervals_range(j+1));
        eval(sprintf('a = sig_values_wilcoxon.%s(:,j+6);', groups1{i}));
%         b = [a,a,a,a,a,a,a,a,a,a,a,a,a];
        for k=1:length(timesel_FIC)
            eval(sprintf('sig_values_wilcoxon2.%s(:,timesel_FIC(k)) = a;', groups1{i}));
        end
    end
end
%% Wilcoxon signed-rank test
num = 0;
% chan = 59;
% time = [0.1 0.6]; time(1), time(2)

intervals_range = [0.1:0.05:0.6];
% intervals_range = [0.4];
for i=1:length(intervals_range)-1
    for j=1:126
        chan = j;
        % find the time points for the effect of interest in the grand average data
        timesel_FIC = find(grandavg_face.time >= intervals_range(i) & grandavg_face.time <= intervals_range(i+1));
        timesel_FC  = find(grandavg_house.time >= intervals_range(i) & grandavg_house.time <= intervals_range(i+1));

        % select the individual subject data from the time points and calculate the mean
        for isub = 1:7
            valuesFIC(isub) = mean(erps_mnh{isub}.avg(chan,timesel_FIC));
            valuesFC(isub)  = mean(erps_nmh{isub}.avg(chan,timesel_FC));
        end

        % % plot to see the effect in each subject
        % M = [valuesFIC(:) valuesFC(:)];
        % figure; plot(M', 'o-'); xlim([0.5 2.5])
        % legend({'subj1', 'subj2', 'subj3', 'subj4', 'subj5', 'subj6', ...
        %         'subj7', 'subj8', 'subj9', 'subj10'}, 'location', 'EastOutside');


        p = signrank(valuesFIC, valuesFC);
        if p<0.05
            sig_values_wilcoxon.mnh_nmh(chan,i+6) = 1;%sig_values_wilcoxon.mnf_mmf(chan,i+12) = 1;
        end
    end
end
% disp(num);
%%
% save('sig_ERP_wilcoxon_notCorrected_50ms_chan_time_200.mat', 'sig_values_wilcoxon2');
%% Beautiful plots 
plot_chan_time_sig4(sig_values_chan_time.mnf_mmf,grandavg_mnf,grandavg_mmf,'MNF - MMF (Conventional vMMN): Permutation Test');
plot_chan_time_sig4(sig_values_chan_time.mni_mmi,grandavg_mni,grandavg_mmi,'MNIF - MMIF (Conventional vMMN): Permutation Test');
plot_chan_time_sig4(sig_values_chan_time.mnh_mmh,grandavg_mnh,grandavg_mmh,'MNH - MMH (Conventional vMMN): Permutation Test');

plot_chan_time_sig4(sig_values_chan_time.mnf_nnf,grandavg_mnf,grandavg_nnf,'MNF - NNF (Expectation): Permutation Test');
plot_chan_time_sig4(sig_values_chan_time.mni_nni,grandavg_mni,grandavg_nni,'MNIF - NNIF (Expectation): Permutation Test');
plot_chan_time_sig4(sig_values_chan_time.mnh_nnh,grandavg_mnh,grandavg_nnh,'MNH - NNH (Expectation): Permutation Test');

plot_chan_time_sig4(sig_values_chan_time.mnf_nmf,grandavg_mnf,grandavg_nmf,'MNF - NMF (Repetition): Permutation Test');
plot_chan_time_sig4(sig_values_chan_time.mni_nmi,grandavg_mni,grandavg_nmi,'MNIF - NMIF (Repetition): Permutation Test');
plot_chan_time_sig4(sig_values_chan_time.mnh_nmh,grandavg_mnh,grandavg_nmh,'MNH - NMH (Repetition): Permutation Test');

% plot_chan_time_sig4(sig_values_chan_time.inface_house,grandavg_inface,grandavg_house,'InFace - House');
% plot_chan_time_sig4(sig_values_chan_time.face_house,grandavg_face,grandavg_house,'Face - House');
% plot_chan_time_sig4(sig_values_chan_time.inface_face,grandavg_inface,grandavg_face,'InFace - Face');


% plot_chan_time_sig4(sig_values_wilcoxon.nmf_mmf,grandavg_nmf,grandavg_mmf,'NMF - MMF');
% plot_chan_time_sig4(sig_values_wilcoxon.nmi_mmi,grandavg_nmi,grandavg_mmi,'NMIF - MMIF');
% plot_chan_time_sig4(sig_values_wilcoxon.nmh_mmh,grandavg_nmh,grandavg_mmh,'NMH - MMH');
%% plot only selected channels
cfg = [];
cfg.operation = 'subtract';
cfg.parameter = 'avg';
grandavg_effect_conv = ft_math(cfg, grandavg_mnh,grandavg_mmh);
grandavg_effect_rep = ft_math(cfg, grandavg_mnh,grandavg_nmh);
grandavg_effect_exp = ft_math(cfg, grandavg_mnh,grandavg_nnh);
chan_labels = grandavg_effect_conv.label;
significance_matrix = sig_values_chan_time.mnh_mmh;
actual_data = grandavg_effect.avg;
kovac_et_al={'TP9','T7','TP7','PO9','CP3','CP1','P1','P3','P7','P9','PO7', 'PO3','O1', 'Oz', 'POz','Pz','CPz','TP10','T8','TP8','PO10','CP4','CP2','P2','P4','P8','P10','PO8','PO4','O2'};temp = chan_labels(contains(chan_labels,'T')& any(significance_matrix,2))';
% block_list1 = {'C3'};
% block_list2 = {};
all_chs = chan_labels(any(significance_matrix,2) & ~ismember(chan_labels, block_list1));

temp =  chan_labels((startsWith(chan_labels,'T') & any(significance_matrix,2) & ~ismember(chan_labels, block_list2)));
occip_pariet = chan_labels((contains(chan_labels,'PO') | contains(chan_labels,'O') | startsWith(chan_labels,'P'))& any(significance_matrix,2)& ~ismember(chan_labels, block_list2));% & ~ismember(chan_labels, block_list2)
Conv_House_frontal =  chan_labels(contains(chan_labels,'F') & any(significance_matrix,2) & ~ismember(chan_labels, block_list2));
central = chan_labels(startsWith(chan_labels,'C')& any(significance_matrix,2) & ~ismember(chan_labels, block_list2));
% conv_face_temp ={'T7','TP8','TTP7h','TTP8h','TPP7h','TPP8h'};
% conv_inface_temp ={'T7','TP7','FTT7h','TTP7h','TPP7h','TPP8h'};
% conv_house_temp ={'FT8','T8','TP8','FFT9h','FFT7h','FFT8h','FFT10h','FTT7h','TPP7h','TPP8h'};
% new={'FT7','T7','FFT9h','FFT10h','FTT7h','FTT8h'};%,'TTP7h','TTP8h','TPP7h','TPP8h'};,'TP8'
selected_channels = all_chs;
plot_significance_over_time(significance_matrix, actual_data, chan_labels, selected_channels,'Repetition Effect (Central)');

%%
% chnls = {'AF7','AF3','F3','F8','AFp5','AFF5h','AFF3h','FFC3h','FFT8h','FCC3h'};%repetition house (frontal)
chnls=occip_pariet;%(~contains(Conv_House_frontal,'FC'));
new_mask =zeros(126,200);
% new_mask(:,76:113) = ones(126,38);%100-250ms 
% new_mask(:,139:163) = ones(126,25);%350-550
% new_mask = sig_values_chan_time2.mnh_nnh;
% new_mask(:,152:200) = zeros(126,49);
plot_ERP_significant(new_mask,grandavg_nnh,grandavg_mnh,'MMIF','MNIF','MNIF - MMIF',1,chnls)
