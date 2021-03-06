%% Extract sensor RGB pixel intensities of real and simulated Macbeth chart.
% 
% This script loads the simulated underwater Macbeth chart radiance images  
% projected onto the sensor and computes the RAW sensor pixel intensities
% for each of the 24 chart patches. 
%
% We perform the same operation (i.e. sample 24 Macbeth chart patches) on a
% subset of images captured with real camera in underwater environments.
%
% Copyright, Henryk Blasinski 2017
%% Initialize and find folders for reading/writing

ieInit;

wave = 400:10:700;
[codePath, parentPath] = uwSimRootPath();

resultFolder = fullfile(parentPath,'Results','Matching');
if ~exist(resultFolder,'dir'), mkdir(resultFolder); end

%% Parameters for simulating the under water environment

cameraDistance = 1000;  % mm 

%{
depth = linspace(1,20,10)*10^3; % mm
chlorophyll = logspace(-2,1,10);
cdom = logspace(-2,1,9);
simName = 'simulatedRGB.mat';
sceneName = 'uwSim-All';
renderingsFolder = fullfile(parentPath,'Results','All');
%}

% Use the values below if you are using the data generated by All-Small
depth = linspace(1,20,10)*10^3; % mm
chlorophyll = logspace(-2,0,5);
cdom = logspace(-2,0,5);
simName = 'simulatedRGBSmall.mat';
renderingsFolder = fullfile(parentPath,'Results','All-Small');
sceneName = 'UnderwaterChart-All';

smallParticleConc = 0.0;
largeParticleConc = 0.0;

% Span the parameter space
[depthV, chlV, cdomV, spV, lpV] = ndgrid(depth, chlorophyll, cdom,...
    smallParticleConc,...
    largeParticleConc);

%% Create a Canon G7X camera model

fName = fullfile(parentPath,'Parameters','CanonG7X');
transmissivities = ieReadColorFilter(wave,fName);

sensor = sensorCreate('bayer (gbrg)');
sensor = sensorSet(sensor,'filter transmissivities',transmissivities);
sensor = sensorSet(sensor,'name','Canon G7X');
sensor = sensorSet(sensor,'noise flag',0);

%% Load simulated images

simulatedRGB = cell(1,numel(depthV));

for d = 1:numel(depthV)
    
    fprintf('Analyzing image %i/%i\n',d,numel(depthV));
    
    fName = sprintf('%s_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f_%0.2f.mat', ...
        sceneName,...
        cameraDistance/10^3, ...
        depthV(d)/10^3, ...
        chlV(d), ...
        cdomV(d), ...
        spV(d), ...
        lpV(d));
    
    oiFilePath = fullfile(renderingsFolder,fName);
    data = load(oiFilePath);
    
    % Assume the angular width of the simulated OI is 10 deg.  This is a
    % default and it has little impact on any of our computations.
    data.oi.wAngular = 10;
    
    [rgbImageSimulated, avgMacbeth] = simulateCamera(data.oi,sensor);
    simulatedRGB{d} = avgMacbeth;
    
    % If you have a lot of data you'd beter remove some 
    % oi, scene and ip files from ISET global variables.
    vcDeleteSomeObjects('sensor',1:length(vcGetObjects('sensor')));    
    vcDeleteSomeObjects('oi',1:length(vcGetObjects('oi')));
    vcDeleteSomeObjects('ip',1:length(vcGetObjects('ip')));

end

fName = fullfile(parentPath,'Results','Matching',simName);
save(fName,'simulatedRGB','depthV','chlV','cdomV','spV','lpV');

%% Load raw underwater images and sample the Macbeth chart.

% We can get all the images in a particular folder
% fNames = getFilenames(imagesFolder, 'CR2$');

% OR we manually select three images we'd like to match
fNames = {fullfile('Images','Underwater','07','IMG_4900.CR2'),...
          fullfile('Images','Underwater','12','IMG_7092.CR2'),...
          fullfile('Images','Underwater','10','IMG_6327.CR2')};
nFiles = length(fNames);

measuredRGB = cell(1,nFiles);
meta = cell(1,nFiles);

for i = 1:nFiles
    
    % Read the sensor data
    rawCameraFilePath = fullfile(parentPath,fNames{i});
    [~, imageName, ext] = fileparts(rawCameraFilePath);
    [realSensor, cp, ~, meta{i}] = readCameraImage(rawCameraFilePath, sensor);
    vcAddObject(realSensor);
    sensorWindow();
    
    % Create a default pipeline
    realIp = ipCreate;
    realIp = ipSet(realIp,'sensor conversion method','none');
    realIp = ipSet(realIp,'name',sprintf('Canon G7X: %s', imageName));
    realIp = ipCompute(realIp,realSensor);
    vcAddObject(realIp);
    ipWindow();
    
    % Pull out the macbeth data that we use from image processing
    data = macbethSelect(realSensor,1,1,cp);
    avg = cell2mat(cellfun(@meannan,data,'UniformOutput',false)');
    measuredRGB{i} = avg;
end

%%  Save the measuredRGB and related information

% These data are used for figure preparation

fName = fullfile(parentPath,'Results','Matching','measuredRGB.mat');
save(fName,'measuredRGB','imageNames','fNames','meta');

%%
