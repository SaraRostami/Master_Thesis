path = "F:\BA Projects\faceMorph\images";
images = natsortfiles(deblank(string(ls(path))));
images = images(3:end);




for i = 1:length(images)

    freq = extractBefore(images(i), "_");
    lev  = extractAfter(extractBetween(images(i), '_', '.'), '_');
    newName = strcat(freq, '_', "MahGol_", lev, ".png");

    if extractBetween(images(i), '_', '_') == "FarMah"

        movefile(fullfile(path, images(i)), fullfile(path, newName));
        
    end



end