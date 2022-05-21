function [worldpoints_c, fig] = worldpoints_gen(rows, columns, spacing_real, handle)
% Sorting out worldpoints
locx = (columns-1)/2; locy = (rows-1)/2;

[wpx, wpy] = meshgrid( -locx*spacing_real:spacing_real:locx*spacing_real,...
    -locy*spacing_real:spacing_real:locy*spacing_real);

worldpoints_c = [reshape(wpx, [rows*columns, 1]), reshape(wpy, [rows*columns, 1])];

fig = NaN;
if handle
fig = figure(11); 
scatter(worldpoints_c(:,1), worldpoints_c(:,2), '+b');
axis ij equal
end