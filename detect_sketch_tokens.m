function pb = detect_sketch_tokens(img, forest, feature_params)


% 'img' is a test image.
% 'forest' is the structure returned by 'forestTrain'.

% 'pb' is the probability of boundary for every pixel.

%feature_params.CR = radius of the channel-derived patches. E.g. radius of
%7 would imply 15x15 features. The other entries of feature_params are for
%calling 'compute_daisy', which you probably don't need here (unless you've
%decided to use the DAISY descriptor as an image feature, which might be a
%decent idea).

% feature params 
feat_r = feature_params.CR;
daisy_r = feature_params.R;
feat_sz = 2 * feat_r + 1;

[height, width, cc] = size(img);
pb = zeros(height, width);
num_sketch_tokens = max(forest(1).hs) - 1; %-1 for background class

% Pad the current image and then call 'channels = get_channels(cur_img)'
img_padded = im2single(imPad(img, feat_r, 'symmetric'));
channels = get_channels(img_padded);

% Stack all of the image features into one matrix. This will be redundant
% (a single pixel will appear in many patches) but it will be faster than
% calling 'forestApply' for every single pixel.

patches = zeros(width * height, feat_sz * feat_sz * 14);
for cur_row = 1:height
    row_stop = cur_row + 2 * feat_r;
    row_offset = (cur_row - 1) * width;
    for cur_col = 1:width
        col_stop = cur_col + 2 * feat_r;
        patches(row_offset + cur_col, :) = ...
            reshape(channels(cur_row:row_stop, cur_col:col_stop, :), 1, ...
            size(patches, 2));
    end
end
patches = single(patches);

% Call 'forestApply', use the resulting probabilities to build the output
% 'pb'
[hs, ps] = forestApply(patches,forest, 20, 5, 0);

% sum all probabilities together then reshape it as the image
pb = reshape(sum(ps(:,2:end),2), width, height)';
pb = imfilter(pb, fspecial('Gaussian', [5 5], 5));

pb = stToEdges(pb,1,1);