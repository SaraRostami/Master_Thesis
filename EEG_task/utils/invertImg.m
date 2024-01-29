function invertImg(images, path)

for i = 1:length(images)
    img = imrotate(imread(images{i}), 180);
    imwrite(img, fullfile(path, strcat("IN_", images{i})))
end

end

