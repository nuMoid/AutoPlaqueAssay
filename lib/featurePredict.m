function [ location ] = featurePredict( im2, model)

im2 = im2single(im2);
scale = 1;
patch = {89*scale, 89*scale};
k = 1;
stride = 5*scale;
window = 48*scale;

for i = 1:stride:768-window
    for j = 1:stride:768-window
        index_column = (fix(i/stride))+1;
        index_line = (fix(j/stride))+1;
        patch{index_column,index_line} = im2(i:i+window-1,j:j+window-1,:);
        patch{index_column,index_line} = imresize(patch{index_column,index_line},[48 48]);
        cellSize = 4;
        hog_temp = vl_hog(patch{index_column,index_line}, cellSize);
        hog_temp = hog_temp(:);
        hog_temp = double(hog_temp');
        label_temp = 1;
        [predict] = svmpredict(label_temp, hog_temp, model);    % Predict
        
        if predict(1) == 1  % Record location
            location_temp{k} = [i,j];
            k = k+1;
        end
    end
end

[m,n] = size(location_temp);
location = zeros(n,2);
for i = 1:n
    location(i,:) = location_temp{i};
end

end

