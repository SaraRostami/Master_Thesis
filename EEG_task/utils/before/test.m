PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 3);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);

monitorWidth    = 290;                                                      % in milimeters
monitorDistance = 270;                                                      % in milimeters

screenNumber    = 0;
resolution      = Screen('Resolution', screenNumber);
screenWidth     = resolution.width;
screenHeight    = resolution.height;
pixelDepth      = resolution.pixelSize;
screenHz        = resolution.hz;
nScreenBuffers  = 2;

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
Screen('DrawTexture', window, 36, [], [], 0);
Screen('Flip', window);
WaitSecs(1)

for iBlock = 1:2
    for iTrial = 1:315
        block = setVars(block, iBlock, iTrial, stimTextures, names, elemSizes, window);
    end
end




