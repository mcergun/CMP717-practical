function channels = get_channels(img)
%'img' is height x width x 3 (RGB)
%'channels' is height x width x 14, with the 14 channels specified in
%sketch tokens Section 2.2.1

post_gaussian = fspecial('gaussian', [5 5], 1);

% helpful functions: I = rgbConvert(I,'luv') and imfilter
rows = size(img, 1);
cols = size(img, 2);
% pre allocate channels
channels = zeros(rows, cols, 14);


% get LUV channels
channels(:, :, 1:3) = rgbConvert(img, 'luv');

for i=1:3
    channels(:, :, i) = imfilter(channels(:, :, i), post_gaussian, 'symmetric');

img_gray = rgb2gray(img);

sigmas = [0 1.5 5];
angles = [0 pi/4 pi/2 3*pi/4];

for i=1:3
    if sigmas(i) == 0
        gauss = zeros(5, 5);
        gauss(3, 3) = 1;
    else
        gauss = fspecial('gaussian', [5 5], sigmas(i));
    end
    sobel = fspecial('sobel');
    % convolve 2 filters to apply them at once
    hx = imfilter(gauss, sobel');
    hy = imfilter(gauss, sobel);
    
    % using symmetric method to minimize boundary artifacts
    idx = imfilter(img_gray, hx, 'symmetric'); 
    idy = imfilter(img_gray, hy, 'symmetric'); 
    
    channels(:, :, i + 3) = imfilter(hypot(idx, idy), post_gaussian, 'symmetric');
    % if sigma = 0, 1.5
    if i < 3
        start_index = 7+4*(i-1);
        stop_index = 6+4*i;
        for j = start_index:stop_index
            angle = angles(j-6-4*(i-1));
            channels(:,:, j) = imfilter(hypot(idx.*cos(angle), idy.*sin(angle)), ...
                post_gaussian, 'symmetric');
        end
    end
end
end

