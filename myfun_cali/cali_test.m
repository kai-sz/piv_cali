%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Simple iterative PIV camera calibration 
% Author: Dr. S Zheng
% Last modified: 05/21/2022
%
% As of now, the code only works for circular patterns. For checkerboard
% patterns, one essentially just have to substitute the 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;

%% Calculate & save camera matrix
% target.space:     physical spacing of individual pattern in [mm]
% target.column/.row:       the number of patterns in each column/row
% target.radius:        radius of individual calibration patterns in [px]
% target.sensitivity:       sensiticity of the circle finding algorithm,
% higher sensitivity value finds more patterns, choose between [0 1]
%
% Default images are .tif files; if other formats are used, 

path = strcat(pwd, '\circles\\');

target.spacing = 0.25;
target.column = 32;
target.row = 32;
target.radius = [7 20];
target.sensitivity = 0.78;

cali_main(path, target)

%% Dewarp image
% Load the camera parameters calculated in the previous step and dewarp the
% images..
% 
% This step is NOT needed for the calibration, but rather served as an
% example to show how to dewarp acquired images during experiments..
% 
% Note that the dewarping method relies on the 'griddata' function from MATLAB, and
% can be SLOW...

load(strcat(pwd, '//camera_cali.mat'));
mkdir('dewarped_images//');
imds = imageDatastore(path, 'FileExtensions', '.tif');

for ii = 1:length(imds.Files)
    img = readimage(imds, ii);
    imagesize = size(img);
    u0 = (imagesize(2)+1)/2; v0 = (imagesize(1)+1)/2;
    
    fprintf('Dewarping image %02d ... \n', ii);
    [unx, uny, image_undistorted] = undistortimage(img, imagesize, cam_params.k, u0, v0, 'cubic');
    [up, vp, unprojected] = unproject_image(image_undistorted, imagesize, cam_params.M, 'cubic');
    imwrite(mat2gray(unprojected), strcat(sprintf('dewarped_images//dewarped_%04d', ii), '.tif')); 
end


