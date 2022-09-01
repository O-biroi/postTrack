clear all
Trck=trhandles('/Volumes/ulr-lab/Users/Zimai_zili7317/idol/idol_cam9')
startVideo =147;
endVideo = 242;

validate_tracking(Trck, 'ti', 1+(startVideo-1)*6000, 'tf', 6000*endVideo);