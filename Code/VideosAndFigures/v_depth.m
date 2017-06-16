% Create videos to show how changes in depth and chlorophll concentration
% influence the Macbeth chart appearance.
%
% Copyright, Trisha Lian, Henryk Blasinski 2017.

close all;
clear all;
clc;

ieInit;

%% Depth

cameraDistance = 1;
depth = linspace(1,20,10); % mm
chlorophyll = 0.01;
cdom = 0.01;
smallParticleConc = 0.0;
largeParticleConc = 0.0;

[~, parentPath] = uwSimRootPath();
dataPath = fullfile(parentPath,'Results','All');
resultPath = fullfile(parentPath,'Figures');

% Create video writer
videoname = fullfile(resultPath,'depth');
vidObj = VideoWriter(videoname,'MPEG-4'); %
open(vidObj);

for i=1:length(depth)
    
    fName = sprintf('uwSim-All_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f.mat', ...
        cameraDistance, ...
        depth(i), ...
        chlorophyll, ...
        cdom, ...
        smallParticleConc, ...
        largeParticleConc);
    
    fName = fullfile(dataPath,fName);
    
    data = load(fName);
    img = oiGet(data.oi,'rgb image');
    
    fid = figure(1); clf;
    imshow(img,'Border','tight');
    text(15,20,sprintf('%2i m',round(depth(i))),'Color','red','Fontsize',20);
    
    % Write each frame to the file.
    for m=1:15 % write m frames - determines speed
        writeVideo(vidObj,getframe(fid));
    end
    
end

close(vidObj);


%% Chlorophyll

cameraDistance = 1;
depth = linspace(1,20,10); % mm
depth = depth(5);
chlorophyll = logspace(-2,1,10);
cdom = logspace(-2,1,9);
cdom = cdom(1);
smallParticleConc = 0.0;
largeParticleConc = 0.0;

% Create video writer
videoname = fullfile(resultPath,'chlorophyll');
vidObj = VideoWriter(videoname,'MPEG-4'); %
open(vidObj);

for i=1:length(chlorophyll)
    
    fName = sprintf('uwSim-All_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f.mat', ...
        cameraDistance, ...
        depth, ...
        chlorophyll(i), ...
        cdom, ...
        smallParticleConc, ...
        largeParticleConc);
    
    fName = fullfile(dataPath,fName);
    
    data = load(fName);
    img = oiGet(data.oi,'rgb image');
    
    fid = figure(1); clf;
    imshow(img,'Border','tight');
    text(15,20,sprintf('%.2f mg/m3',round(chlorophyll(i)*100)/100),'Color','red','Fontsize',20);
    
    % Write each frame to the file.
    for m=1:15 % write m frames - determines speed
        writeVideo(vidObj,getframe(fid));
    end
    
end

close(vidObj);


