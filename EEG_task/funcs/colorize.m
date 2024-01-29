function new = colorize(image, mask, color)

val = image;
raw_hsv = cat(3, zeros(size(image)), zeros(size(image)), double(val));

hue = raw_hsv(:, :, 1);
sat = raw_hsv(:, :, 2);
val = raw_hsv(:, :, 3) / 255;

mas      = mask == 255;
sat(mas) = val(mas) / 8 + 0.01;
hue      = color;

raw_hsv(:, :, 1) = hue;
raw_hsv(:, :, 2) = sat;
raw_hsv(:, :, 3) = val;

new = uint8(hsv2rgb(raw_hsv) * 255);

end


