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

figure, subplot(2, 4, 1)
imshow(channels2(:, :, 7))
subplot(2, 4, 2)
imshow(channels2(:, :, 8))
subplot(2, 4, 3)
imshow(channels2(:, :, 9))
subplot(2, 4, 4)
imshow(channels2(:, :, 10))

subplot(2, 4, 5)
imshow(channels2(:, :, 11))
subplot(2, 4, 6)
imshow(channels2(:, :, 12))
subplot(2, 4, 7)
imshow(channels2(:, :, 13))
subplot(2, 4, 8)
imshow(channels2(:, :, 14))

