function pb = detect_sketch_tokens(img, forest, feature_params)

% 'img' is a test image.
% 'forest' is the structure returned by 'forestTrain'.

% 'pb' is the probability of boundary for every pixel.

%feature_params.CR = radius of the channel-derived patches. E.g. radius of
%7 would imply 15x15 features. The other entries of feature_params are for
%calling 'compute_daisy', which you probably don't need here (unless you've
%decided to use the DAISY descriptor as an image feature, which might be a
%decent idea).

[height, width, cc] = size(img);
pb  = zeros(height, width);
num_sketch_tokens = max(forest(1).hs) - 1; %-1 for background class

% Pad the current image and then call 'channels = get_channels(cur_img)'
padded_img = im2double(imPad(img, feature_params.CR, 'symmetric'));
channels = get_channels(im2single(padded_img));
% Stack all of the image features into one matrix. This will be redundant
% (a single pixel will appear in many patches) but it will be faster than
% calling 'forestApply' for every single pixel.

[hs, ps] = forestApply(img, forest, 20, 5, 0)
fprintf('forest applied %f %f\n\n', hs, ps)
% Call 'forestApply', use the resulting probabilities to build the output
% 'pb'
