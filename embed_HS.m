function [watermarked_img, embed_info] = embed_HS(original_img, secret_bits)
% EMBED_HS - Thuật toán giấu tin Histogram Shifting (HS)
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
    
    % Chuyển về double
    gray_img = double(gray_img);
    [rows, cols] = size(gray_img);
    
    % Tính histogram
    histogram = zeros(1, 256);
    for i = 1:rows
        for j = 1:cols
            pixel_val = gray_img(i, j) + 1; % MATLAB indexing từ 1
            histogram(pixel_val) = histogram(pixel_val) + 1;
        end
    end
    
    % Tìm peak point tối ưu (tránh extreme values)
    % Loại bỏ 0, 255 để tránh overflow/underflow
    valid_histogram = histogram(2:255); % Chỉ xét 1-254
    [max_freq, peak_idx] = max(valid_histogram);
    peak_point = peak_idx; % Giá trị pixel thực (1-254)
    
    % Tìm zero point gần peak nhất (trong range hợp lý)
    zero_point = -1;
    min_distance = inf;
    
    % Chỉ tìm trong vùng +/- 50 pixels từ peak để giảm shift range
    search_start = max(1, peak_point - 50);
    search_end = min(256, peak_point + 50);
    
    for i = search_start:search_end
        if histogram(i) == 0
            distance = abs((i-1) - peak_point);
            if distance < min_distance && distance > 5 % Tối thiểu cách 5 pixels
                min_distance = distance;
                zero_point = i - 1; % Chuyển về giá trị pixel thực
            end
        end
    end
    
    % Nếu không tìm thấy zero point hợp lý, tạo artificial zero point
    if zero_point == -1 || min_distance > 30
        % Tạo artificial zero point gần peak (giảm thiểu shift range)
        if peak_point < 127
            artificial_zero = peak_point + 10; % Phía phải peak
        else
            artificial_zero = peak_point - 10; % Phía trái peak
        end
        
        % Đảm bảo trong bounds
        artificial_zero = max(5, min(250, artificial_zero));
        
        % Tìm điểm có frequency thấp nhất gần artificial position
        search_window = max(1, artificial_zero-5):min(256, artificial_zero+5);
        min_freq_in_window = inf;
        for idx = search_window
            if histogram(idx) < min_freq_in_window
                min_freq_in_window = histogram(idx);
                zero_point = idx - 1;
            end
        end
        
        fprintf('Tạo artificial zero point: %d (freq: %d)\n', zero_point, min_freq_in_window);
    end
    
    % Xác định hướng shifting
    if zero_point > peak_point
        shift_direction = 1; % Shift sang phải
        shift_range = [peak_point + 1, zero_point - 1];
    else
        shift_direction = -1; % Shift sang trái
        shift_range = [zero_point + 1, peak_point - 1];
    end
    
    % Khởi tạo embed info
    embed_info = struct();
    embed_info.is_color = is_color;
    embed_info.color_img = color_img;
    embed_info.peak_point = peak_point;
    embed_info.zero_point = zero_point;
    embed_info.shift_direction = shift_direction;
    embed_info.shift_range = shift_range;
    if exist('pre_shift_range', 'var')
        embed_info.pre_shift_range = pre_shift_range;
    else
        embed_info.pre_shift_range = [];
    end
    embed_info.secret_length = length(secret_bits);
    embed_info.embedded_locations = [];
    
    % Chuyển secret_bits thành số
    secret_data = zeros(length(secret_bits), 1);
    for i = 1:length(secret_bits)
        secret_data(i) = str2double(secret_bits(i));
    end
    
    % Bước 1: Pre-shift chỉ những pixels gần zero point (giảm thiểu ảnh hưởng)
    watermarked_gray = gray_img;
    pre_shift_range = [min(peak_point, zero_point) + floor(abs(peak_point - zero_point) * 0.8), ...
                       max(peak_point, zero_point) - 1]; % Chỉ shift 20% cuối của range
    
    if pre_shift_range(1) <= pre_shift_range(2)
        for i = 1:rows
            for j = 1:cols
                pixel_val = gray_img(i, j);
                
                % Chỉ shift pixels gần zero point
                if shift_direction == 1 && pixel_val >= pre_shift_range(1) && pixel_val <= pre_shift_range(2)
                    watermarked_gray(i, j) = pixel_val + 1;
                elseif shift_direction == -1 && pixel_val >= pre_shift_range(1) && pixel_val <= pre_shift_range(2)
                    watermarked_gray(i, j) = pixel_val - 1;
                end
            end
        end
    end
    
    % Bước 2: Embed dữ liệu vào peak point (với giới hạn)
    bit_idx = 1;
    embedded_locations = [];
    embedded_count = 0;
    % Ưu tiên secret_data length nhưng có giới hạn an toàn
    needed_pixels = length(secret_data);
    safe_max_pixels = max_freq * 0.3; % Tối đa 30% peak pixels
    max_embed_pixels = min(needed_pixels, safe_max_pixels);
    
    for i = 1:rows
        for j = 1:cols
            if bit_idx > length(secret_data) || embedded_count >= max_embed_pixels
                break;
            end
            
            if gray_img(i, j) == peak_point
                secret_bit = secret_data(bit_idx);
                
                if secret_bit == 1
                    % Embed bit 1: chuyển pixel sang zero_point direction
                    if shift_direction == 1
                        watermarked_gray(i, j) = peak_point + 1;
                    else
                        watermarked_gray(i, j) = peak_point - 1;
                    end
                    embedded_locations = [embedded_locations; i, j, 1];
                else
                    % Embed bit 0: giữ nguyên tại peak_point
                    watermarked_gray(i, j) = peak_point;
                    embedded_locations = [embedded_locations; i, j, 0];
                end
                
                bit_idx = bit_idx + 1;
                embedded_count = embedded_count + 1;
            end
        end
        if bit_idx > length(secret_data) || embedded_count >= max_embed_pixels
            break;
        end
    end
    
    % Kiểm tra capacity
    if bit_idx <= length(secret_data)
        warning('Không thể embed hết dữ liệu. Chỉ embed được %d/%d bit.', ...
            bit_idx-1, length(secret_data));
        embed_info.actual_embedded = bit_idx - 1;
    else
        embed_info.actual_embedded = length(secret_data);
    end
    
    embed_info.embedded_locations = embedded_locations;
    
    % Chuyển về uint8
    watermarked_gray = uint8(round(watermarked_gray));
    
    % Tạo ảnh kết quả cuối cùng
    if is_color
        watermarked_img = color_img;
        watermarked_img(:,:,1) = watermarked_gray;
    else
        watermarked_img = watermarked_gray;
    end
    
    fprintf('HS Embedding hoàn thành:\n');
    fprintf('Peak point: %d (tần suất: %d)\n', peak_point, max_freq);
    fprintf('Zero point: %d\n', zero_point);
    fprintf('Shift direction: %d\n', shift_direction);
    if exist('pre_shift_range', 'var') && pre_shift_range(1) <= pre_shift_range(2)
        affected_pixels = sum(histogram(pre_shift_range(1)+1:pre_shift_range(2)+1));
        fprintf('Pre-shift range: [%d, %d] (pixels affected: %d)\n', pre_shift_range(1), pre_shift_range(2), affected_pixels);
    else
        fprintf('No pre-shifting needed\n');
    end
    fprintf('Needed: %d pixels, Safe max: %.0f pixels (30%% of peak)\n', needed_pixels, safe_max_pixels);
    fprintf('Max embed pixels: %.0f, Actually embedded: %d\n', max_embed_pixels, embedded_count);
    fprintf('Embedded: %d/%d bit\n', embed_info.actual_embedded, length(secret_data));
    
catch err
    error('Lỗi trong quá trình embed HS: %s', err.message);
end
end

