function H = computeHomography(imagePoints, worldPoints)
% Compute projective transformation from worldPoints to imagePoints
H = fitgeotrans(worldPoints, imagePoints, 'projective');
H = (H.T)';
H = H / H(3,3);
end