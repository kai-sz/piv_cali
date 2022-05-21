%% Sorting out imagepoints looping vertically through the rows
function varargout = sortcenters(centers, varargin)

if length(varargin) == 3
        radii =  varargin{1};
        rows = varargin{2};
        columns = varargin{3};

    for kk = 1:size(centers, 3)
    [~, idx] = sortrows(centers(:, 1));  % 1 instead of 2 would sort by x coord
    c = centers(idx, :, kk);
    r = radii(idx, :, kk);

    centers_real = zeros(size(centers));
    radii_real = zeros(size(radii));
    for i = 1:columns
        centers_real((i-1)*rows+1:i*rows,:, kk) = sortrows(c((i-1)*rows+1:i*rows,:), 2);
        radii_real((i-1)*rows+1:i*rows, kk) = sortrows(r((i-1)*rows+1:i*rows,:));
    end
    end
    varargout{1} = centers_real; 
    varargout{2} = radii_real;
    
else 
    rows = varargin{1};
    columns = varargin{2};
    for kk = 1:size(centers, 3)
    [~, idx] = sortrows(centers(:, 1));  % 1 instead of 2 would sort by x coord
    c = centers(idx, :, kk);

    centers_real = zeros(size(centers));
    for i = 1:columns
        centers_real((i-1)*rows+1:i*rows,:, kk) = sortrows(c((i-1)*rows+1:i*rows,:), 2);
    end
    end
    varargout{1} = centers_real;
end