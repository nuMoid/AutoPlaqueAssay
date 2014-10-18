clear ; close all; clc

addpath('.\lib\');
%Initialization
imagePath = '.\images\-p6.tif';
savePath = '.\output\output.xls'; 

%Load and pre-process Image
im = imread(imagePath);
im = imresize(im,[787 787]);
im2 = preprocess(im); %Pre-process the image
load trainedModel.mat; % Load trained SVM model

%Feature aquisition and prediction
location = featurePredict(im2, model); % Get the position of positive patches

% Delete overlapping windows
L = windowFusion(location);



%Plaque segmentation using Otsu
bg = plaqSeq(L,im2);

% Reject outliers
bg = outRej(im, bg);

%Output results
[number, diameter, area] = output(bg, im);

% Save data to an xls file
head = {'Number','Diameter', 'Area'};
sheet = 1;
xlswrite(savePath, head); 
xlswrite(savePath, number, sheet, 'A2');
xlswrite(savePath, diameter',sheet, 'B2');
xlswrite(savePath, area', sheet, 'C2'); 















