function [recovered_img, extracted_bits] = histogram_shifting_extract(stego_img, peak_point, zero_point, num_bits)
    % THUẬT TOÁN HISTOGRAM SHIFTING - EXTRACTION
    % Input:
    %   stego_img - ảnh đã giấu tin
    %   peak_point - điểm peak đã sử dụng
    %   zero_point - điểm zero đã sử dụng
    %   num_bits - số bit cần trích xuất
    % Output:
    %   recovered_img - ảnh được khôi phục
    %   extracted_bits - dữ liệu được trích xuất
    
    fprintf('\n--- HISTOGRAM SHIFTING EXTRACTION ---\n');
    
    [rows, cols] = size(stego_img);
    recovered_img = stego_img;
    extracted_bits = zeros(1, num_bits);
    
    bit_index = 1;
    
    fprintf('Trích xuất %d bits từ ảnh %dx%d\n', num_bits, rows, cols);
    fprintf('Peak point: %d, Zero point: %d\n', peak_point, zero_point);
    
    % Xác định hướng shifting (tương tự embedding)
    shift_right = (zero_point > peak_point);
    if shift_right
        fprintf('Hướng shifting: phải\n');
    else
        fprintf('Hướng shifting: trái\n');
    end
    
    % Extraction và recovery process
    for i = 1:rows
        for j = 1:cols
            if bit_index > num_bits
                break;
            end
            
            pixel_val = round(stego_img(i, j));
            
            if shift_right
                % Đã shifting sang phải trong embedding
                if pixel_val == peak_point + 1
                    % Đây là pixel có embedded bit = 1
                    extracted_bits(bit_index) = 1;
                    recovered_img(i, j) = peak_point; % Khôi phục về peak point
                    bit_index = bit_index + 1;
                elseif pixel_val == peak_point
                    % Đây là pixel có embedded bit = 0
                    extracted_bits(bit_index) = 0;
                    recovered_img(i, j) = peak_point; % Giữ nguyên
                    bit_index = bit_index + 1;
                elseif pixel_val > peak_point + 1 && pixel_val <= zero_point
                    % Đây là pixel đã bị shift, khôi phục về vị trí gốc
                    recovered_img(i, j) = pixel_val - 1;
                end
            else
                % Đã shifting sang trái trong embedding
                if pixel_val == peak_point - 1
                    % Đây là pixel có embedded bit = 1
                    extracted_bits(bit_index) = 1;
                    recovered_img(i, j) = peak_point; % Khôi phục về peak point
                    bit_index = bit_index + 1;
                elseif pixel_val == peak_point
                    % Đây là pixel có embedded bit = 0
                    extracted_bits(bit_index) = 0;
                    recovered_img(i, j) = peak_point; % Giữ nguyên
                    bit_index = bit_index + 1;
                elseif pixel_val < peak_point - 1 && pixel_val >= zero_point
                    % Đây là pixel đã bị shift, khôi phục về vị trí gốc
                    recovered_img(i, j) = pixel_val + 1;
                end
            end
            
            if mod(bit_index-1, 1000) == 0 && bit_index > 1
                fprintf('Đã trích xuất: %d/%d bits\n', bit_index-1, num_bits);
            end
        end
        
        if bit_index > num_bits
            break;
        end
    end
    
    fprintf('Kết quả extraction:\n');
    fprintf('- Số bit đã trích xuất: %d\n', bit_index-1);
    
    % Kiểm tra tính toàn vẹn
    if bit_index-1 < num_bits
        warning('Không trích xuất đủ số bit yêu cầu!');
        extracted_bits = extracted_bits(1:bit_index-1);
    end
end
