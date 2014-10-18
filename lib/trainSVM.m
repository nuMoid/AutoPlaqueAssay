clear ; close all; clc

nn = 50; %number of negative patches per image
np = 50; %number of postive patches per image
ni = 16; %number of images in a training set
nhe = 44; %number of negative hard examples
phe = 2; %number of positive hard examples
%% =======================Part 1:  Load patches====================

pathN = '.\train\negative\';

% Load negative patches
I = {1,nn+np+nhe+phe};
for s = 1:ni  %loop by image
    for i = 1:nn
        index = i+nn*(s-1);
        order = num2str(s);istr = num2str(i);
        filepath = [pathN order '\' istr '.png'];
        I{index} = imread(filepath);
        I{index} = imresize(I{index},[48 48]);% Resize patches to 48*48
        I{index} = rgb2gray(I{index});
        I{index} = im2single(I{index});
    end
end

%Load negative hard emaples

pathNH = '.\train\negative\hardExamples\';

for i = 1:nhe
        index = i+nn*s;
        istr = num2str(i);
        filepath = [pathNH istr '.png'];
        I{index} = imread(filepath);
        I{index} = imresize(I{index},[48 48]);
        I{index} = rgb2gray(I{index});
        I{index} = im2single(I{index});
end

%Load positive patches
pathP = '.\train\positive\';
for s = 1:ni  %loop by image
    for i = 1:np
        index = i+np*(s-1)+nn*ni+nhe;
        order = num2str(s);istr = num2str(i);
        filepath = [pathP order '\' istr '.png'];
        I{index} = imread(filepath);
        I{index} = imresize(I{index},[48 48]);
        I{index} = rgb2gray(I{index});
        I{index} = im2single(I{index});
    end
end

pathPH = '.\train\positive\hardExamples\';

for i = 1:phe
        index = i+nn*ni+nhe+np*ni;
        istr = num2str(i);
        filepath = [pathPH istr '.png'];
        I{index} = imread(filepath);
        I{index} = imresize(I{index},[48 48]);
        I{index} = rgb2gray(I{index});
        I{index} = im2single(I{index});
end



%% ================Part 2: Feature acquisition(HoG)===============

hog = {1,(np+nn)*ni+nhe+phe};
for i = 1:(np+nn)*ni+nhe+phe
    cellSize = 4;
    hog{i} = vl_hog(I{i}, cellSize); % Use vlfeat toolbox for HOG feature extraction
    hog{i} = hog{i}(:);
    hog{i} = hog{i}';
end

hogFeature = hog{1};
for i = 2:(np+nn)*ni+nhe+phe
    hogFeature = [hogFeature; hog{i}];
end

% Set up labels of training set
label = zeros(nn*ni+nhe,1);
label = label-1;
label = [label; ones(np*ni+phe,1)];

%% ================Part 3: Train classifier (linear SVM)========
% Train SVM classifier using libsvm

hogFeature = double(hogFeature);
model = svmtrain(label, hogFeature, '-t 0');
save trainedModel.mat model;
% [predict,acc,dec] = svmpredict(label, hogFeature, model);
%auc = plotroc(label, hogFeature, '-t 1 -v 10'); %plot ROC

