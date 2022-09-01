clear;
background = imread('/Volumes/ulr-lab/Users/Zimai_zili7317/idol/results/idol_cam9_com/background.png');
imshow(background);
numColonies = 4;
mask = zeros([1944 2592]);

for i=1:numColonies
    e(i) = drawellipse();
    m = createMask(e(i));
    mask = mask + m;
end

figure,imshow(mask)
%%

p2 = [134 690]

p = [968 1398];
p2 = [134 690];
p3 = [2458 1674];
p4 = [0.0681689828634262,0.0401655063033104]./geometry_rscale


h = drawellipse()
plot(p4(1), p4(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2)
inROI(h, p4(1), p4(2))

geometry_rscale = 5.742642398931502E-5;
p3*geometry_rscale 



X = [1055.4967845659164,667.59967845659094];
Y = [1216.6286173633439,873.181672025723];
pdist2(X,Y,'euclidean')

