function img = create_test_lena()
    % TẠO ẢNH LENA TEST CHO THUẬT TOÁN RDH
    % Output: img - ảnh Lena grayscale 512x512
    
    try
        % Thử load ảnh Lena có sẵn trong MATLAB
        img = imread('lena.png');
    catch
        % Nếu không có, tạo ảnh test pattern tương tự
        fprintf('Không tìm thấy ảnh Lena, tạo ảnh test thay thế...\n');
        
        % Tạo ảnh test với texture phù hợp cho RDH
        [X, Y] = meshgrid(1:512, 1:512);
        
        % Tạo base pattern
        img = 128 + 50*sin(X/30) + 30*cos(Y/25) + 20*sin((X+Y)/40);
        
        % Thêm texture chi tiết
        img = img + 15*sin(X/5) .* cos(Y/7);
        img = img + 10*rand(512, 512) * 20 - 10; % Noise nhẹ
        
        % Thêm một số vùng có cường độ khác nhau
        img(100:200, 100:200) = img(100:200, 100:200) + 30;
        img(300:400, 300:400) = img(300:400, 300:400) - 20;
        
        % Đảm bảo giá trị trong khoảng [0, 255]
        img = max(0, min(255, img));
    end
    
    % Chuyển về grayscale nếu cần
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Chuyển về double và resize nếu cần
    img = double(img);
    if size(img, 1) ~= 512 || size(img, 2) ~= 512
        img = imresize(img, [512, 512]);
    end
    
    fprintf('Đã tạo ảnh Lena test: %dx%d\n', size(img,1), size(img,2));
end
