function  areaImages  = calculateArea( imgTumor, imgCentral, imgPeri, imgTemporal, info)
%this function calculates area of the regions of prostarte gland
% input : images and slice resolution information
% output : area of regions

images = {imgTumor, imgCentral, imgPeri, imgTemporal};
areaImages = [];

for i = 1:length(images)
    stats = regionprops(images{i}, 'Area'); %to get region properties
    allAreas = [stats.Area]; %to get all areas
    area = sum(allAreas); % sum up all pixels
    
    area = area * info; % pixels * spacing
    
    areaImages = [areaImages area];
    
end

