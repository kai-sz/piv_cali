function reprojected_centers = reproject(world_centers, image_centers, imagesize, cam_params)

A = cam_params.A;     
R = cam_params.R;     
tvecs = cam_params.t;
k = cam_params.k;

M = [R(1, :); R(2, :); tvecs] * A';

pctr = [world_centers, ones(size(image_centers, 1), 1)]*M;
projected_centers = pctr(:, 1:2)./ pctr(:, 3);

u = projected_centers(:,1);   v = projected_centers(:,2); 
u0 = (imagesize(1)+1)/2;   v0 = (imagesize(2)+1)/2;
cx = (u - u0)/imagesize(1);   cy = (v - v0)/imagesize(2);
r = (cx.^2+cy.^2);

ud = u + (u-u0).*( k(1)*r + k(2)*r.^2 ); % + 2*k(3).*(u - u0).*(v - v0) + k(4)*(r + 2*(u - u0).^2);
vd = v + (v-v0).*( k(1)*r + k(2)*r.^2 ); % + k(3)*(r + 2*(v - v0).^2) + 2*k(4).*(u - u0).*(v - v0);

reprojected_centers = [ud vd];