%% Refreshing the Workspace

close all
clear
clear global
clc

rand('seed', sum(100 * clock));
addpath('funcs', 'images', 'utils', 'images\mask')
path = pwd;
ioObj  = 0;
address = 0;
ioObj = io64;
status = io64(ioObj);
address = hex2dec('0378'); %D100
io64(ioObj, address, 0);
%% Declare Golabal Variables

repB            = 24;
repS            = 6;
imgType         = 3;
imgPerType      = 10;
imgPBlock       = 5;
randChoiceMost  = 15;
coloredPerc     = 10;
bsTime          = [];
beTime          = [];

images  = natsortfiles(deblank(string(ls("./images/"))));
images  = images(3:end);

global params

params.isFirst      = true;
params.respToBeMade = true;
params.isBlockEnd   = false;
%% Subject Information

prompt      = {'Subject Name:', 'Age:', 'Gender:', 'Demo:', 'Hand:'};
dlgtitle    = 'Subject Information';
dims        = [1 35];
answer  = inputdlg(prompt, dlgtitle, dims);
ListenChar(2);
%% Task Parameters and Constants

PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 3);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

if answer{4, 1} == '1'
    numTrls  = 20;
    realTrls = imgType * imgPBlock * (repS + repB);
    nBlock   = 1;
else
    nBlock   = 4;
    numTrls  = imgType * imgPBlock * (repS + repB);
end

for timB = 1:nBlock
    for timT = 1:numTrls
        ITI(timB, timT)     = (800 + randi(400)) / 1000;
    end
end

% Paradigm Constants

durations.pulseWidth       = .01;
durations.fixation         = 1;
durations.presentationFI   = .25;
durations.presentationSI   = .25;
durations.img2img          = .5;
durations.ITI              = ITI;
penWidthPixels             = 5;

monitorWidth    = 420;                                                      % in milimeters
monitorDistance = 650;                                                      % in milimeters

screenNumber    = 0;
resolution      = Screen('Resolution', screenNumber);
screenWidth     = resolution.width;
screenHeight    = resolution.height;
pixelDepth      = resolution.pixelSize;
screenHz        = resolution.hz;
nScreenBuffers  = 2;

% Keyboard Information

keyBoard.escapeKey = KbName('ESCAPE');
keyBoard.spaceKey  = KbName('Space');
keyBoard.leftKey   = KbName('LeftArrow');
keyBoard.rightKey  = KbName('RightArrow');
%% Psychtoolbox Initialization

[window, windowRect] = PsychImaging(...
    'OpenWindow', ...
    screenNumber, ...`
    [128 128 128] / 255, ...
    floor([0, 0, screenWidth, screenHeight] / 1), ...
    pixelDepth, ...
    nScreenBuffers, ...
    [], ...
    [], ...
    kPsychNeed32BPCFloat...
    );

ifi                = Screen('GetFlipInterval', window);
isiTimeFrames      = round(durations.fixation / ifi);
waitframes         = 1;
textcolor          = BlackIndex(window);
Screen('TextSize', window, 24);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
SetMouse(0, 0);

topPriorityLevel    = MaxPriority(window);
[xCenter, yCenter]  = RectCenter(windowRect);

fixCross = [xCenter - 2, yCenter - 10, xCenter + 2, yCenter + 10; ...
    xCenter - 10, yCenter - 2, xCenter + 10, yCenter + 2];
fixCrossColor = WhiteIndex(screenNumber) / 2 - 0.05;
fixInf.shape = fixCross;
fixInf.color = fixCrossColor;
%% Loading the Conditions

stimDir     = 'images';
stimMaskDir = 'images/mask/';
stims       = deblank(natsortfiles(string(ls(fullfile(pwd, stimDir, '*.png')))));
stimsMask   = deblank(natsortfiles(string(ls(fullfile(pwd, stimMaskDir, '*.png')))));

stimTextures         = containers.Map;
stimColoredTexturesR = containers.Map;
stimColoredTexturesG = containers.Map;
stimInfo             = containers.Map;

for stim  = 1:size(stims, 1)
    deg = 5;
    stimImg                                     = imread(stims(stim, :));
    [~, ~, stimImgMask]                         = imread(stimsMask(stim, :));
    colImageR                                   = colorize(stimImg, stimImgMask, 0);
    colImageG                                   = colorize(stimImg, stimImgMask, .5);
    imgSize                                     = size(stimImg);
    ratio                                       = imgSize(1) / imgSize(2);
    iWidth                                      = ang2pix(deg, monitorDistance, monitorWidth / screenWidth);
    iHeight                                     = ratio * iWidth;
    stimImg                                     = imresize(stimImg, [iHeight, iWidth]);
    colImageR                                   = imresize(colImageR, [iHeight, iWidth]);
    colImageG                                   = imresize(colImageG, [iHeight, iWidth]);
    stimInfo(char(stims(stim, :)))              = stimImg;
    stimTextures(char(stims(stim, :)))          = Screen('MakeTexture', window, stimImg);
    stimColoredTexturesR(char(stims(stim, :)))  = Screen('MakeTexture', window, colImageR);
    stimColoredTexturesG(char(stims(stim, :)))  = Screen('MakeTexture', window, colImageG);

end

elemSizes.faceHeight = size(stimInfo('face_1.png'), 1);
elemSizes.faceWidth  = size(stimInfo('face_1.png'), 2);

clear stimInfo stimImg
%% Creating the Condition Map

blockTypes   = ["Match", "Match", "nonMatch", "nonMatch"];
blockTypes   = blockTypes(randperm(length(blockTypes)));

order = zeros(size(blockTypes));
order(find(strcmp(blockTypes, 'nonMatch'), 2)) = 1:2;
order(find(strcmp(blockTypes, 'Match'), 2)) = 1:2;

images       = string(stimTextures.keys);
faceImages   = images(startsWith(images, "f"));
infaceImages = images(startsWith(images, "I"));
houseImages  = images(startsWith(images, "h"));

colored      = zeros(numTrls, 1);
colored(randperm(length(colored), coloredPerc / 100 * numTrls)) = 1;
colored      = num2cell(colored);

fset    = [...
    faceImages(randperm(imgPerType, imgPBlock))...
    infaceImages(randperm(imgPerType, imgPBlock))...
    houseImages(randperm(imgPerType, imgPBlock))];
sset    = setdiff(images, fset);
IDind   = choose("identical", 1:imgPBlock, 2);
sets    = {};

count   = 0;

for iBlock = 1:2:nBlock
    nIDind     = choose("nidentical", 1:imgPBlock, 2);
    count      = count + 1;
    nID{count} = nIDind;
end

for iBlock = 1:nBlock

    stimOrder = randperm(numTrls);

    switch order(iBlock)
        case 1
            img  = fset;
            sets{iBlock} = {img};
            nIDind       = nID{1};
        case 2
            img = sset;
            sets{iBlock} = {img};
            nIDind       = nID{2};
    end

    range   = 1:imgPBlock;
    IDimgs  = [];
    nIDimgs = [];

    for i = 1:imgType
        tmp     = img(range);
        IDimgs  = [IDimgs; tmp(IDind)];
        nIDimgs = [nIDimgs; tmp(nIDind)];
        range   = range + imgPBlock;
    end

    IDimgs  = IDimgs(randperm(length(IDimgs)), :);
    nIDimgs = nIDimgs(randperm(length(nIDimgs)), :);

    switch blockTypes(iBlock)
        case "Match"
            allImages = [repmat(IDimgs, [repB, 1]);...
                repmat(nIDimgs, [repS, 1])];
        case "nonMatch"
            allImages = [repmat(nIDimgs, [repB, 1]);...
                repmat(IDimgs, [repS, 1])];
    end

    block(iBlock).trialSet = struct(...
        'trialType', [],...
        'fimgName', cellstr(allImages(:, 1)),...
        'fimgTex', [],...
        'simgName', cellstr(allImages(:, 2)),...
        'simgTex', [],...
        'colored', colored,...
        'colorType', [],...
        'subResp', [],...
        'fiOn', [],...
        'siOn', [],...
        'fixOn', [],...
        'respT', [],...
        'Order', [],...
        'blockType', repmat({blockTypes(iBlock)}, [numTrls, 1])...
        );
    block(iBlock).triggers = struct(...
        'fiOn', [],...
        'siOn', [],...
        'respT', [] ...
        );

    block(iBlock).trialSet = block(iBlock).trialSet(stimOrder);

    for iTrial = 1:numTrls
        if strcmp(block(iBlock).trialSet(iTrial).fimgName, block(iBlock).trialSet(iTrial).simgName)
            block(iBlock).trialSet(iTrial).trialType = "Match";
        else
            block(iBlock).trialSet(iTrial).trialType = "nonMatch";
        end
        if block(iBlock).trialSet(iTrial).colored == 1
            fl = randsample([1 0], 1);
            switch fl
                case 0
                    block(iBlock).trialSet(iTrial).fimgTex   = stimColoredTexturesR(char(block(iBlock).trialSet(iTrial).fimgName));
                    block(iBlock).trialSet(iTrial).simgTex   = stimColoredTexturesR(char(block(iBlock).trialSet(iTrial).simgName));
                    block(iBlock).trialSet(iTrial).colorType = 'Red';
                case 1
                    block(iBlock).trialSet(iTrial).fimgTex   = stimColoredTexturesG(char(block(iBlock).trialSet(iTrial).fimgName));
                    block(iBlock).trialSet(iTrial).simgTex   = stimColoredTexturesG(char(block(iBlock).trialSet(iTrial).simgName));
                    block(iBlock).trialSet(iTrial).colorType = 'Green';
            end  
         else
             block(iBlock).trialSet(iTrial).fimgTex = stimTextures(block(iBlock).trialSet(iTrial).fimgName);
             block(iBlock).trialSet(iTrial).simgTex = stimTextures(block(iBlock).trialSet(iTrial).simgName);
        end
    end

    for iTrial = 1:numTrls
        block(iBlock).trialSet(iTrial).Order = stimOrder(iTrial);
    end
end
%% Task Body

Priority(topPriorityLevel);
timer = tic;
for iBlock = 1:nBlock

    iTrial = 0;
    params.isFirst = true;

    while iTrial < numTrls

        if params.isFirst
            Prompt_Start = "Start the Block";
            DrawFormattedText(window, char(Prompt_Start),...
                'center', 'center', BlackIndex(screenNumber) / 2);
            Screen('Flip', window);
            KbStrokeWait;
            Screen('FillRect', window, fixInf.color, fixInf.shape');
            Screen('Flip', window);
            bsTime(iBlock) = toc(timer);
            WaitSecs(durations.fixation);
            params.isFirst = false;
        end

        iTrial = iTrial + 1;   
        block = expDirs(block, iBlock, iTrial, window, durations, timer, keyBoard, fixInf, ifi, ioObj, address);

    end

    sData.Blocks(iBlock).imgSet    = cellstr(sets{iBlock}{:});
    sData.Blocks(iBlock).blockOrd  = blockTypes;
    sData.Blocks(iBlock).bsTime    = bsTime(iBlock);
    sData.Blocks(iBlock).Trials    = block(iBlock).trialSet;
    sData.Blocks(iBlock).Triggers  = block(iBlock).triggers;

    params.isBlockEnd = true;

    if params.isBlockEnd && iBlock < nBlock
        ebTime(iBlock) = toc(timer);
        params.isBlockEnd = false;
        sData.Blocks(iBlock).ebTime    = ebTime(iBlock);
    end
    if iBlock == nBlock
        ebTime(iBlock) = toc(timer);
        sData.Blocks(iBlock).ebTime    = ebTime(iBlock);
        Prompt_Start = 'Task Finished';
        DrawFormattedText(window, Prompt_Start,...
            'center', 'center', BlackIndex(screenNumber) / 2);
        Screen('Flip', window);
        WaitSecs(1);
        sca;
    end
end
Priority(0);
ListenChar(0);
sData.sInfo     = answer;
sData.Durations = durations;
%% Save Data

if ~exist(fullfile(path, 'results', answer{1, 1}), "dir")
    mkdir(fullfile(path, 'results', answer{1, 1}))
end
if answer{4, 1} == '1'
    save(fullfile(path, 'results', answer{1, 1}, [answer{1, 1}, '_demo_data.mat']))
else
    save(fullfile(path, 'results', answer{1, 1}, [answer{1, 1}, '_data.mat']), 'sData')
end

