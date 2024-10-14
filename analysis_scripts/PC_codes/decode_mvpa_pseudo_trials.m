%% Creating Pseudo-trials

for i=1:80
    %face
%     rng(i);
    face_randomIndexes = randperm(length(face.trial), 10);
    cfg = [];
    cfg.trials = face_randomIndexes;
    face_pseudo_trial = ft_timelockanalysis(cfg, face);
    if i == 1
        shuffled_faces = face_pseudo_trial;
    else
        shuffled_faces = ft_appenddata(cfg, shuffled_faces, face_pseudo_trial);
    end
    
    %house
    house_randomIndexes = randperm(length(house.trial), 10);
    cfg = [];
    cfg.trials = house_randomIndexes;
    house_pseudo_trial = ft_timelockanalysis(cfg, house);
    if i == 1
        shuffled_houses = house_pseudo_trial;
    else
        shuffled_houses = ft_appenddata(cfg, shuffled_houses, house_pseudo_trial);
    end
    
end
%% plot pseudo-trials
figure
tcl = tiledlayout(3,3,'TileSpacing','compact');
chnls = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3'};%, 'P2', 'Pz'};
for i=1:length(chnls)
    chnl = chnls{i};
    chn_num = find(strcmp(shuffled_faces.label,chnl));
    nexttile
    plot(shuffled_faces.trial{1,1}(chn_num,:) - shuffled_houses.trial{1,1}(chn_num,:))
    axis tight
    % hold on
    % plot(shuffled_houses.trial{1,1}(chn_num,:))

    hold on
%     xlabel('Time (s)')
%     ylabel('Electric Potential (uV)')
%     title(sprintf('Face minus House (pseudo-trials of 10) - channel(s): %s', chnls{i}))
    title(sprintf('channel: %s', chnls{i}))
    xticks([0 40 80 120 160 200 240 280 320])
    xticklabels({'-0.2', '-0.1', '0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6'})
    xlim([0,320])
    ylim([-6 8])
    xline(80, 'k--')
    yline(0, 'k--')
    % legend({'Expected', 'Unexpected'})
    % legend({'Face', 'House'})
end
title(tcl, 'Face minus House (pseudo-trials of 10)')
xlabel(tcl, 'Time (s)')
ylabel(tcl, 'Electric Potential (uV)')

%% Find channels with significant difference between pseudo-trials (Face vs. House)

chnls = shuffled_faces.label;
Count = {chnls,zeros(length(chnls),1)};
for i=1:length(chnls)
    chnl = chnls{i};
    chn_num = find(strcmp(shuffled_faces.label,chnl));
    for j=1:max(length(shuffled_faces.trial),length(shuffled_houses.trial))
        x = abs(shuffled_faces.trial{1,j}(chn_num,:) - shuffled_houses.trial{1,j}(chn_num,:));
        x = sort(x(120:240));
        if mean(x) > x(ceil(length(x)/2))
            Count{1,2}(i) = Count{1,2}(i)+1;
        end
    end
end

% find those above a certain threshold
elec_indcs = find(Count{1,2}>77);
sig_chnls = chnls(elec_indcs);
%% Visualize ERPs

cfg         = [];
cfg.channel = sig_chnls;
cfg.xlim = [-0.2 0.6];
% cfg.ylim    = [-3 5]; % Volts

figure
ft_singleplotER(cfg, shuffled_faces,shuffled_houses);

hold on
xlabel('Time (s)')
ylabel('Electric Potential (uV)')
title(sprintf('Face vs. House (pseudo-trials of 10) - channel(s): %s',string(strjoin(cfg.channel))))%cfg.channel{:}
xline(0, 'k--')
yline(0, 'k--')
% legend({'Expected', 'Unexpected'})
legend({'Face', 'House'})


print -dpng singleplot.png

%% MVPA Across Time (pseudo-trials)

chnls  = {'O1', 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'Pz', 'P2'};
titlename = 'Shuffled';
categories = 'Face vs. House';
mvpa_across_time(shuffled_faces,shuffled_houses,chnls,'lda',5,'accuracy',2,titlename,categories);

%% MVPA Across Time and space(pseudo-trials)

mvpa_across_time_space(shuffled_faces,shuffled_houses,'lda',5,'accuracy',2,'Shuffled', 'Face vs. House')