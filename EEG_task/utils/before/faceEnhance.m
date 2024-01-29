sca
close all
clear
clear global
clc

addpath('F:\MS Projects\Ongoing\rsexFace\dataSet\houseStimuli\houseMask')
path = pwd;
savePath = "F:\MS Projects\Ongoing\rsexFace\dataSet\houseStimuli\houseBgGray";

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 3);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

screenNumber    = 0;
resolution      = Screen('Resolution', screenNumber);
screenWidth     = resolution.width;
screenHeight    = resolution.height;
pixelDepth      = resolution.pixelSize;
screenHz        = resolution.hz;
nScreenBuffers  = 2;

houseStims     = deblank(string(ls('F:\MS Projects\Ongoing\rsexFace\dataSet\houseStimuli\houseMask')));

% [window, windowRect] = PsychImaging(...
%     'OpenWindow', ...
%     0, ...`
%     [127 127 127] / 255, ...
%     floor([0, 0, screenWidth, screenHeight] / 3), ...
%     pixelDepth, ...
%     nScreenBuffers, ...
%     [], ...
%     [], ...
%     kPsychNeed32BPCFloat...
%     );

for i = 3:length(houseStims)

    gray = im2gray(imread(houseStims(i)));
    [img, n, alpha] = imread(houseStims(i));
    nImg = gray;
    nImg(alpha ~= 255) = 128;

    name = replace(houseStims(i), "_mask", "");
    imwrite(nImg, fullfile(savePath, name));

%     txc = Screen('MakeTexture', window, nImg);
%     Screen('DrawTexture', window, txc, [], [], 0);
%     Screen('Flip', window);
% 
%     WaitSecs(1)
    
end

% sca;



