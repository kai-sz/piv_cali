function [err, rms_error] = verror(A, B)
figure; 
err = A - B;
s3 = scatter(err(:,1), err(:,2));

s3.Marker = 'o';
s3.LineWidth = 0.6;
s3.MarkerEdgeColor = [0.2 0.2 0.2];
s3.MarkerFaceColor = [0.30,0.75,0.93];

grid on; box on;
axis equal; axis([-1, 1, -1, 1]);
set(gca, 'FontName', 'Times', 'FontSize', 14);

rms_error = sqrt(  sum( sum((A - B).^2, 2) )/length(A) );
fprintf('The RMS location error of all points is: %04f \n', rms_error);