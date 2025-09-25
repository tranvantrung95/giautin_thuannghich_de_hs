function img = create_test_cameraman()
    % TẠO ẢNH CAMERAMAN TEST CHO THUẬT TOÁN RDH
    % Output: img - ảnh Cameraman grayscale 256x256
    
    try
        % Thử load ảnh Cameraman có sẵn trong MATLAB
        img = imread('cameraman.tif');
    catch
        % Nếu không có, tạo ảnh test pattern tương tự
        fprintf('Không tìm thấy ảnh Cameraman, tạo ảnh test thay thế...\n');
        
        % Tạo ảnh test với cấu trúc phù hợp cho RDH
        [X, Y] = meshgrid(1:256, 1:256);
        
        % Tạo background
        img = 80 + 40*sin(X/20) + 30*cos(Y/18);
        
        % Thêm các đối tượng chính
        % Vùng trời (sáng)
        sky_mask = Y < 100;
        img(sky_mask) = img(sky_mask) + 60;
        
        % Vùng đất (tối hơn)
        ground_mask = Y > 180;
        img(ground_mask) = img(ground_mask) - 30;
        
        % Thêm một số đối tượng
        % Hình tròn giả lập người
        center_x = 128; center_y = 150;
        [X_circle, Y_circle] = meshgrid(1:256, 1:256);
        circle_mask = (X_circle - center_x).^2 + (Y_circle - center_y).^2 < 20^2;
        img(circle_mask) = img(circle_mask) + 50;
        
        % Thêm texture và noise
        img = img + 10*sin(X/3) .* cos(Y/4);
        img = img + 8*rand(256, 256) * 15 - 7.5;
        
        % Đảm bảo giá trị trong khoảng [0, 255]
        img = max(0, min(255, img));
    end
    
    % Chuyển về grayscale nếu cần
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Chuyển về double và resize nếu cần
    img = double(img);
    if size(img, 1) ~= 256 || size(img, 2) ~= 256
        img = imresize(img, [256, 256]);
    end
    
    fprintf('Đã tạo ảnh Cameraman test: %dx%d\n', size(img,1), size(img,2));
end
