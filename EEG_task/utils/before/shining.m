images = readImages("F:\BA Projects\faceMorph\images", 'png');


objStims     = deblank(string(ls("F:\BA Projects\faceMorph\images")));
for i = 3:length(objStims)
    [img, n, alpha] = imread(objStims(i));
    img = double(img);
    img(alpha == 0) = nan;
    nImg = img(:, :, 1);
    nImg(isnan(nImg)) = 0;
    nImg = uint8(nImg);
    nImg(nImg == 0) = 127;

    images{i - 2} = nImg;
    imwrite(images{i - 2}, strcat("F:\BA Projects\faceMorph\mohammadImages\SHINE Toolbox\SHINEtoolbox\SHINE_INPUT\", objStims(i)))
end


sh     = SHINE(images);



figure
for i = 1:14


    subplot(2, 7, i)
    imshow(sh{i})

end





