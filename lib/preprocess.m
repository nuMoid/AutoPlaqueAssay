function [ im2 ] = preprocess( im )

im2 = imresize(im,[787 787]);
im2 = rgb2gray(im2);
im2 = wiener2(im2,[6 6]); % Wiener filtering
end

