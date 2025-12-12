function [watermarked_img, embed_info] = embed_DE(original_img, secret_bits)
% EMBED_DE - Thuật toán giấu tin Difference Expansion (DE)
% Input:
%   original_img: Ảnh gốc (grayscale hoặc color)
%   secret_bits: Dữ liệu bí mật dưới dạng chuỗi bit (0 và 1)
% Output:
%   watermarked_img: Ảnh đã giấu tin
%   embed_info: Thông tin cần thiết để trích xuất

try
    % Chuyển về grayscale hoặc kênh Y nếu là ảnh màu để không phải lưu lại ảnh gốc
    if ndims(original_img) == 3
        is_color = true;
        ycbcr_img = rgb2ycbcr(original_img);
        gray_img = ycbcr_img(:,:,1); % chỉ thao tác trên kênh sáng
    else
        is_color = false;
        gray_img = original_img;
        ycbcr_img = [];
    end
    
    % Chuyển về double để tính toán
    gray_img = double(gray_img);
    [rows, cols] = size(gray_img);
    
    % Khởi tạo ảnh kết quả
    watermarked_gray = gray_img;
    
    % Thông tin embed
    embed_info = struct();
    embed_info.is_color = is_color;
    embed_info.original_size = [rows, cols];
    embed_info.secret_length = length(secret_bits);
    embed_info.locations = []; % Vị trí đã embed: [row, col, original_d]
    
    % Chuyển secret_bits thành số (từng bit một)
    secret_data = zeros(length(secret_bits), 1);
    for i = 1:length(secret_bits)
        secret_data(i) = str2double(secret_bits(i));
    end
    
    % Tìm các cặp pixel liền kề (không chồng lấn) để embed
    locations = [];
    bit_idx = 1;
    
    % Quét theo hàng, dùng cặp (j, j+1) với bước 2 để không ghi đè lẫn nhau
    for i = 1:rows
        for j = 1:2:cols-1
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
                
                % Dùng average nguyên để đảm bảo thuận nghịch
                avg_int = floor((x + y) / 2);
                % Tính pixel mới (công thức DE chính xác, integer)
                x_new = avg_int + ceil(d_new / 2);
                y_new = avg_int - floor(d_new / 2);
                
                % Kiểm tra giới hạn pixel [0, 255]
                if x_new >= 0 && x_new <= 255 && y_new >= 0 && y_new <= 255
                    watermarked_gray(i, j) = x_new;
                    watermarked_gray(i, j+1) = y_new;
                    
                    % Lưu vị trí đã embed cùng difference gốc (không lưu bit bí mật)
                    locations = [locations; i, j, d];
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
        error('Dung lượng không đủ để giấu toàn bộ dữ liệu (%d/%d bit khả dụng).', ...
            bit_idx-1, length(secret_data));
    else
        embed_info.actual_embedded = length(secret_data);
    end
    
    % Lưu thông tin embed
    embed_info.locations = locations;
    
    % Chuyển về uint8
    watermarked_gray = uint8(round(watermarked_gray));
    
    % Tạo ảnh kết quả cuối cùng
    if is_color
        ycbcr_img(:,:,1) = watermarked_gray;
        watermarked_img = ycbcr2rgb(ycbcr_img);
    else
        watermarked_img = watermarked_gray;
    end
    
    fprintf('DE Embedding hoàn thành: %d/%d bit đã được embed\n', ...
        embed_info.actual_embedded, length(secret_data));
    
catch err
    error('Lỗi trong quá trình embed DE: %s', err.message);
end
end
