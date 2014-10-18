function [ bg ] = outRej( im, bg )
[a,b,c] = size(im);
bg = logical(bg);
% L = bwlabel(bg);
STAT = regionprops(bg, 'area','PixelIdxList');
A = [STAT.Area];
%Eliminate noise
idx_noise = find(A<50);

for i = idx_noise(1:end)
    bg(STAT(i).PixelIdxList) = 0;
end

STAT = regionprops(bg,'MajorAxisLength','MinorAxisLength','PixelIdxList','Area');

%reject the blocks whose major axis divided by minor axis is greater  
%than  1.5

MaL = [STAT.MajorAxisLength];MiL = [STAT.MinorAxisLength];
idx_imcomp = find(MaL./MiL>2);

for i = idx_imcomp(1:end)
    bg(STAT(i).PixelIdxList) = 0;
end


%Wipe out the blocks which are out of the culture dish

STAT = regionprops(bg,'Centroid','PixelIdxList','Area');
A2 = [STAT.Area];
C2 = zeros(length(A2),1);
k = 1;

for i = 1:length(A2)
    C2(i) = (STAT(i).Centroid(1)-b/2)^2+(STAT(i).Centroid(2)-a/2)^2;
    if C2(i)>((a-90)/2)^2
        idx_out(k) = i;
        k=k+1;
    end
end

for i = idx_out(1:end)
    bg(STAT(i).PixelIdxList) = 0;
end


%Wipe out the non-round blocks which are false positive results in most
%cases
STAT = regionprops(bg,'Perimeter','PixelIdxList','Area');

%reject the blocks whose 4*pi*area/perimeter^2 is less than threshold.

threshold = 0.4;
P = [STAT.Perimeter]; A = [STAT.Area];
metric = 4*pi*A./(P.^2);
idx_nonround = find(metric<threshold);

for i = idx_nonround(1:end)
    bg(STAT(i).PixelIdxList) = 0;
end

%remove the combined multiple plaques whose area is 2 times less than
%the mean area calculated from the left blocks

STAT = regionprops(bg,'PixelIdxList','Area');

A = [STAT.Area];A_mean = sum(A)/length(A);
idx_comb = find(A<A_mean/2);

for i = idx_comb(1:end)
    bg(STAT(i).PixelIdxList) = 0;
end

STAT = regionprops(bg,'PixelIdxList','Area');

A = [STAT.Area];A_mean = sum(A)/length(A);
idx_comb = find(A>2*A_mean);

for i = idx_comb(1:end)
    bg(STAT(i).PixelIdxList) = 0;
end



end

