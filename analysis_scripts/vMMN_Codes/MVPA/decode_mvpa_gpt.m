% Do so by averaging time-locked data across participants
subjects = [2,3,4,5,6,9,10];

% Define the group names
groups = {'mmf', 'mnf', 'mmi', 'mni', 'mmh', 'mnh', 'nmf', 'nmi', 'nmh', 'nnf', 'nni', 'nnh', 'face', 'house', 'inface'};

% Initialize the group cell arrays
for i = 1:length(groups)
    eval(sprintf('%s = cell(1, length(subjects));', groups{i}));
end

% Load the data for each subject
for i = 1:length(subjects)
        load(sprintf('condition_data\\final\\sub%d_conditions_new.mat', subjects(i)));
        for j = 1:length(groups)
            groupName = groups{j};
            eval(sprintf('%s{i} = data_conditions.%s;', groupName, groupName));
        end
        fprintf('loaded %d: sub%d-----------------------------------',i,subjects(i));
%     end
    clearvars data_conditions data
end
%% concatenating trialed data per condition
for k = 1:length(groups)
    groupName = groups{k};
    cfg = [];
    cfg.keepsampleinfo = 'no';
    eval(sprintf('group_%s = ft_appenddata(cfg, %s{:});', groupName, groupName));
end

%% Call the mvpa method to decode

chnls_tang_et_al  = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
frontotemporal={'FP*', 'AF*', 'FT*','FFT*'};
% occip = {'O1', 'O2', 'Oz', 'POz','POO2','POO9h','OI1h','OI2h','POO10h'};
% chnls = {'P6','P8','PO8','POO10h','PPO10h','POO9h','CP4','CP6','O*'};
temporal = {'*T*'};
frontal ={'*F*'};
central={'*C*'};
occip_pariet={'P*','O*'};


% subjects = [4];
% per subject plot 
for i=1:length(subjects)
    titlename = 'MNH vs. MMH';
%     cfg = [];
%     cfg.channel = 'all'; % this is the default
%     cfg.reref = 'yes';
%     cfg.refmethod = 'avg';
%     cfg.refchannel = 'all';
%     cond1_avg = ft_preprocessing(cfg, mnf{i});
%     cond2_avg = ft_preprocessing(cfg, mmf{i});
    chnls='all';%{'FP1','FPz','FP2','AF7','AF3','AF4','F9','F1','F8','F10','AFp5','AFp1','AFF5h','AFF3h','AFF1h','AFF4h','FFT9h'};
    categories = sprintf('Sub%d : All Channels',subjects(i));
    res = mvpa_across_time(mnh{i},mmh{i},chnls,'lda',10,'accuracy',2,titlename,categories);
    eval(sprintf('sub%d.%s.all = res;', subjects(i),'mnh_mmh'));
end
%% group-level
titlename = 'MNH vs. MMH';
categories = 'All Subjects';
mvpa_across_time(mnh{1},mmh{1},occip_pariet,'lda',10,'accuracy',2,titlename,categories);
% mvpa_across_time_pseudo_trial(mnf{1},mmf{1},'all','lda',10,'accuracy',2,titlename,categories);
%%
groups1 = {'mnf_mmf', 'mni_mmi', 'mnh_mmh','mnf_nnf', 'mni_nni', 'mnh_nnh','mnf_nmf','mni_nmi','mnh_nmh','inface_face','inface_house','face_house'};
for i = 1:length(subjects)
%     eval(sprintf('sub%d = struct();', subjects(i)));
%     for j=1:length(groups1)
%         eval(sprintf('sub%d.%s = struct();', subjects(i), groups1{j}));
%     end
    save(sprintf('sub%d_mvpa_last.mat',subjects(i)), sprintf('sub%d',subjects(i)));
end

%% Call the mvpa method to decode across both time and channels
% chnls = {'FPz','AF8','F6','F8','AFp5','AFp2','AFp6','AFF2h','AFF8h','FFC6h','FFT10h','FTT8h'};
chnls={'*P*'};

mvpa_across_time_space(group_mmf,group_mnf,chnls,'lda',5,'accuracy',2,'MMF vs. MNF', 'Frontal');
%%
% Repetition supression Face
mvpa_across_time_space(group_rf,group_af,'lda',10,'accuracy',2,'Repetition Suppression', 'Face');

% Repetition supression House
mvpa_across_time_space(repeat_h,alternate_h,'lda',5,'accuracy',2,'Repetition Suppression', 'House');

% Repetition supression Inverse Face
mvpa_across_time_space(repeat_if,alternate_if,'lda',5,'accuracy',2,'Repetition Suppression', 'Inverse Face')

% Expectation Face
mvpa_across_time_space(expected_f,unexpected_f,'lda',5,'accuracy',2,'Expectation', 'Face')

% Expectation House
mvpa_across_time_space(expected_h,unexpected_h,'lda',5,'accuracy',2,'Expectation', 'House')

% Expectation Inverse Face
mvpa_across_time_space(expected_if,unexpected_if,'lda',5,'accuracy',2,'Expectation', 'Inverse Face')

%% Call the mvpa method (time x time) to check time generalization

% Face vs. House
mvpa_across_time_time(face,house,'lda',5,'accuracy',1,'', 'Face vs. House');

% Repetition supression Face
mvpa_across_time_time(repeat_f,alternate_f,'lda',5,'accuracy',2,'Repetition Suppression', 'Face');

% Repetition supression House
mvpa_across_time_time(repeat_h,alternate_h,'lda',5,'accuracy',2,'Repetition Suppression', 'House');

% Repetition supression Inverse Face
mvpa_across_time_time(repeat_if,alternate_if,'lda',5,'accuracy',2,'Repetition Suppression', 'Inverse Face')

% Expectation Face
mvpa_across_time_time(expected_f,unexpected_f,'lda',5,'accuracy',2,'Expectation', 'Face')

% Expectation House
mvpa_across_time_time(expected_h,unexpected_h,'lda',5,'accuracy',2,'Expectation', 'House')

% Expectation Inverse Face
mvpa_across_time_time(expected_if,unexpected_if,'lda',5,'accuracy',2,'Expectation', 'Inverse Face')
%% spatial decoding
% class1 = group_nnh; class2 = group_mnh;
class1 = inface{6}; class2 = house{6};%7
face{1}.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = face{1}.elec;   
layout = ft_prepare_layout(cfg);
% intervals = [0.1:0.05:0.5];
intervals = [0.15,0.2,0.3,0.4];

for k=1:length(intervals)-1
    
    interval = [intervals(k), intervals(k+1)];
    
    cfg = [] ;
    cfg.method        = 'mvpa';
    cfg.latency       = interval;
    cfg.avgovertime   = 'yes';
    cfg.neighbours  = neighbours;
    cfg.features      = 'time';
    cfg.mvpa.classifier = 'lda';
    cfg.metric = 'accuracy';
    cfg.mvpa.cv = 'kfold';
    cfg.mvpa.k = 10;
    cfg.mvpa.repeat = 2;
    cfg.design        = [ones(length(class1.trial),1); 2*ones(length(class2.trial),1)];
    stat = ft_timelockstatistics(cfg, class1,class2);

    cfg              = [];
    cfg.parameter    = 'accuracy';
    cfg.layout       = layout;
    cfg.xlim         = [0, 0];
    cfg.zlim =  [0.5 0.7];
%     cfg.colormap = '*RdBu';
    cfg.colorbar     = 'yes';
%     cfg.showlabels           = 'yes';
    ft_topoplotER(cfg, stat);
    title(sprintf('InFace vs. House ([%s, %s] seconds)',string(interval(1)),string(interval(2))));
%     saveas(gcf,sprintf('nnf_mmf_mvpa_across_time_sub3_(%s_%s).png',string(interval(1)),string(interval(2))))
end
%% stat test on mvpa

% subjects_prim = [2,3,5,6,9,10];
subjects_prim = subjects;
results = cell(7, 1);
for sub = 1:length(subjects_prim)
    eval(sprintf('results{sub} = sub%d.mnh_mmh.all;', subjects_prim(sub)));
%     eval(sprintf('results{sub+7} = sub%d.mni_nni.frontal;', subjects_prim(sub)));
end
% results{1} = sub4.mnf_nmf.occip_pariet;results{2} = sub5.mnf_nmf.occip_pariet;results{3} = sub6.mnf_nmf.occip_pariet;
% results{4} = sub4.mnf_nmf.occip_pariet;results{5} = sub5.mnf_nmf.occip_pariet;results{6} = sub6.mnf_nmf.occip_pariet;
% results{2} = sub2.mnh_mmh.central;results{4} = sub10.mnh_mmh.central;
% results{4} = sub3.mnh_nmh.central;%results{5} = sub4.mnh_nmh.temporal;
% results{3} = sub3.mni_nmi.occip_pariet;



time = group_face.time{1}(25:200);

% res = mv_select_result(results, 'accuracy');
result_average = mv_combine_results(results, 'average');
result_average.perf_std = result_average.perf_std{1}/7;


cfg = [];
cfg.metric = 'accuracy';
cfg.test = 'permutation';
% cfg.correctm = 'bonferroni'; %'cluster';'bonferroni'
cfg.correctm = 'cluster';
cfg_neighb        = [];
cfg_neighb.method = 'triangulation';%'distance';'triangulation'
neighbours        = ft_prepare_neighbours(cfg_neighb, face{1});
cfg.neighbours       = neighbours;
cfg.n_permutations = 1000;
cfg.alpha = 0.05;
cfg.design = 'within';
cfg.clustercritval  = 1.96;%0.96
cfg.statistic = 'wilcoxon';
cfg.null = 0.5;%0.5; mean(result_average.perf{1,1}(1:50))

result_average.perf{1} = result_average.perf{1}(25:200);
result_average.perf_std = result_average.perf_std(25:200);

stat = mv_statistics(cfg, results);

% result_average.perf{1} = movmean(result_average.perf{1,1},2,1);

% stat.mask(1,1:200)=zeros(1,200);
mv_plot_result(result_average,time , 'mask', stat.mask(1,25:200));
title('MNH vs. MMH (All Channels)')%Occipital-Parietal
% saveas(gcf,sprintf('mnf_nnf_mvpa_across_time_Grand_cluster1.png'))

% res = mv_select_result(results, 'accuracy');
% result_average = mv_combine_results(res, 'average');
% result_average.perf_std = result_average.perf_std{1}/sqrt(11);
% 
% cfg = []
% cfg.metric = 'accuracy';
% cfg.test = 'permutation';
% cfg.correctm = 'cluster';
% cfg.n_permutations = 1000;
% cfg.alpha = 0.05;
% cfg.design = 'within';
% cfg.statistic = 'wilcoxon';
% cfg.clustercritval  = 1.96;
% cfg.null = (1 / data.res.n_classes); % random classifier
% stat = mv_statistics(cfg, res);
% mv_plot_result(result_average, time, 'mask', stat.mask(1, :));
% 
% figHandles = findall(0,'Type','figure');
% saveas(figHandles(1), [path, char(cond_list(cond)), ...
%     '_when_acc', char(region), '.jpg']);
% saveas(figHandles(2), [path, char(cond_list(cond)), ...
%     '_when_kappa', char(region), '.jpg']);


