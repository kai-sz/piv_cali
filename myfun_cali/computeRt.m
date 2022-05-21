function [lambda, rVectors, tVectors] = computeRt(A, homographies)
% Compute translation and rotation vectors
    Ainv = inv(A);
    
    H = homographies(:, :);
    h1 = H(:, 1);
    h2 = H(:, 2);
    h3 = H(:, 3);
    lambda = 1 / norm(Ainv * h1);

    % 3D rotation matrix
    r1 = lambda * Ainv * h1;
    r2 = lambda * Ainv * h2;
    r3 = cross(r1, r2);
    R = [r1,r2,r3];

    rotationVectors(:) = rodrigues(R);

    % translation vector
    t = lambda * Ainv * h3;
    translationVectors(:) = t;

    rVectors = rotationVectors;
    tVectors = translationVectors;
end

