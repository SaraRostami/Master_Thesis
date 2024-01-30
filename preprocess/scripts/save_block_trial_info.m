
load('S:\Work\M.S\Thesis\Subject3_Preprocess\sub3_raw_data\sub3_metadata.mat')
%% save trials info in a file
trials = [sData.Blocks(1).Trials ; sData.Blocks(2).Trials ; sData.Blocks(3).Trials ; sData.Blocks(4).Trials];
save('trials.mat','trials');
% writetable(struct2table(trials), 'trials.csv');

%% save blocks info in a file

blocks = [sData.Blocks(1).blockOrd];
save('blocks.mat','blocks');
