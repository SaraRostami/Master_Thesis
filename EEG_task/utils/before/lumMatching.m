pathF = "F:\MS Projects\Ongoing\rsexFace\dataSet\faceStimuli\selectedFacesMask";
maskFace = natsortfiles(deblank(string(ls(pathF))));
maskFace = maskFace(3:end);

pathIF = "F:\MS Projects\Ongoing\rsexFace\dataSet\faceStimuli\selectedFacesMaskInv";
maskIF = natsortfiles(deblank(string(ls(pathIF))));
maskIF = maskIF(3:end);

pathH = "F:\MS Projects\Ongoing\rsexFace\dataSet\houseStimuli\houseMask";
maskHouse = natsortfiles(deblank(string(ls(pathH))));
maskHouse = maskHouse(3:end);

images  = natsortfiles(deblank(string(ls("F:\MS Projects\Ongoing\rsexFace\dataSet\lumMatch\input"))));
images  = images(3:end);

addpath("F:\MS Projects\Ongoing\rsexFace\dataSet\lumMatch\input", pathH, pathF, pathIF);

meanGrand = 160;
sdGrand = 15;

for i = 1:length(images)

    if startsWith(images(i), "f")
        [~, ~, alph] = imread(fullfile(pathF, maskFace(extractBetween(maskFace, "_", "_") == extractBetween(images(i), "_", "."))));
    elseif startsWith(images(i), "h")
        [~, ~, alph] = imread(fullfile(pathH, maskHouse(extractBetween(maskHouse, "_", "_") == extractBetween(images(i), "_", "."))));
    elseif startsWith(images(i), "IN")
        [~, ~, alph] = imread(fullfile(pathIF, maskIF(extractBetween(maskIF, "face_", "_") == extractBetween(images(i), "face_", "."))));
    end

    img = imread(images(i));
    img = double(img);
    img(alph ~= 255) = nan;

    meanTar = nanmean(img(:));
    sdTar   = nanstd(img(:));

    coef = sdGrand / sdTar;
    newPix = (coef * img) + meanGrand - (coef * meanTar);
    newPix = uint8(newPix);
    newPix(alph ~= 255) = 128;

    
    imwrite(newPix, fullfile('F:\MS Projects\Ongoing\rsexFace\dataSet\lumMatch\output', images(i)));
end