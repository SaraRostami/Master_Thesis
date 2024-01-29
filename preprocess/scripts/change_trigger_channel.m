%% Extract each event (image1:150, image2: 250, and colored ones: to be removed)
trig_ch = appended_data(130,:);

img1_indices = find(trig_ch ==150);
img2_indices = find(trig_ch ==250);
colored_trials = find([trials.colored] ==1);


img1_trig = zeros(1,length(trig_ch));
img2_trig = zeros(1,length(trig_ch));


% end
%% change the 150 pulse-shaped trigger to the trial number lasting just 1 time point

trial_num = 1;

img1_trig(img1_indices(1)) =  trial_num;
trial_num = 2;

for i = 2:length(img1_indices)
    if img1_indices(i-1) +1 ~= img1_indices(i)
        if ~ismember(trial_num, colored_trials)
            img1_trig(img1_indices(i-1)) =  trial_num;
        end
            trial_num = trial_num + 1;
    end
end

%% change the 250 pulse-shaped trigger to the trial number lasting just 1 time point

trial_num = 1;

img2_trig(img2_indices(1)) =  trial_num;
trial_num = 2;

for i = 2:length(img2_indices)
    if img2_indices(i-1) +1 ~= img2_indices(i)
        if ~ismember(trial_num, colored_trials)
            img2_trig(img2_indices(i-1)) =  trial_num;
        end
            trial_num = trial_num + 1;
    end
end

%% changing the Trigger channel (channel 130) of our actual data
trig_ch = img1_trig + img2_trig;
appended_data(130,:) = trig_ch;

