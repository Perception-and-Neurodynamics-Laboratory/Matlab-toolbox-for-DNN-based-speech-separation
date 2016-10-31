function ret = make_window_buffer(X, side_size)
if side_size ~=0 
    [~, d] = size(X); %frame \times dimension
    X = [repmat(X(1,:), side_size,1); X; repmat(X(end,:), side_size, 1)]';
    winsize_in_frame = 2*side_size + 1;
    ret = buffer(X(:), d*winsize_in_frame, d*winsize_in_frame-d, 'nodelay')';
else
    ret = X;
end

