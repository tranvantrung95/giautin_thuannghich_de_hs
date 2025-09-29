function demo_img = create_demo_image()
% CREATE_DEMO_IMAGE - Tạo ảnh demo phù hợp cho thuật toán RDH
% Output:
%   demo_img: Ảnh demo grayscale 256x256

try
    % Tạo ảnh cơ bản 256x256
    img_size = 256;
    demo_img = zeros(img_size, img_size);
    
    % Tạo các vùng với intensity khác nhau để tạo histogram đa dạng
    
    % Vùng 1: Background (góc trên trái) - intensity thấp
    demo_img(1:128, 1:128) = 80 + 20 * randn(128, 128);
    
    % Vùng 2: Object 1 (góc trên phải) - intensity trung bình
    demo_img(1:128, 129:256) = 150 + 15 * randn(128, 128);
    
    % Vùng 3: Object 2 (góc dưới trái) - intensity cao
    demo_img(129:256, 1:128) = 200 + 10 * randn(128, 128);
    
    % Vùng 4: Texture area (góc dưới phải) - intensity dao động
    [X, Y] = meshgrid(1:128, 1:128);
    texture = 120 + 30 * sin(X/10) .* cos(Y/10) + 10 * randn(128, 128);
    demo_img(129:256, 129:256) = texture;
    
    % Thêm một số đường biên để tạo edges
    demo_img(64:65, :) = 180; % Đường ngang
    demo_img(:, 128:129) = 100; % Đường dọc
    
    % Thêm một số shapes
    % Circle
    center_x = 64; center_y = 64; radius = 20;
    for i = 1:img_size
        for j = 1:img_size
            if (i - center_x)^2 + (j - center_y)^2 <= radius^2
                demo_img(i, j) = 220;
            end
        end
    end
    
    % Rectangle
    demo_img(180:220, 180:220) = 160;
    
    % Clamp values to [0, 255]
    demo_img = max(0, min(255, demo_img));
    
    % Chuyển về uint8
    demo_img = uint8(round(demo_img));
    
    % Kiểm tra histogram
    hist_values = imhist(demo_img);
    non_zero_bins = sum(hist_values > 0);
    
    fprintf('Demo image được tạo thành công:\n');
    fprintf('Kích thước: %dx%d\n', img_size, img_size);
    fprintf('Histogram có %d bins khác 0 (/%d total)\n', non_zero_bins, 256);
    fprintf('Pixel values: min=%d, max=%d\n', min(demo_img(:)), max(demo_img(:)));
    
    % Đảm bảo có đủ đa dạng cho cả DE và HS
    if non_zero_bins < 50
        warning('Histogram có ít bins. Có thể ảnh hưởng đến hiệu suất thuật toán.');
    end
    
catch err
    error('Lỗi trong create_demo_image: %s', err.message);
end
end

