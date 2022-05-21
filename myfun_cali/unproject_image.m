function [up, vp, unprojected] = unproject_image(image_undistorted, imageSize, M, method)

[wx, wy] = meshgrid(1:imageSize(1), 1:imageSize(2));
worldpoints = [[wx(:) wy(:)], ones(numel(wx(:)), 1)] /M;
wun = worldpoints(:, 1:2)./worldpoints(:, 3);

uu = reshape(wun(:,1), imageSize(1), imageSize(2));
vv = reshape(wun(:,2), imageSize(1), imageSize(2));

up = reshape(wun(:,1), imageSize(1), imageSize(2));
vp = reshape(wun(:,2), imageSize(1), imageSize(2));

unprojected = griddata(uu, vv, image_undistorted, up, vp, method);