%% Adding the reference channel's (channel 63) value to all channels as the 1st step in the re-referencing phase
var1 = EEG.data;
var1 = var1 + var1(63,:,:);
var1(63,:,:) = var1(63,:,:)/2;
EEG.data = var1;

%% Re-reference all channels to their average in EEGLAB

% var2 = ones(3,5,2);
% var2(1,:,1) = 5;
% var2(1,:,2) = 7;
% var2 = var2 + var2(1,:,:);