%%  run this code right after visual rejection
clc
%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
session_number = 3;
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

%% load the Visual Rejected EEG signal and save/calculated the desired variable
ev = {};
for i=1:length(EEG.event)
ev(i) = {EEG.event(i).type};
end
latency_uncorrected =  [EEG.event(find(strcmp(ev, 'boundary' ))).latency];
duration =  [EEG.event(find(strcmp(ev, 'boundary' ))).duration];

% remove rows where duration is less than 10 samples
% latency_uncorrected(find(duration<10))= [];
% duration(find(duration<10))= [];

accu_duration = cumsum(duration);
tmp = [0,accu_duration(1:end-1)];
corrected_latency = latency_uncorrected + tmp;
corrected_latency_end = corrected_latency + duration;

%% build the trigger signal (a trigger showcases the pulse-shaped visually rejected durations)
load (['trials_pulses_' num2str(session_number) '.mat']);
num_samples = length(temp_new); % EEG.pnts+ accu_duration(end); % original length
trigger_ = zeros(1,num_samples);
trigger_(int32(corrected_latency)) = 1;
trigger_(int32(corrected_latency_end)) = -1;
trigger_ = cumsum(trigger_);
%% save the trigger signal
cd('S:\Work\M.S\Thesis\Subject3_Preprocess (Jan 1st, 2024)\trig');
if isfile(['rejected_trials' num2str(session_number) '.mat'])
error('rejected_trials alraedy exist.'); 
end

% load (['trials_pulses_' num2str(session_number) '.mat']);

rejected_trials = unique(temp_new.*trigger_);
rejected_trials = rejected_trials(2:end);

save(['rejected_trials_' num2str(session_number) '.mat'], 'rejected_trials');
