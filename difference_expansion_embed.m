function [stego_img, location_map, embedded_length] = difference_expansion_embed(cover_img, secret_bits)
    % THUẬT TOÁN DIFFERENCE EXPANSION - EMBEDDING
    % Input:
    %   cover_img - ảnh gốc (grayscale, double)
    %   secret_bits - dữ liệu cần giấu (mảng bit 0/1)
    % Output:
    %   stego_img - ảnh đã giấu tin
    %   location_map - bản đồ vị trí đã sử dụng
    %   embedded_length - số bit đã giấu thực tế
    
    fprintf('\n--- DIFFERENCE EXPANSION EMBEDDING ---\n');
    
    % Kiểm tra input
    if size(cover_img, 3) ~= 1
        error('Ảnh phải là grayscale');
    end
    
    [rows, cols] = size(cover_img);
    stego_img = cover_img;
    location_map = zeros(rows, cols);
    
    % Thông số
    embedded_length = 0;
    bit_index = 1;
    max_bits = length(secret_bits);
    
    fprintf('Kích thước ảnh: %dx%d\n', rows, cols);
    fprintf('Số bit cần giấu: %d\n', max_bits);
    
    % Duyệt qua các cặp pixel (horizontal pairs)
    for i = 1:rows
        for j = 1:2:cols-1  % Bước nhảy 2 để tạo cặp
            if bit_index > max_bits
                break;
            end
            
            % Lấy cặp pixel
            x = stego_img(i, j);
            y = stego_img(i, j+1);
            
            % Tính average và difference
            l = floor((x + y) / 2);  % Average (floor)
            h = x - y;               % Difference
            
            % Kiểm tra điều kiện embedding
            % Điều kiện: |h| <= T và 2*l+h+b trong [0,255] và 2*l+h trong [0,255]
            T = 32; % Threshold để tránh overflow
            
            % Kiểm tra có thể embed không
            can_embed = (abs(h) <= T);
            
            if can_embed
                % Lấy bit cần giấu
                b = secret_bits(bit_index);
                
                % Tính difference mới: h' = 2*h + b
                h_new = 2 * h + b;
                
                % Tính pixel mới
                x_new = l + floor((h_new + 1) / 2);
                y_new = l - floor(h_new / 2);
                
                % Kiểm tra overflow
                if x_new >= 0 && x_new <= 255 && y_new >= 0 && y_new <= 255
                    % Embedding thành công
                    stego_img(i, j) = x_new;
                    stego_img(i, j+1) = y_new;
                    location_map(i, j) = 1;  % Đánh dấu vị trí đã embed
                    embedded_length = embedded_length + 1;
                    bit_index = bit_index + 1;
                    
                    if mod(embedded_length, 1000) == 0
                        fprintf('Đã giấu: %d/%d bits\n', embedded_length, max_bits);
                    end
                end
            end
        end
        
        if bit_index > max_bits
            break;
        end
    end
    
    % Thống kê kết quả
    capacity = sum(location_map(:));
    embedding_rate = embedded_length / (rows * cols);
    
    fprintf('Kết quả embedding:\n');
    fprintf('- Số bit đã giấu: %d/%d\n', embedded_length, max_bits);
    fprintf('- Dung lượng có thể: %d positions\n', capacity);
    fprintf('- Tỷ lệ embedding: %.4f bpp\n', embedding_rate);
    
    if embedded_length < max_bits
        warning('Không thể giấu hết dữ liệu! Chỉ giấu được %d/%d bits', embedded_length, max_bits);
    end
end
