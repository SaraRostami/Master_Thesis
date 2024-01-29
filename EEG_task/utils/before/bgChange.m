function img = bgChange(images, color)

for im = 1:length(images)
    for rows = 1:size(images{im}, 1)


        if images{im}(rows, :) == 0
            images{im}(rows, :) = color;
        end

        for cols = 2:size(images{im}, 2)
            if images{im}(rows, cols) + images{im}(rows, cols - 1) == images{im}(rows, cols - 1) &...
                    images{im}(rows, cols) == 0 & images{im}(rows, cols - 1) ~= 0 ...
                    & images{im}(rows, cols:end) == 0
                images{im}(rows, cols) = color;
            end
        end


        for cols = 1:size(images{im}, 2) - 1
            if images{im}(rows, cols) + images{im}(rows, cols + 1) == images{im}(rows, cols + 1) &...
                    images{im}(rows, cols) == 0 & images{im}(rows, cols + 1) ~= 0 ...
                    & images{im}(rows, 1:cols) == 0
                images{im}(rows, 1:cols) = color;
            end
        end


    end
    img{im} = images{im};
end


end