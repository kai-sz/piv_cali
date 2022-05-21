function cali_main(path, target)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Dr. S Zheng, University of Bern, Switzerland
% Last modified: 05/21/2022
%
% -- First time user need to double check the image file type and the range
% of radius [Rmin Rmax]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_row = target.row; N_column = target.column;
spacing_real = target.spacing;

r_range = target.radius;
sen = target.sensitivity;

fd = path;
ls = dir(strcat(fd, '\\*.tif'));
fignames = {ls(~[ls.isdir]).name};

cam_params.A = 0;
cam_params.R = 0;
cam_params.t = 0;
cam_params.M = 0;
cam_params.k = 0;
n = 0;

for iii = 1:min([length(fignames), 10])

[imag, map] = imread(strcat(fd, fignames{iii}));
% figure(10); imshow(imag, map); axis on;
imag_gfilt = imgaussfilt(imag, 1);
% figure(10); imshow(imag_gfilt, map); axis on;


[centers, ~] = imfindcircles(imag_gfilt, r_range, 'ObjectPolarity', 'dark',...
    'Sensitivity', sen, 'Method', 'TwoStage', 'EdgeThreshold',0.3);

if length(centers) == N_row*N_column
[image_centers ] = sortcenters(centers, N_row, N_column);
% hold on; vscatter(image_centers, 'xr')

% Generate worldpoints from calibration plate
[world_centers, ~] = worldpoints_gen(N_row, N_column, spacing_real, 0);

% Initial guess of camparameters
imagesize = size(imag);
u0 = (imagesize(1)+1)/2;
v0 = (imagesize(2)+1)/2;

H = computeHomography(image_centers, world_centers);

[fx, fy] = computef(H, u0, v0);
A = [fx, 0, u0; 0, fy, v0; 0, 0, 1];
[~, rvecs, tvecs] = computeRt(A, H);
[R] = rodrigues(rvecs);

%% First validation without distortion
M = [R(1, :); R(2, :); tvecs] * A';

impt = [world_centers ones(size(world_centers, 1), 1)] * M;
image_centers_guess = impt(:, 1:2)./ impt(:, 3);

%% Estimate k1, k2  (see Zhang 2000)
u = image_centers_guess(:,1);    v = image_centers_guess(:,2); 
cx = (u - u0)/imagesize(1);      cy = (v - v0)/imagesize(2);
r = (cx.^2+cy.^2);

D = [ (u-u0).*r, (u-u0).*r.^2;...
      (v-v0).*r, (v-v0).*r.^2];
d = [(image_centers(:,1) - u); (image_centers(:,2) - v)];
k = (D'*D)^(-1)*D'*d;

%% Optimization 
camparam.A = A;     camparam.R = R;     camparam.tvecs = tvecs;
camparam.k = k;
opti = optimzr( world_centers, image_centers, camparam, u0, v0, imagesize);

%% Undistort image
% image_centers_undistorted = undistortcenters(opti.imagepoints, imagesize, opti.k, u0, v0);
% [unx, uny, image_undistorted] = undistortimage(imag, imagesize, opti.k, u0, v0, 'cubic');
% figure; contourf(unx, uny, image_undistorted, 'EdgeColor', 'none'); axis on; axis equal; 
% hold on; vscatter(image_centers_undistorted, 'xy');

%% Unproject to world units
opti.M = [opti.R(1, :); opti.R(2, :); opti.tvec] * opti.A';
% opti_worldpoints = [image_centers_undistorted, ones(size(image_centers_undistorted, 1), 1)] /opti.M;
% world_centers_unprojected = opti_worldpoints(:, 1:2)./opti_worldpoints(:, 3);
% verror(world_centers_unprojected, world_centers);

% [up, vp, unprojected] = unproject_image(image_undistorted, imagesize, opti.M, 'cubic');
% figure; contourf(up, vp, unprojected, 'EdgeColor', 'none'); axis on; axis equal; 
% hold on; vscatter(world_centers, 'xg');

%% output results
cam_params.A = cam_params.A + opti.A;
cam_params.R = cam_params.R + opti.R;
cam_params.t = cam_params.t + opti.tvec;
cam_params.M = cam_params.M + opti.M;
cam_params.k = cam_params.k + opti.k;

n = n+1;

else
    sprintf('Check N_row & N_column...')
end
end

cam_params.A = cam_params.A/n;
cam_params.R = cam_params.R/n;
cam_params.t = cam_params.t/n;
cam_params.M = cam_params.M/n;
cam_params.k = cam_params.k/n;

%% error analysis
reprojected_centers = reproject(world_centers, image_centers, imagesize, cam_params);

verror(image_centers_guess, image_centers);
title('Error before iterative calibration in [px]')
[~, rms_error] = verror(image_centers, reprojected_centers);
title('Error After iterative calibration in [px]')

%% output
wdx = spacing_real;   wdy = spacing_real;
ix = reshape(reprojected_centers(:,1), N_row, N_column);
iy = reshape(reprojected_centers(:,2), N_row, N_column);
idx = ix(:, 2:end) - ix(:, 1:end-1);
idy = iy(2:end, :) - iy(1:end-1, :);

scale = [mean(wdx./idx, 'all')   mean(wdy./idy, 'all')];
save(strcat(pwd, '\\camera_cali.mat'), 'cam_params', 'scale', 'rms_error');

