function [block] = expDirs(block, iBlock, iTrial, window,...
    dur, timer, keyBoard, fixInf, ifi, ioObj, address)

Screen('DrawTexture', window, block(iBlock).trialSet(iTrial).fimgTex, [], [], 0);
Screen('Flip', window);
block(iBlock).trialSet(iTrial).fiOn = toc(timer);
block(iBlock).triggers(iTrial).fiOn = 150;
io64(ioObj, address, 150);
WaitSecs(dur.pulseWidth);
io64(ioObj, address, 0);
WaitSecs(dur.presentationFI - dur.pulseWidth);

Screen('Flip', window);
WaitSecs(dur.img2img);

Screen('DrawTexture', window, block(iBlock).trialSet(iTrial).simgTex, [], [], 0);
Screen('Flip', window);
block(iBlock).trialSet(iTrial).siOn = toc(timer);
block(iBlock).triggers(iTrial).siOn = 250;
io64(ioObj, address, 250);
WaitSecs(dur.pulseWidth);
io64(ioObj, address, 0);
WaitSecs(dur.presentationSI - dur.pulseWidth);

flag = true;
flag2 = true;
while toc(timer) - (block(iBlock).trialSet(iTrial).siOn + dur.presentationSI) < dur.ITI(iBlock, iTrial)

    Screen('FillRect', window, fixInf.color, fixInf.shape');
    Screen('Flip', window);
    if flag
        block(iBlock).trialSet(iTrial).fixOn = toc(timer);
        flag = false;
    end
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && keyCode(keyBoard.escapeKey)
        sca;
        break
    elseif keyIsDown && keyCode(keyBoard.spaceKey)
        block(iBlock).trialSet(iTrial).respT   = toc(timer);
        block(iBlock).trialSet(iTrial).subResp = 1;
        block(iBlock).triggers(iTrial).respT   = 100;
        if flag2
            io64(ioObj, address, 100);
            WaitSecs(dur.pulseWidth);
            io64(ioObj, address, 0);
            flag2 = false;
        end
    end

end

end

