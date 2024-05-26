%% Extracting Data conditions for Decoding

% number of trials per condition
cfg=[];

% Expectation (Face)
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmf') | strcmp({ft_data1.hdr.orig.event.type},'nnf'));
expected_f = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mnf') | strcmp({ft_data1.hdr.orig.event.type},'nmf'));
unexpected_f = ft_selectdata(cfg, ft_data1);

% Repeatition (Face)
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmf') | strcmp({ft_data1.hdr.orig.event.type},'nmf'));
repeat_f = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mnf') | strcmp({ft_data1.hdr.orig.event.type},'nnf'));
alternate_f = ft_selectdata(cfg, ft_data1);

% Expectation (House)
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmh') | strcmp({ft_data1.hdr.orig.event.type},'nnh'));
expected_h = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mnh') | strcmp({ft_data1.hdr.orig.event.type},'nmh'));
unexpected_h = ft_selectdata(cfg, ft_data1);

% Repeatition (House)
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmh') | strcmp({ft_data1.hdr.orig.event.type},'nmh'));
repeat_h = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mnh') | strcmp({ft_data1.hdr.orig.event.type},'nnh'));
alternate_h = ft_selectdata(cfg, ft_data1);


% Expectation (Inverse Face)
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmif') | strcmp({ft_data1.hdr.orig.event.type},'nnif'));
expected_if = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mnif') | strcmp({ft_data1.hdr.orig.event.type},'nmif'));
unexpected_if = ft_selectdata(cfg, ft_data1);

% Repeatition (Inverse Face)
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmif') | strcmp({ft_data1.hdr.orig.event.type},'nmif'));
repeat_if = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mnif') | strcmp({ft_data1.hdr.orig.event.type},'nnif'));
alternate_if = ft_selectdata(cfg, ft_data1);


% Face vs. non-Face
cfg = [];
% cfg.channel = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'nmf') | strcmp({ft_data1.hdr.orig.event.type},'mnf')| strcmp({ft_data1.hdr.orig.event.type},'mmf') | strcmp({ft_data1.hdr.orig.event.type},'nnf'));
face = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'nmh') | strcmp({ft_data1.hdr.orig.event.type},'mnh')| strcmp({ft_data1.hdr.orig.event.type},'mmh') | strcmp({ft_data1.hdr.orig.event.type},'nnh'));
house = ft_selectdata(cfg, ft_data1);

%% Call the mvpa method to decode

chnls_tang_et_al  = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};

% Repetition supression Face
titlename = 'Repetition Supression';
categories = 'Face';
mvpa_across_time(repeat_f,alternate_f,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);

% Repetition supression House
chnls  = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
mvpa_across_time(repeat_h,alternate_h,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,'House');


%% Call the mvpa method to decode across both time and channels


mvpa_across_time_space(repeat_h,alternate_h,'lda',2,'accuracy',2,'Repetition Suppression', 'House')
