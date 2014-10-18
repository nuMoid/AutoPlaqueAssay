function [ L ] = windowFusion( location )

j = 1;
while ~isempty(location)
k = 2;index = 1;L{j} = location(1,:);[m,n] = size(location);
    for i = 2:m
        if (48-abs(location(i,1)-location(1,1)))^2/(48*48) >= 0.6 & abs(location(i,1)-location(1,1))<48 & abs(location(i,2)-location(1,2))<48
            L{j}(k,:) = location(i,:);
            index(k,:) = i;
            k = k+1;
        end
    end
    location(index,:) = []; j = j+1;
end

end

