function [uuu, vvv, undistorted_image] = undistortimage(original_image, imageSize, k, u0, v0, method)

[u, v] = meshgrid(1:imageSize(1), 1:imageSize(2));

x = (u(:) - u0)/imageSize(1);    
y = (v(:) - v0)/imageSize(2);
r = (x.^2 + y.^2);

un = ( u(:) + u0*(k(1).*r + k(2).*r.^2) ) ./ ( ones(length(r),1) + (k(1).*r + k(2).*r.^2));
vn = ( v(:) + v0*(k(1).*r + k(2).*r.^2) ) ./ ( ones(length(r),1) + (k(1).*r + k(2).*r.^2));

uu = reshape(un, imageSize(1), imageSize(2));
vv = reshape(vn, imageSize(1), imageSize(2));

[uuu, vvv] = meshgrid(1:imageSize(1), 1:imageSize(2));
undistorted_image = griddata(uu, vv, double(original_image), uuu, vvv, method);