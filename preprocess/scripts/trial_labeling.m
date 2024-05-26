% %% Load Block Type fiele for the subject
load('\sub3_raw_data\blocks.mat')
% 
% %% Load the Trials file for the subject
% 
load('\sub3_raw_data\trials.mat')

%% Extract labels using `trials.mat' and `blocks.mat`

labels = {};
for i=1:4
    b_type = split(lower(blocks(i)),"");
for j=1:length(trials)/4
    format = "%s%s%s";
    t_type = split(lower(trials(j+450*(i-1)).trialType),"");
    s_type = split(lower(trials(j+450*(i-1)).fimgName),"");
    if strcmp(char(s_type(2)),"i")
        s = "if";
    else
        s = char(s_type(2));
    end
    labels{j+450*(i-1)} = [sprintf(format,b_type(2),t_type(2),s)];
end

end

%% Change the EEG.Event types to include block type, trial type and stimulus category
%(i.e. "mmf" -> Match block, Match trial, Face stimulus)

for i=1:length(EEG.event)
    EEG.event(i).type=labels{EEG.event(i).type - 10000};
end
