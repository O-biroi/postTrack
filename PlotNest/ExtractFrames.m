videos=[1:10:121];                  %Identities of videos to extract from (here one every 10)
days=[3,3,4,4,5,5,5,6,6,7,7,7,8];   %not necessarily "day" but whatever time window you used to create different nests
camdir=uigetdir;                    %select camera folder
[~,camname,~]=fileparts(camdir);    %extract name camera

maskdir=dir(fullfile(camdir,'antrax','parameters','masks','colony_C*.png')); %Look for colonies masks, it should find colony_C?.png and colony_color_map.png (the latter not used) 
%This step might not be possible with previous versions of antrax, or the
%path to the masks might be different. I'm only using the masks to crop
%correctly the Petri dish, but there are other ways to do this (see Daniel
%code)

viddir=dir(fullfile(camdir,'videos','*','*.avi'));  %List all videos in the camera
viddir = viddir(~startsWith({viddir.name}, '.'));   %Eliminate temp files

for i=1:size(viddir)                            %Extract colonies labels and video number
    name=strsplit(viddir(i).name,{'_','.'},'CollapseDelimiters',true);
    viddir(i).ID=str2double(name{6});           %Save video number
end


for vid=1:numel(videos)                         %Loop over choosen videos
    ID=find([viddir.ID]==videos(vid));          %Find video
    obj = VideoReader(fullfile(viddir(ID).folder,viddir(ID).name)); %Use videoreader to access video
    frame = read(obj,100);                      %Take 100th frame (10 seconds in)
        for col=1:(size(maskdir)-1)             %loop over colonies, -1 because there is the extra mask 'colony_color_map.png'
            
            if ~exist(fullfile(camdir,'frames',[camname,'_C',num2str(col)]),'dir') %If colony folder doesn't exist, create it
                mkdir(fullfile(camdir,'frames',[camname,'_C',num2str(col)]));
            end
            
            ImCol=frame;                                                    %take original frame
            mask=imread(fullfile(maskdir(col).folder,maskdir(col).name));   %read mask
            ImCol(mask == 0) = 0;                                           %mask original frame according to colony
            mask=mask(:,:,1);                                               %take only one level of the mask (it has 3 colors)
            okind=find(mask>0);                                             
            [ii,jj]=ind2sub(size(mask),okind);                              %take coordinates of the mask
            ymin=min(ii);ymax=max(ii);xmin=min(jj);xmax=max(jj);            %take edges of the mask
            imCropped=imcrop(ImCol,[xmin,ymin,xmax-xmin+1,ymax-ymin+1]);    %crop image according to size mask
            imwrite(im2uint16(imCropped), fullfile(camdir,'frames',[camname,'_C',num2str(col)],['video_',num2str(videos(vid)),'_day_',num2str(days(vid)),'_col_',num2str(col),'.tif'])); %save frame in the colony folder
        end
end