function [ bg ] = plaqSeq( L, im2 )

m = length(L);
for i = 1:m
    patch_det{i} = im2(min(L{i}(:,1)):(min(L{i}(:,1))+(48+max(L{i}(:,1))-min(L{i}(:,1)))),...
        min(L{i}(:,2)):(min(L{i}(:,2))+(48+max(L{i}(:,2))-min(L{i}(:,2))))); 
    level = graythresh(patch_det{i});
    bw{i} = im2bw(patch_det{i},level);
end

% Visualization
bg = zeros(787,787);

for i = 1:m
    bg(min(L{i}(:,1)):(min(L{i}(:,1))+(48+max(L{i}(:,1))-min(L{i}(:,1)))),...
        min(L{i}(:,2)):(min(L{i}(:,2))+(48+max(L{i}(:,2))-min(L{i}(:,2)))))...
         = bw{i}; 
end

end

