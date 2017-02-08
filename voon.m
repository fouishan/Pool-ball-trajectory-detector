% by ImageAnalyst
% IMPORTANT: The newsreader may break long lines into multiple lines.
% Be sure to join any long lines that got split into multiple single lines.
% These can be found by the red lines on the left side of your
% text editor, which indicate syntax errors, or else just run the
% code and it will stop at the split lines with an error.

% Clean up and initialization
clc; % Clear the command window.
close all; % Close all figures (except those of imtool.)
imtool close all; % Close all imtool figures.
clear; % Erase all existing variables.
workspace; % Make sure the workspace panel is showing.
fontSize = 15;

% Read in the color demo image.
folder = 'C:\Users\mehul\Desktop\canny (2)\canny';
baseFileName = 'c2.jpg';
fullFileName = fullfile(folder, baseFileName);
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
% Didn't find it there. Check the search path for it.
fullFileName = baseFileName; % No path this time.
if ~exist(fullFileName, 'file')
% Still didn't find it. Alert user.
errorMessage = sprintf('Error: %s does not exist.', fullFileName);
uiwait(warndlg(errorMessage));
return;
end
end
rgbImage = imread(fullFileName);
% Get the dimensions of the image. numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 3, 1);
imshow(rgbImage, []);
title('Original color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize'));

% Extract the individual red color channel.
redChannel = rgbImage(:, :, 1);
% Display the red channel image.
subplot(2, 3, 2);
imshow(redChannel, []);
title('Red Channel Image', 'FontSize', fontSize);

% Binarize it
binaryImage = redChannel < 39;
% Display the image.
subplot(2, 3, 3);
imshow(binaryImage, []);
title('Thresholded Image', 'FontSize', fontSize);

% Get rid of the top junk
se = strel('disk', 5);
binaryImage = imopen(binaryImage, se);
% Display the cleaned image.
subplot(2, 3, 4);
imshow(binaryImage, []);
title('Opened Image', 'FontSize', fontSize);

labeledImage = bwlabel(binaryImage);
measurements = regionprops(labeledImage,'Area','MajorAxisLength','MinorAxisLength');
% Find the largest blob.
allAreas = [measurements.Area];
biggestBlobIndex = find(allAreas == max(allAreas));

% Extract only the largest blob.
% Note how we use ismember() to do this.
keeperBlobsImage = ismember(labeledImage, biggestBlobIndex);

% Display the original color image.
subplot(2, 3, 5);
imshow(rgbImage, []);
hold on; % Prevent plot() from blowing away the image.
title('Original Color Image with Droplet Outlined', 'FontSize', fontSize);
% Get its boundary and overlay it over the original image.
boundaries = bwboundaries(keeperBlobsImage);
blobBoundary = boundaries{1};
plot(blobBoundary(:,2), blobBoundary(:,1), 'r-', 'LineWidth', 5);
hold off;

% Tell user the results.
message = sprintf('Major axis length = %.1f\n',measurements(biggestBlobIndex).MajorAxisLength);
message = sprintf('%sMinor axis length = %.1f\n', ...
    message, measurements(biggestBlobIndex).MinorAxisLength);
message = sprintf('%sArea = %.1f\n', ...
message, measurements(biggestBlobIndex).Area);
uiwait(msgbox(message));