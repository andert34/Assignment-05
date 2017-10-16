%% CEC495A
% Tymothy Anderson
% Assignment 05 - Normalized Cross Correlation

clear all; clc; close all;

%% Unkown Image
% Clean up unknown image
Igray = imread('unknown.jpg');
Imed = medfilt2(Igray,[100,100]);
Ifinal = Imed - Igray;
BW1 = Ifinal > 5;
imshow(BW1);

% Label objects
[labels,number] = bwlabel(BW1,8);
Istats = regionprops(labels,'basic','Centroid');

% Get rid of dots
Istats( [Istats.Area] < 1000 ) = [];
num1 = length(Istats);

% Make things better
Ibox = floor( [Istats.BoundingBox] );
Ibox = reshape(Ibox,[4 num1]);

% Plot bounding boxes
hold on;
for k = 1:num1
    rectangle('position',Ibox(:,k),'edgecolor','r','LineWidth',3);
end

% Make baby images
for k = 1:num1
    col1 = Ibox(1,k);
    col2 = Ibox(1,k) + Ibox(3,k);
    row1 = Ibox(2,k);
    row2 = Ibox(2,k) + Ibox(4,k);
    subImage = BW1(row1:row2, col1:col2);
    UnknownImage{k} = subImage;
    UnknownImageScaled{k} = imresize(subImage, [24,12]);
end

%% Template
% Clean up template
Igray = imread('template.jpg');
Imed = medfilt2(Igray,[100,100]);
Ifinal = Imed - Igray;
BW2 = Ifinal > 5;
imshow(BW2);

% Label objects
[labels,number] = bwlabel(BW2,8);
Istats = regionprops(labels,'basic','Centroid');

% Get rid of dots
Istats( [Istats.Area] < 1000 ) = [];
num2 = length(Istats);

% Make things better
Ibox = floor( [Istats.BoundingBox] );
Ibox = reshape(Ibox,[4 num2]);

% Make baby images
for k = 1:num2
    col1 = Ibox(1,k);
    col2 = Ibox(1,k) + Ibox(3,k);
    row1 = Ibox(2,k);
    row2 = Ibox(2,k) + Ibox(4,k);
    subImage = BW2(row1:row2, col1:col2);
    Template{k} = subImage;
    TemplateScaled{k} = imresize(subImage, [24,12]);
end

%% Cross Correlation
for k = 1:num1
    for T = 1:num2
        corr(T,k) = max(max(normxcorr2(UnknownImageScaled{k},TemplateScaled{T})));
    end
end
   [value, index] = max( corr(:,:) );
   index-1  % Print detected vector