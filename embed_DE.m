function [watermarked_img, embed_info] = embed_DE(original_img, secret_bits)
% EMBED_DE - Thuật toán giấu tin Difference Expansion (DE)
% Input:
%   original_img: Ảnh gốc (grayscale hoặc color)
%   secret_bits: Dữ liệu bí mật dưới dạng chuỗi bit (0 và 1)
% Output:
%   watermarked_img: Ảnh đã giấu tin
%   embed_info: Thông tin cần thiết để trích xuất

try
    % Chuyển về grayscale nếu cần
    if size(original_img, 3) == 3
        gray_img = rgb2gray(original_img);
        is_color = true;
        color_img = original_img;
    else
        gray_img = original_img;
        is_color = false;
        color_img = [];
    end
    
    % Chuyển về double để tính toán
    gray_img = double(gray_img);
    [rows, cols] = size(gray_img);
    
    % Khởi tạo ảnh kết quả
    watermarked_gray = gray_img;
    
    % Thông tin embed
    embed_info = struct();
    embed_info.is_color = is_color;
    embed_info.color_img = color_img;
    embed_info.original_size = [rows, cols];
    embed_info.secret_length = length(secret_bits);
    embed_info.locations = []; % Vị trí đã embed
    
    % Chuyển secret_bits thành số (từng bit một)
    secret_data = zeros(length(secret_bits), 1);
    for i = 1:length(secret_bits)
        secret_data(i) = str2double(secret_bits(i));
    end
    
    % Tìm các cặp pixel liền kề để embed
    locations = [];
    bit_idx = 1;
    
    % Quét theo hàng (từ trái sang phải, từ trên xuống dưới)
    for i = 1:rows
        for j = 1:cols-1
            if bit_idx > length(secret_data)
                break;
            end
            
            % Lấy cặp pixel liền kề
            x = gray_img(i, j);
            y = gray_img(i, j+1);
            
            % Tính difference và average
            d = x - y;
            avg = (x + y) / 2;
            
            % Kiểm tra điều kiện embeddable (tránh overflow/underflow)
            if abs(d) <= 127 && avg >= 64 && avg <= 191
                % Embed bit vào difference
                secret_bit = secret_data(bit_idx);
                
                % DE formula: d' = 2*d + secret_bit
                d_new = 2 * d + secret_bit;
                
                % Tính pixel mới (công thức DE chính xác)
                x_new = avg + ceil(d_new / 2);
                y_new = avg - floor(d_new / 2);
                
                % Kiểm tra giới hạn pixel [0, 255]
                if x_new >= 0 && x_new <= 255 && y_new >= 0 && y_new <= 255
                    watermarked_gray(i, j) = x_new;
                    watermarked_gray(i, j+1) = y_new;
                    
                    % Lưu vị trí đã embed
                    locations = [locations; i, j, d, secret_bit];
                    bit_idx = bit_idx + 1;
                end
            end
        end
        if bit_idx > length(secret_data)
            break;
        end
    end
    
    % Kiểm tra xem có embed đủ bit không
    if bit_idx <= length(secret_data)
        warning('Không thể embed hết dữ liệu. Chỉ embed được %d/%d bit.', ...
            bit_idx-1, length(secret_data));
        embed_info.actual_embedded = bit_idx - 1;
    else
        embed_info.actual_embedded = length(secret_data);
    end
    
    % Lưu thông tin embed
    embed_info.locations = locations;
    
    % Chuyển về uint8
    watermarked_gray = uint8(round(watermarked_gray));
    
    % Tạo ảnh kết quả cuối cùng
    if is_color
        % Thay thế channel đỏ bằng grayscale đã watermark
        watermarked_img = color_img;
        watermarked_img(:,:,1) = watermarked_gray;
    else
        watermarked_img = watermarked_gray;
    end
    
    fprintf('DE Embedding hoàn thành: %d/%d bit đã được embed\n', ...
        embed_info.actual_embedded, length(secret_data));
    
catch err
    error('Lỗi trong quá trình embed DE: %s', err.message);
end
end

