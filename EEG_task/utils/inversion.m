stimDir    = "images";
faceStims  = cellstr(deblank(natsortfiles(string(ls(fullfile(pwd, stimDir, 'face*.png'))))));

invertImg(faceStims, fullfile(pwd, stimDir));