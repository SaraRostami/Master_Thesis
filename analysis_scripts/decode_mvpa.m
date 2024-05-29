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
occip = {'O1', 'O2', 'Oz', 'POz','POO2','POO9h','OI1h','OI2h','POO10h'};

% Face vs. House
titlename = '';
categories = 'Face vs. House';
mvpa_across_time(face,house,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);
mv_plot_result(stat.mvpa, stat.time)
%     title(sprintf('Classification %s %s (%s)',metric,titlename, categories))

% Repetition supression Face
titlename = 'Repetition Supression';
categories = 'Face';
mvpa_across_time(repeat_f,alternate_f,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);

% Repetition supression House
categories = 'House';
mvpa_across_time(repeat_h,alternate_h,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);

% Repetition supression Inverse Face
categories = 'Inverse Face';
mvpa_across_time(repeat_if,alternate_if,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);

% Expectation Face
titlename = 'Expectation';
categories = 'Face';
mvpa_across_time(expected_f,unexpected_f,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);

% Expectation House
categories = 'House';
mvpa_across_time(expected_h,unexpected_h,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);

% Expectation Inverse Face
categories = 'Inverse Face';
mvpa_across_time(expected_if,unexpected_if,chnls_tang_et_al,'lda',5,'accuracy',2,titlename,categories);
%% Call the mvpa method to decode across both time and channels

% Face vs. House
mvpa_across_time_space(face,house,'lda',5,'accuracy',2,'', 'Face vs. House');

% Repetition supression Face
mvpa_across_time_space(repeat_f,alternate_f,'lda',5,'accuracy',2,'Repetition Suppression', 'Face');

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
