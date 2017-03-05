function [img_features] = ... 
    get_sketch_tokens3(train_img_dir, train_gt_dir, feature_params)

% 'img_features' is N x feature dimension. You probably want it to be
% 'single' precision to save memory. 
% 'labels' is N x 1. labels(i) = 1 implies non-boundary, labels(i) = 2
% implies boundary or sketch token 1, labels(i) = 3 implies sketch token 2,
% etc... max(labels) should be num_sketch_tokens + 1;

%feature_params.CR = radius of the channel-derived patches. E.g. radius of
%7 would imply 15x15 features. The other entries of feature_params are for
%calling 'compute_daisy', but the starter code simply has the default
%DAISY values (which do work OK).

train_imgs = dir( fullfile( train_img_dir, '*.jpg' ));
% train_gts  = dir( fullfile( train_gt_dir,  '%.mat' )); %don't need to look them up, assume they exist for every image
% num_imgs = length(train_imgs); % You don't need to sample them all while debugging.
num_imgs = 20;

num_samples = 30000;
pos_ratio   = 0.5; %The desired percentage of positive samples. 
%It's not critical that your function find exactly this many samples.

%14 channels
%3 color
%3 gradient magnitude
%4 + 4 oriented magnitudes

% Don't bother with sampling / clustering the sketch patches initially.
daisy_feature_dims = feature_params.RQ * feature_params.TQ * feature_params.HQ + feature_params.HQ;
sketch_features = zeros(num_samples, daisy_feature_dims, 'single');

%DELETE THIS PLACEHOLDER
labels = ones(num_samples,1);

% feature params 
feat_r = feature_params.CR;
daisy_r = feature_params.R;
feat_sz = 2 * feat_r + 1;

img_features = single(zeros(num_samples, feat_sz * feat_sz * 14));

for i = 1:num_imgs
    fprintf(' Sampling patches / annotations from %s\n', train_imgs(i).name);
    [cur_pathstr,cur_name,cur_ext] = fileparts(train_imgs(i).name);
    cur_img = imread(fullfile(train_img_dir, train_imgs(i).name));
    cur_gt  = zeros(size(cur_img,1), size(cur_img,2));
        
    dsy = compute_daisy(cur_img);
    
    annotation_struct  = load(fullfile(train_gt_dir, [cur_name '.mat']));
    for j = 1:length(annotation_struct.groundTruth)
        cur_gt = cur_gt + annotation_struct.groundTruth{j}.Boundaries; 
    end
    
    [pos_rows, pos_cols] = find(cur_gt);
    [neg_rows, neg_cols] = find(~cur_gt);
    
    cur_gt_sz = size(cur_gt);
    
    % Pad the current image and then call 'channels = get_channels(cur_img)'
    padded_img = im2double(imPad(cur_img, feat_r, 'symmetric'));
    channels = get_channels(im2single(padded_img));
    
    % trying to prevent possible index out of bounds for small images
    pos_samples = min(num_samples * pos_ratio, size(pos_rows, 1));
    neg_samples = min(num_samples - pos_samples, size(neg_cols, 1));
    fprintf(' Number of positive samples = %d, Number of negative samples = %d\n', ...
        pos_samples, neg_samples);
    
    % shuffle indexes to get a more meaningful patch combination     
    pos_index_shuffled = randperm(pos_samples, pos_samples);
    neg_index_shuffled = randperm(neg_samples, neg_samples);
%     imshow(cur_gt);

    for j=1:pos_samples
        cur_row = pos_rows(pos_index_shuffled(j));
        cur_col = pos_cols(pos_index_shuffled(j));
        
        % get patche s limits
        rowstop = cur_row + 2 * feat_r;
        colstop = cur_col + 2 * feat_r;
        
        % extract patch
        cur_patch = channels(cur_row : rowstop, cur_col : colstop, :);
        img_features(j, :) = ... 
            reshape(cur_patch, 1, size(img_features, 2));
    end
    
    for j=1:neg_samples
        cur_row = neg_rows(neg_index_shuffled(j));
        cur_col = neg_cols(neg_index_shuffled(j));
        
        % get patche s limits
        rowstop = cur_row + 2 * feat_r;
        colstop = cur_col + 2 * feat_r;
        
        % extract patch
        cur_patch = channels(cur_row : rowstop, cur_col : colstop, :);
        img_features(j + pos_samples, :) = ... 
            reshape(cur_patch, 1, size(img_features, 2));
    end
    
    % Fill in some of the rows of img_features. Don't worry about filling
    % in sketch_features initially.
end

% [centers, assignments] = vl_kmeans(X, K)
%  http://www.vlfeat.org/matlab/vl_kmeans.html
%   X is a d x M matrix of sampled SIFT features, where M is the number of
%    features sampled. M should be pretty large! Make sure matrix is of type
%    single to be safe. E.g. single(matrix).
%   'K' is the number of clusters desired (vocab_size)
%   'centers' is a d x K matrix of cluster centers
%   'assignments' is a 1 x M uint32 vector specifying which cluster every
%       feature was assigned to.
%
%   In project 3, we cared about the universal vocabulary specified by
%   'centers'. Here we don't. We care about 'assignments', telling us which
%   sketch tokens (and therefore which image features) correspond to the
%   same mid level boundary structure. We will keep 'centers' only for the
%   sake of visualization.

% Only cluster the Sketch Patches which have center pixel boundaries.




