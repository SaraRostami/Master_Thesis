%% load preprocessed .set file from EEGLAB to FieldTrip
filename = 'datasets\sub3_bp_nf_ds_vr_ica_ep2_icarej_ref_bc_lbCorrect.set'; 
cfg = []; 
cfg.dataset = filename;
hdr = ft_read_header(filename);
event = ft_read_event(filename);
ft_data1 = ft_preprocessing(cfg);
ft_data1.hdr = hdr;
%% remove the ear channels
cfg = [];
cfg.channel = union(ft_data1.elec.label(1:62),ft_data1.elec.label(65:128));
ft_data1 = ft_selectdata(cfg, ft_data1);
%% Visualize time series data
% input configurations

cfg= [];
cfg.lim = 'maxmin';
cfg.viewmode = 'vertical'; %'butterfly';
cfg.comscaple = 'local';
cfg.markersymbol = '.';
cfg.markersize = 5;
cfg.linewidth = 1;
cfg.markercolor = [0 0.69 0.94];

% cfg.trl = "mmf"; %which trial to display
cfg.interactive = 'yes';
cfg.channel = 'EEG';
cfg.blocksize = 0.8; % length of data to display in seconds

ft_databrowser(cfg, ft_data1);


%% Extracting Conditions
cfg        = [];
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

% Face and House
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmf') | strcmp({ft_data1.hdr.orig.event.type},'nmf')| strcmp({ft_data1.hdr.orig.event.type},'mnf')| strcmp({ft_data1.hdr.orig.event.type},'nnf'));
face = ft_selectdata(cfg, ft_data1);
cfg.trials = find(strcmp({ft_data1.hdr.orig.event.type},'mmh') | strcmp({ft_data1.hdr.orig.event.type},'nmh')| strcmp({ft_data1.hdr.orig.event.type},'mnh')| strcmp({ft_data1.hdr.orig.event.type},'nnh'));
house = ft_selectdata(cfg, ft_data1);

%% Topoplots of ERPs

ft_data1.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = ft_data1.elec;   
layout = ft_prepare_layout(cfg);

cfg              = [];
cfg.layout       = layout;
cfg.xlim         = [0.2 0.6]; % seconds
cfg.zlim         = [-3 5]; % Volts
cfg.colorbar     = 'yes';
cfg.colorbartext =  'Electric Potential (uV)';

ft_topoplotER(cfg, face);
title('Evoked Response: Face')
print -dpng standard_aud.png

figure
ft_topoplotER(cfg, house);
title('Evoked Response: House')
print -dpng deviant_aud.png

%% Visualize ERPs (Expectation Face)

cfg         = [];
% cfg.channel = {'O1'};% , 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'P2', 'Pz'};
cfg.channel = sig_chnls;
cfg.xlim = [-0.2 0.6];
% cfg.ylim    = [-3 5]; % Volts

figure
% ft_singleplotER(cfg, erp_expected_f,erp_unexpected_f);
ft_singleplotER(cfg, shuffled_faces,shuffled_houses);

hold on
xlabel('Time (s)')
ylabel('Electric Potential (uV)')
title(sprintf('Face vs. House (pseudo-trials of 10) - channel(s): %s', 'All Channels'))%cfg.channel{:}
xline(0, 'k--')
yline(0, 'k--')
% legend({'Expected', 'Unexpected'})
legend({'Face', 'House'})


print -dpng singleplot.png
