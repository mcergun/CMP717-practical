clear
close all

location = 'D:\workspace\CMP717\practical1\practical1\data\BSDS500\images\medium_test\';

file_name = '196027.jpg';

img = im2double(imread(strcat(location, file_name)));

channels = get_channels(img);

figure, subplot(1, 3, 1)
imshow(channels(:, :, 4))
subplot(1, 3, 2)
imshow(channels(:, :, 5))
subplot(1, 3, 3)
imshow(channels(:, :, 6))

figure, subplot(2, 4, 1)
imshow(channels(:, :, 7))
subplot(2, 4, 2)
imshow(channels(:, :, 8))
subplot(2, 4, 3)
imshow(channels(:, :, 9))
subplot(2, 4, 4)
imshow(channels(:, :, 10))

subplot(2, 4, 5)
imshow(channels(:, :, 11))
subplot(2, 4, 6)
imshow(channels(:, :, 12))
subplot(2, 4, 7)
imshow(channels(:, :, 13))
subplot(2, 4, 8)
imshow(channels(:, :, 14))

