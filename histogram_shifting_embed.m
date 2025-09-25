function [stego_img, peak_point, zero_point, embedded_length] = histogram_shifting_embed(cover_img, secret_bits)
    % THUẬT TOÁN HISTOGRAM SHIFTING - EMBEDDING
    % Input:
    %   cover_img - ảnh gốc (grayscale, double)
    %   secret_bits - dữ liệu cần giấu (mảng bit 0/1)
    % Output:
    %   stego_img - ảnh đã giấu tin
    %   peak_point - điểm peak được chọn
    %   zero_point - điểm zero được chọn
    %   embedded_length - số bit đã giấu thực tế
    
    fprintf('\n--- HISTOGRAM SHIFTING EMBEDDING ---\n');
    
    % Kiểm tra input
    if size(cover_img, 3) ~= 1
        error('Ảnh phải là grayscale');
    end
    
    [rows, cols] = size(cover_img);
    stego_img = cover_img;
    max_bits = length(secret_bits);
    
    fprintf('Kích thước ảnh: %dx%d\n', rows, cols);
    fprintf('Số bit cần giấu: %d\n', max_bits);
    
    % Tính histogram của ảnh gốc
    histogram = zeros(1, 256);
    for i = 1:rows
        for j = 1:cols
            pixel_val = round(cover_img(i, j)) + 1; % +1 vì MATLAB index từ 1
            if pixel_val >= 1 && pixel_val <= 256
                histogram(pixel_val) = histogram(pixel_val) + 1;
            end
        end
    end
    
    % Hiển thị histogram
    fprintf('Phân tích histogram:\n');
    [max_freq, max_idx] = max(histogram);
    peak_point = max_idx - 1; % Chuyển về index từ 0
    
    fprintf('- Peak point (max frequency): %d (frequency: %d)\n', peak_point, max_freq);
    
    % Tìm zero point gần peak point nhất
    zero_point = -1;
    for dist = 1:128
        % Kiểm tra bên phải peak
        if (peak_point + dist + 1) <= 256 && histogram(peak_point + dist + 1) == 0
            zero_point = peak_point + dist;
            break;
        end
        % Kiểm tra bên trái peak (nếu không phải là 0)
        if (peak_point - dist + 1) >= 1 && peak_point - dist >= 0 && histogram(peak_point - dist + 1) == 0
            zero_point = peak_point - dist;
            break;
        end
    end
    
    if zero_point == -1
        % Nếu không tìm thấy zero point, chọn điểm có frequency thấp nhất
        [~, min_idx] = min(histogram);
        zero_point = min_idx - 1;
        fprintf('- Không tìm thấy zero point, chọn điểm tần số thấp nhất: %d (frequency: %d)\n', zero_point, histogram(min_idx));
    else
        fprintf('- Zero point: %d\n', zero_point);
    end
    
    % Embedding process
    embedded_length = 0;
    bit_index = 1;
    
    % Xác định hướng shifting (trái hay phải)
    shift_right = (zero_point > peak_point);
    
    if shift_right
        fprintf('Hướng shifting: phải\n');
    else
        fprintf('Hướng shifting: trái\n');
    end
    
    % Thực hiện shifting và embedding
    for i = 1:rows
        for j = 1:cols
            if bit_index > max_bits
                break;
            end
            
            pixel_val = round(stego_img(i, j));
            
            if shift_right
                % Shifting sang phải
                if pixel_val > peak_point && pixel_val < zero_point
                    % Shift pixel sang phải
                    stego_img(i, j) = pixel_val + 1;
                elseif pixel_val == peak_point
                    % Embed bit vào peak point
                    b = secret_bits(bit_index);
                    stego_img(i, j) = pixel_val + b;
                    embedded_length = embedded_length + 1;
                    bit_index = bit_index + 1;
                end
            else
                % Shifting sang trái
                if pixel_val < peak_point && pixel_val > zero_point
                    % Shift pixel sang trái
                    stego_img(i, j) = pixel_val - 1;
                elseif pixel_val == peak_point
                    % Embed bit vào peak point
                    b = secret_bits(bit_index);
                    stego_img(i, j) = pixel_val - b;
                    embedded_length = embedded_length + 1;
                    bit_index = bit_index + 1;
                end
            end
            
            if mod(embedded_length, 1000) == 0 && embedded_length > 0
                fprintf('Đã giấu: %d/%d bits\n', embedded_length, max_bits);
            end
        end
        
        if bit_index > max_bits
            break;
        end
    end
    
    % Thống kê kết quả
    capacity = max_freq; % Capacity = số pixel tại peak point
    embedding_rate = embedded_length / (rows * cols);
    
    fprintf('Kết quả embedding:\n');
    fprintf('- Số bit đã giấu: %d/%d\n', embedded_length, max_bits);
    fprintf('- Dung lượng có thể: %d positions\n', capacity);
    fprintf('- Tỷ lệ embedding: %.4f bpp\n', embedding_rate);
    
    if embedded_length < max_bits
        warning('Không thể giấu hết dữ liệu! Chỉ giấu được %d/%d bits', embedded_length, max_bits);
    end
end
