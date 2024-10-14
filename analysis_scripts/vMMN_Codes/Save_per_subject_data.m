subjects = [2, 3, 4, 5, 6, 9, 10];
% subjects = [2,5];
% subjects = [2, 5];
for i=1:length(subjects)
    clearvars -except i subjects ft_data1 cfg;
    clc;
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
    erps = struct();
    data_conditions = struct();
    data_conditions.subjectID = sprintf('sub%d',subjects(i));
    erps.subjectID = sprintf('sub%d',subjects(i));

    % Extracting Conditions and Calculating erps

    % face
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nmf') | contains({ft_data1.hdr.orig.event.type},'mnf')| contains({ft_data1.hdr.orig.event.type},'mmf') | contains({ft_data1.hdr.orig.event.type},'nnf'));
    face = ft_selectdata(cfg, ft_data1);
    erps_face = ft_timelockanalysis(cfg, ft_data1);

    % inverse face
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nmi') | contains({ft_data1.hdr.orig.event.type},'mni')| contains({ft_data1.hdr.orig.event.type},'mmi') | contains({ft_data1.hdr.orig.event.type},'nni'));
    inface = ft_selectdata(cfg, ft_data1);
    erps_inface = ft_timelockanalysis(cfg, ft_data1);

    % house
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nmh') | contains({ft_data1.hdr.orig.event.type},'mnh')| contains({ft_data1.hdr.orig.event.type},'mmh') | contains({ft_data1.hdr.orig.event.type},'nnh'));
    house = ft_selectdata(cfg, ft_data1);
    erps_house = ft_timelockanalysis(cfg, ft_data1);

    % mmf
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mmf'));
    mmf = ft_selectdata(cfg, ft_data1);
    erps_mmf = ft_timelockanalysis(cfg, ft_data1);

    % mnf
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mnf'));
    mnf = ft_selectdata(cfg, ft_data1);
    erps_mnf = ft_timelockanalysis(cfg, ft_data1);

    % mmi
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mmi'));
    mmi = ft_selectdata(cfg, ft_data1);
    erps_mmi= ft_timelockanalysis(cfg, ft_data1);

    % mni
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mni'));
    mni = ft_selectdata(cfg, ft_data1);
    erps_mni = ft_timelockanalysis(cfg, ft_data1);


    % mmh
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mmh'));
    mmh = ft_selectdata(cfg, ft_data1);
    erps_mmh = ft_timelockanalysis(cfg, ft_data1);

    % mnh
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'mnh'));
    mnh = ft_selectdata(cfg, ft_data1);
    erps_mnh = ft_timelockanalysis(cfg, ft_data1);
    
    
     % nmf
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nmf'));
    nmf = ft_selectdata(cfg, ft_data1);
    erps_nmf = ft_timelockanalysis(cfg, ft_data1);

    % nnf
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nnf'));
    nnf = ft_selectdata(cfg, ft_data1);
    erps_nnf = ft_timelockanalysis(cfg, ft_data1);

    % nmi
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nmi'));
    nmi = ft_selectdata(cfg, ft_data1);
    erps_nmi= ft_timelockanalysis(cfg, ft_data1);

    % nni
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nni'));
    nni = ft_selectdata(cfg, ft_data1);
    erps_nni = ft_timelockanalysis(cfg, ft_data1);


    % nmh
    cfg = [];
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nmh'));
    nmh = ft_selectdata(cfg, ft_data1);
    erps_nmh = ft_timelockanalysis(cfg, ft_data1);

    % nnh
    cfg.trials = find(contains({ft_data1.hdr.orig.event.type},'nnh'));
    nnh = ft_selectdata(cfg, ft_data1);
    erps_nnh = ft_timelockanalysis(cfg, ft_data1);


   

    % Save data and erps in a struct (.mat file)

    data_conditions.mmf = mmf;
    data_conditions.mnf = mnf;
    data_conditions.mmi = mmi;
    data_conditions.mni = mni;
    data_conditions.mmh = mmh;
    data_conditions.mnh = mnh;

    data_conditions.nmf = nmf;
    data_conditions.nnf = nnf;
    data_conditions.nmi = nmi;
    data_conditions.nni = nni;
    data_conditions.nmh = nmh;
    data_conditions.nnh = nnh;
    
    data_conditions.face = face;
    data_conditions.inface = inface;
    data_conditions.house = house;

    
    % expected_f and expected_if have fewer data points -> we should bootstrap
    

    erps.mmf = erps_mmf;
    erps.mnf = erps_mnf;
    erps.mmi = erps_mmi;
    erps.mni = erps_mni;
    erps.mmh = erps_mmh;
    erps.mnh = erps_mnh;
    
    erps.nmf = erps_nmf;
    erps.nnf = erps_nnf;
    erps.nmi = erps_nmi;
    erps.nni = erps_nni;
    erps.nmh = erps_nmh;
    erps.nnh = erps_nnh;
    
    erps.face = erps_face;
    erps.inface = erps_inface;
    erps.house = erps_house;

    save(sprintf('sub%d_ERPs_new.mat',subjects(i)), 'erps');
    save(sprintf('sub%d_conditions_new.mat',subjects(i)), 'data_conditions','-v7.3');

end

%%

subjects = [2, 3, 4, 5, 6, 9, 10];
groups = {'mmf', 'mnf', 'mmi', 'mni', 'mmh', 'mnh', 'nmf', 'nmi', 'nmh', 'nnf', 'nni', 'nnh','face','inface','house'};

% Initialize the group cell arrays
for i = 1:length(groups)
    eval(sprintf('%s = cell(1, length(subjects));', groups{i}));
end

for i=1:length(subjects)
    load(sprintf('sub%d_ERPs_new.mat',subjects(i)));
    for j = 1:length(groups)
        groupName = groups{j};
        eval(sprintf('%s{i} = erps.%s;', groupName, groupName));
    end
end
%%
save('GrandERP_mmf.mat', 'mmf');
save('GrandERP_mnf.mat', 'mnf');
save('GrandERP_mmi.mat', 'mmi');
save('GrandERP_mni.mat', 'mni');
save('GrandERP_mmh.mat', 'mmh');
save('GrandERP_mnh.mat', 'mnh');

save('GrandERP_nmf.mat', 'nmf');
save('GrandERP_nnf.mat', 'nnf');
save('GrandERP_nmi.mat', 'nmi');
save('GrandERP_nni.mat', 'nni');
save('GrandERP_nmh.mat', 'nmh');
save('GrandERP_nnh.mat', 'nnh');


save('GrandERP_face.mat', 'face');
save('GrandERP_inface.mat', 'inface');
save('GrandERP_house.mat', 'house');