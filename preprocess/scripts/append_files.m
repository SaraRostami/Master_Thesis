clc;
clear;
%%
directory_path = '.\Session3 (Yasamin)\';

filenames = ls(fullfile(directory_path, 'sub3_p_*.mat'));
appended_data = load(fullfile(directory_path,filenames(1,:)));
appended_data = appended_data.data(:,:);
for i = 2:length(filenames(:,1))
    tmp = load(fullfile(directory_path,filenames(i,:)));
    appended_data = cat(2,appended_data,tmp.data(:,:));
    clear tmp

end

trials = load(fullfile(directory_path,'trials.mat'));
trials = trials.trials;
