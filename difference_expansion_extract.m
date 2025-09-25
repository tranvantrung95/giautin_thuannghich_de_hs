function [recovered_img, extracted_bits] = difference_expansion_extract(stego_img, location_map, num_bits)
    % THUẬT TOÁN DIFFERENCE EXPANSION - EXTRACTION
    % Input:
    %   stego_img - ảnh đã giấu tin
    %   location_map - bản đồ vị trí đã sử dụng
    %   num_bits - số bit cần trích xuất
    % Output:
    %   recovered_img - ảnh được khôi phục
    %   extracted_bits - dữ liệu được trích xuất
    
    fprintf('\n--- DIFFERENCE EXPANSION EXTRACTION ---\n');
    
    [rows, cols] = size(stego_img);
    recovered_img = stego_img;
    extracted_bits = zeros(1, num_bits);
    
    bit_index = 1;
    
    fprintf('Trích xuất %d bits từ ảnh %dx%d\n', num_bits, rows, cols);
    
    % Duyệt qua các cặp pixel theo thứ tự tương tự embedding
    for i = 1:rows
        for j = 1:2:cols-1
            if bit_index > num_bits
                break;
            end
            
            % Kiểm tra xem vị trí này có được sử dụng không
            if location_map(i, j) == 1
                % Lấy cặp pixel từ stego image
                x_stego = stego_img(i, j);
                y_stego = stego_img(i, j+1);
                
                % Tính average và difference
                l = floor((x_stego + y_stego) / 2);
                h_stego = x_stego - y_stego;  % Difference trong stego image
                
                % Trích xuất bit: b = h_stego mod 2
                extracted_bit = mod(h_stego, 2);
                extracted_bits(bit_index) = extracted_bit;
                
                % Khôi phục difference gốc: h = floor(h_stego / 2)
                h_original = floor(h_stego / 2);
                
                % Khôi phục pixel gốc
                x_original = l + floor((h_original + 1) / 2);
                y_original = l - floor(h_original / 2);
                
                % Lưu pixel đã khôi phục
                recovered_img(i, j) = x_original;
                recovered_img(i, j+1) = y_original;
                
                bit_index = bit_index + 1;
                
                if mod(bit_index-1, 1000) == 0 && bit_index > 1
                    fprintf('Đã trích xuất: %d/%d bits\n', bit_index-1, num_bits);
                end
            end
        end
        
        if bit_index > num_bits
            break;
        end
    end
    
    fprintf('Kết quả extraction:\n');
    fprintf('- Số bit đã trích xuất: %d\n', bit_index-1);
    
    % Kiểm tra tính toàn vẹn của quá trình khôi phục
    if bit_index-1 < num_bits
        warning('Không trích xuất đủ số bit yêu cầu!');
        extracted_bits = extracted_bits(1:bit_index-1);
    end
end
