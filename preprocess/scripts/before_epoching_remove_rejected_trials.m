clc
clearvars ev
%% Removing EEG.event rows filled with "boundary" event
for i=1:length(EEG.event)
    ev(i) = {EEG.event(i).type};
end
bnd_ind = find(strcmp(ev, 'boundary' ));
EEG.event(bnd_ind) = [];

%% Removing EEG.event rows filled with rejected trials (trial deleted in visual rejection)

load('S:\Work\M.S\Thesis\preprocess\files\rejected_trials_3.mat')

ev = zeros(1,length(EEG.event));
for i=length(EEG.event):-1:1
    ev(i) = str2num(EEG.event(i).type);
    if find(rejected_trials == ev(i))
        EEG.event(find(ev== ev(i))).type
        EEG.event(find(ev== ev(i))) = [];
    
    end
end
%%
%%%%%%% subjective (this is for subject 3: trial 1&2 are overlapping)
EEG.event(1:4) = [];
%% changing the second trigger name (Sec Trig + 10'000)

for i=1:length(EEG.event)
    if ~mod(i,2)
     ind_temp = str2num(EEG.event(i).type);
     EEG.event(i).type = ind_temp +10000;
    else 
      ind_temp = str2num(EEG.event(i).type);
      EEG.event(i).type = ind_temp ; 
    end
end
