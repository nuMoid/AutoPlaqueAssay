function [number, diameter, area]  = output( bg, im )

figure
subplot(1,2,1);imshow(bg);title('Plaque Segmentation');
subplot(1,2,2);imshow(im);title('Centroids of Plaques')
hold on;
STAT = regionprops(bg,'Centroid','Area','Perimeter','MajorAxisLength','MinorAxisLength');
MaL = [STAT.MajorAxisLength];MiL = [STAT.MinorAxisLength];
diameter = (MaL+MiL)/2;
area = [STAT.Area];
number = length(area);
centroid = zeros(number,2);

%Plot centroids
for i = 1:number
    centroid(i,:) = STAT(i).Centroid;
    plot(centroid(i,1),centroid(i,2),'r+');
    hold on;
end

% fprintf('\nPlaque number: %d\n',number);
% fprintf('\nPlaque diameters: %f\n',diameter);
% fprintf('\nPlaque area: %d\n',area);

end

