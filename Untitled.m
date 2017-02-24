clear
close all

location = 'D:\workspace\CMP717\practical1\practical1\data\BSDS500\images\medium_test\';

file_name = '196027.jpg';

img = im2double(imread(strcat(location, file_name)));

channels = get_channels(img);
channels2 = get_channels2(img);

figure, subplot(2, 3, 1)
imshow(channels(:, :, 4))
subplot(2, 3, 2)
imshow(channels(:, :, 5))
subplot(2, 3, 3)
imshow(channels(:, :, 6))

subplot(2, 3, 4)
imshow(channels2(:, :, 4))
subplot(2, 3, 5)
imshow(channels2(:, :, 5))
subplot(2, 3, 6)
imshow(channels2(:, :, 6))