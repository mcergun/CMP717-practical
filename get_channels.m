function channels = get_channels(img)
%'img' is height x width x 3 (RGB)
%'channels' is height x width x 14, with the 14 channels specified in
%sketch tokens Section 2.2.1

% helpful functions: I = rgbConvert(I,'luv') and imfilter
rows = size(img, 1);
cols = size(img, 2);
% pre allocate channels
channels = zeros(rows, cols, 9); 

% get LUV channels
channels(:, :, 1:3) = rgbConvert(img, 'luv');

img_gray = rgb2gray(img);

sigmas = [0 1.5 5];

for i=1:3
    if sigmas(i) == 0
        gauss = zeros(5, 5);
        gauss(3, 3) = 1;
    else
        gauss = fspecial('gaussian', [5 5], sigmas(i));
    end
    sobel = fspecial('sobel');
    % convolve 2 filters to apply them filters at once
    hx = imfilter(gauss, sobel');
    hy = imfilter(gauss, sobel);
    
    % using symmetric method to minimize boundary artifacts
    idx = imfilter(img_gray, hx, 'symmetric'); 
    idy = imfilter(img_gray, hy, 'symmetric'); 
    
    channels(:, :, i + 3) = hypot(idx, idy);
end
end