clear

location = 'D:\workspace\CMP717\practical1\practical1\data\BSDS500\images\medium_test\';

file_name = '196027.jpg';

img = im2double(imread(strcat(location, file_name)));

img_luv = im2double(rgbConvert(img, 'luv'));

figure, imshow(img_luv(:,:,1));

dims_count = ndims(img);

gaussian_filters = zeros(3,3,2);
gaussian_filters(:,:,1) = fspecial('gaussian', [3 3], 1.5);
gaussian_filters(:,:,2) = fspecial('gaussian', [3 3], 5);

img_gradients = zeros(size(img));
% imgdxs = zeros([size(img, [1 2]) 3]);
% imgdys = zeros([size(img, [1 2]) 3]);

img_1c = im2double(rgb2gray(img));

for i=1:2
    img_filtered = imfilter(img_1c, gaussian_filters(:,:,i)); 
    imgdx = imfilter(img_filtered, [-1 0 1]);
    imgdy = imfilter(img_filtered, [-1; 0; 1]);
    img_gradients(:,:,i) = hypot(imgdx, imgdy);
    imshow(img_gradients(:,:,i))
    waitforbuttonpress;
    imshow(imgradient(img_filtered));
    waitforbuttonpress;
end

imgdx = imfilter(img_1c, [-1 0 1]);
imgdy = imfilter(img_1c, [-1; 0; 1]);
img_gradients(:,:,i) = hypot(imgdx, imgdy);
imshow(img_gradients(:,:,i))
waitforbuttonpress;

imgdx = zeros(size(img_1c), 'like', img_1c);
imgdy = zeros(size(img_1c), 'like', img_1c);
imgdx(:,1:end-1) = img_1c(:,2:end) - img_1c(:,1:end-1);
imgdy(1:end-1,:) = img_1c(2:end,:) - img_1c(1:end-1,:);
img_gradients(:,:,i) = hypot(imgdx, imgdy);
imshow(img_gradients(:,:,i))
waitforbuttonpress;
imshow(imgradient(img_1c));
waitforbuttonpress;

imgdx = imfilter(img, [-1 0 1]);
imgdy = imfilter(img, [-1; 0; 1]);

% img_grad_mag = (imgdx.^2 + imgdy.^2).^(1/2);

gradient_magnitudes = (imgdx.^2 + imgdy.^2).^(1/2);

figure,
for i=1:dims_count
    subplot(2,3,i)
    imshow(imgdx(:,:,1))
    subplot(2,3,i+3)
    imshow(imgdy(:,:,1))
end

figure,
for i=1:dims_count
    subplot(1,3,i)
    imshow(im2double(gradient_magnitudes(:,:,i)))
end

% subplot(2,2,1)
% imshow(imgdx)
% subplot(2,2,2)
% imshow(imgdy)
% subplot(2,2,[3 4])
% imshow(img_grad_mag)