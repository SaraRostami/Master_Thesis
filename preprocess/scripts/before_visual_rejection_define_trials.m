%%  run this code right before visual rejection

session_number = 3;



%%  defining trials triger
% this code works when the sampling rate is 400 Hz and the events are
% imported  in this format [ 1 1 2 2 3 3 4 4 ... 1800 1800]
% if you received error this format is incorrect

% if EEG.event(end).urevent ~= 3240
%     error ('the number of events do not match')
% end

temp = zeros(1,EEG.pnts);
for i=1:2:length(EEG.event)
temp(int32([EEG.event(i).latency]))= EEG.event(i).type;
end
temp_new = zeros(1,EEG.pnts);
for i=1:max(temp)
temp_new(1,find(temp==i)-80:find(temp==i)+560) = i;
end

% the output is temp_new which is a pulse-shape sequence

cd('S:\Work\M.S\Thesis\Subject3_Preprocess (Jan 1st, 2024)\trig');
if isfile(['trials_pulses' num2str(session_number) '.mat'])
error('trials_pulseses alraedy exist.'); 
end
save(['trials_pulses_' num2str(session_number) '.mat'], 'temp_new');