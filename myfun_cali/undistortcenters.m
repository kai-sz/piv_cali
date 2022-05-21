function undistorted = undistortcenters(original, imageSize, k, u0, v0)

undistorted = original;

x = (original(:,1) - u0)/imageSize(2);
y = (original(:,2) - v0)/imageSize(1);
r = (x.^2+y.^2);

undistorted(:,1) = ( original(:,1) + u0.*(k(1).*r + k(2).*r.^2) ) ./ ( ones(size(original, 1), 1) + (k(1).*r + k(2).*r.^2));
undistorted(:,2) = ( original(:,2) + v0.*(k(1).*r + k(2).*r.^2) ) ./ ( ones(size(original, 1), 1) + (k(1).*r + k(2).*r.^2));

