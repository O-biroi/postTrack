% run it section by section
clear;
%% read parameters
parameters.rootPath ='/Volumes/Zim_Private/idol'; %Macbook
parameters.camera = 'cam10';
parameters.folderpath= strcat(parameters.rootPath,'/idol_',parameters.camera, '_com');
parameters.background = imread(strcat(parameters.folderPath,'/background.png'));
parameters.numColoniesPerCam = 4;
parameters.geometryRscale = 0.0000595382896799795; % change for every folder
parameters.numOfAnts = 10;
files=dir(fullfile(parameters.folderPath,'*.mat')); %find all the mat files
files = files(~startsWith({files.name}, '.'));
files = files(startsWith({files.name}, 'xy'));

%% make ellipse (interactive, do not close the image window)
imshow(parameters.background);
for i=1:parameters.numColoniesPerCam
   e(i) = drawellipse();
end
%% making mask
mask = zeros(1944,2592);
for i=1:parameters.numColoniesPerCam
 m = createMask(e(i));
    mask = mask + m;
end
maskImage = figure,imshow(mask);
%% modify xy into pixels
for colony = 1:parameters.numColoniesPerCam
    xyCamera{1,colony} = load(fullfile(files(colony,:).folder,files(colony,:).name)).xy;
end
xyCam = cell2mat(xyCamera);
%% covert xy into pixels
% xy = load(fullfile(files(1,:).folder,files(1,:).name)).xy;
xyCamInPixel = round(xyCam ./ parameters.geometryRscale);
frames = size(xyCamInPixel, 1);
inNest = zeros(frames, parameters.numOfAnts);

%% product in Nest file
for i = 1:frames
    for j = 1:parameters.numOfAnts*parameters.numColoniesPerCam
        if isnan(xyCamInPixel(i,j*2-1))
            inNest(i,j) = nan;
        else
            inNest(i,j) = mask(xyCamInPixel(i,j*2), xyCamInPixel(i,j*2-1)); % pay attention x y change sequence
        end
    end
end
%% save files 
save(strcat(parameters.rootPath, '/all/nestMask/nestMask_',parameters.camera,'.mat'), 'mask');
save(strcat(parameters.rootPath, '/all/inNest/inNest_',parameters.camera,'.mat'), 'inNest');

%plot(p4(1), p4(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2)
%pdist2(X,Y,'euclidean')

