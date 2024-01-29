% %% Load Block Type fiele for the subject
load('S:\Work\M.S\Thesis\Subject3_Preprocess (Jan 1st, 2024)\Session3 (Yasamin)\blocks.mat')
% 
% %% Load the Trials file for the subject
% 
load('S:\Work\M.S\Thesis\Subject3_Preprocess (Jan 1st, 2024)\Session3 (Yasamin)\trials.mat')

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

%%
% labels = {};
% for i = 1:900
%     N = split(trials(i).trialType,"");
%     C = split(trials(i).fimgName,"");
% 
%     if strcmp (N(2),"M")
%          if strcmp (C(2),"f")
%              labels{i} = ["mmf"];
%          elseif strcmp (C(2),"I")
%              labels{i} = ["mmif"];
%          elseif strcmp (C(2),"h")
%              labels{i} = ["mmh"];
%          end
%     elseif strcmp (N(2),"n")
%          if strcmp (C(2),"f")
%              labels{i} = ["mnf"];
%          elseif strcmp (C(2),"I")
%              labels{i} = ["mnif"];
%          elseif strcmp (C(2),"h")
%              labels{i} = ["mnh"];
%          end
%     end
% end
% 
% for i = 901:1800
%     N = split(trials(i).trialType,"");
%     C = split(trials(i).fimgName,"");
% 
%     if strcmp (N(2),"M")
%          if strcmp (C(2),"f")
%              labels{i} = ["nmf"];
%          elseif strcmp (C(2),"I")
%              labels{i} = ["nmif"];
%          elseif strcmp (C(2),"h")
%              labels{i} = ["nmh"];
%          end
%     elseif strcmp (N(2),"n")
%          if strcmp (C(2),"f")
%              labels{i} = ["nnf"];
%          elseif strcmp (C(2),"I")
%              labels{i} = ["nnif"];
%          elseif strcmp (C(2),"h")
%              labels{i} = ["nnh"];
%          end
%     end
% end


