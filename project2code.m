% Load the image
image = imread('road.jpeg');

% Convert the image to grayscale if needed
if size(image, 3) == 3
    image = rgb2gray(image);
end

% Set threshold values (you may need to tune these values for different images)
low_threshold = 0.6;
high_threshold = 0.7;
sigma = 1.0;

% Apply the Canny edge detector
edge_map = canny_edge_detector(image, low_threshold, high_threshold, sigma);

% Display the results
imshow(edge_map);
title('Canny Edge Detection Sample');

% % Load the image
% image2 = imread('control road.jpg');
% 
% % Convert the image to grayscale if needed
% if size(image2, 3) == 3
%     image2 = rgb2gray(image2);
% end
% 
% % Apply the Canny edge detector
% edge_map = canny_edge_detector(image2, low_threshold, high_threshold, sigma);
% 
% % Display the results
% imshow(edge_map);
% title('Canny Edge Detection Control');
