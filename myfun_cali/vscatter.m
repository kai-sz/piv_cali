%% Author: Dr. Shaokai Zheng
function vscatter(A, mark)
if length( size(A) ) > 2
    for kk = 1:size(A, 3)
    scatter(A(:,1, kk), A(:,2, kk), mark)
    hold on
    end
else
    scatter(A(:,1), A(:,2), mark)
end
grid on; grid minor;