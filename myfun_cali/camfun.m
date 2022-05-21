function y = camfun(x, wpt, u0, v0, imagesize)

ipt = [ wpt ones(size(wpt, 1), 1)] * ( [x(3:5)'; x(6:8)'; x(9:11)'] * [x(1), 0, u0; 0,  x(2),  v0; 0, 0, 1]' );
ipt2 = ipt(:, 1:2)./ ipt(:, 3);

u = ipt2(:,1);  v = ipt2(:,2);
u0 = (imagesize(1)+1)/2;   v0 = (imagesize(2)+1)/2;
cx = (u - u0)/imagesize(1);   cy = (v - v0)/imagesize(2);
r = (cx.^2 + cy.^2);

ud = u + (u - u0).*(x(12).*r + x(13).*r.^2 ); % + 2*x(14).*(u - u0).*(v - v0) + x(15)*(r + 2*(u - u0).^2);
vd = v + (v - v0).*(x(12).*r + x(13).*r.^2 ); % + x(14)*(r + 2*(v - v0).^2) + 2*x(15).*(u - u0).*(v - v0);

y = [ ud  vd ];