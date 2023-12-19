function edge_map = canny_edge_detector(image, low_threshold, high_threshold, sigma)
    % Convert the image to double
    image = im2double(image);

    % Step 1: Apply Gaussian blurring
    if nargin < 4
        sigma = 1.0;
    end
    filtered_image = imgaussfilt(image, sigma);

    % Step 2: Compute gradients
    [gx, gy] = gradient(filtered_image);
    gradient_magnitude = sqrt(gx.^2 + gy.^2);
    gradient_direction = atan2(gy, gx);

    % Step 3: Non-maximum suppression
    [rows, cols] = size(image);
    edge_map = zeros(rows, cols);
    angle_quantized = mod(gradient_direction + pi, pi);
    for row = 2:rows-1
        for col = 2:cols-1
            direction = angle_quantized(row, col);
            if (0 <= direction && direction < pi/8) || (7*pi/8 <= direction && direction <= pi)
                a = gradient_magnitude(row, col + 1);
                b = gradient_magnitude(row, col - 1);
            elseif pi/8 <= direction && direction < 3*pi/8
                a = gradient_magnitude(row + 1, col - 1);
                b = gradient_magnitude(row - 1, col + 1);
            elseif 3*pi/8 <= direction && direction < 5*pi/8
                a = gradient_magnitude(row + 1, col);
                b = gradient_magnitude(row - 1, col);
            else
                a = gradient_magnitude(row - 1, col - 1);
                b = gradient_magnitude(row + 1, col + 1);
            end

            if gradient_magnitude(row, col) >= a && gradient_magnitude(row, col) >= b
                edge_map(row, col) = gradient_magnitude(row, col);
            end
        end
    end

    % Step 4: Double thresholding
    high_threshold = max(edge_map(:)) * high_threshold;
    low_threshold = high_threshold * low_threshold;
    strong_edges = edge_map > high_threshold;
    weak_edges = (edge_map >= low_threshold) & (edge_map <= high_threshold);

    % Step 5: Edge tracking by hysteresis
    edge_map = strong_edges;
    visited = false(size(edge_map));
    while any(weak_edges(:))
        [row, col] = find(weak_edges, 1);
        weak_edges(row, col) = false;
        visited(row, col) = true;
        edge_map(row, col) = true;

        [r, c] = meshgrid(max(1, row-1):min(rows, row+1), max(1, col-1):min(cols, col+1));
        neighbors = sub2ind(size(edge_map), r(:), c(:));
        neighbor_weak = weak_edges(neighbors);
        neighbor_visited = visited(neighbors);
        while any(neighbor_weak(:) & ~neighbor_visited(:))
            weak_edges(neighbors(neighbor_weak & ~neighbor_visited)) = false;
            visited(neighbors(neighbor_weak & ~neighbor_visited)) = true;
            edge_map(neighbors(neighbor_weak & ~neighbor_visited)) = true;

            [r, c] = meshgrid(max(1, r-1):min(rows, r+1), max(1, c-1):min(cols, c+1));
            neighbors = sub2ind(size(edge_map), r(:), c(:));
            neighbor_weak = weak_edges(neighbors);
            neighbor_visited = visited(neighbors);
        end
    end
end
