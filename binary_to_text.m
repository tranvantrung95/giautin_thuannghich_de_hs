function text = binary_to_text(binary_string)
% BINARY_TO_TEXT - Chuyển đổi chuỗi bit thành text
% Sử dụng decoding cực kỳ đơn giản: đọc 8-bit length rồi 16-bit per char

try
    if isempty(binary_string)
        text = '';
        return;
    end
    
    % Kiểm tra độ dài tối thiểu (8 bit header)
    if length(binary_string) < 8
        error('Binary string quá ngắn, không chứa header hợp lệ');
    end
    
    % Đọc 8-bit cuối cùng là độ dài (header được bảo vệ)
    length_header = binary_string(end-7:end);
    header_length = bin2dec(length_header);
    
    % Tính toán độ dài thực tế từ total bits (backup method)
    calculated_length = (length(binary_string) - 8) / 16;
    calculated_length = floor(calculated_length); % Làm tròn xuống
    
    % Chọn độ dài hợp lý nhất
    if header_length > 0 && header_length <= 255 && header_length == calculated_length
        % Header chính xác
        text_length = header_length;
        recovery_method = 'header';
    elseif calculated_length > 0 && calculated_length <= 255
        % Dùng calculated length
        text_length = calculated_length;
        recovery_method = 'calculated';
    else
        % Fallback: dùng header ngay cả khi có vẻ sai
        text_length = max(1, min(header_length, calculated_length));
        recovery_method = 'fallback';
    end
    
    fprintf('Chuyển đổi binary thành text:\n');
    fprintf('Protected header (last 8 bits): %s -> %d chars\n', length_header, header_length);
    fprintf('Calculated from total bits: %d chars\n', calculated_length);
    fprintf('Using: %d chars (method: %s)\n', text_length, recovery_method);
    
    % Tính toán số bit cần thiết cho data
    expected_data_bits = text_length * 16;
    total_expected_bits = 8 + expected_data_bits;
    
    % Lấy data portion (bỏ qua 8 bit cuối - header được bảo vệ)
    if length(binary_string) >= total_expected_bits
        data_binary = binary_string(1:expected_data_bits);
    else
        % Nếu không đủ bit, lấy phần đầu và thêm padding
        available_data_bits = length(binary_string) - 8;
        if available_data_bits > 0
            data_binary = binary_string(1:available_data_bits);
        else
            data_binary = '';
        end
        
        if length(data_binary) < expected_data_bits
            padding_needed = expected_data_bits - length(data_binary);
            data_binary = [data_binary, repmat('0', 1, padding_needed)];
            fprintf('Warning: Thêm %d padding bits\n', padding_needed);
        end
    end
    
    % Chuyển mỗi 16-bit thành character
    text = '';
    
    for i = 1:text_length
        start_idx = (i-1)*16 + 1;
        end_idx = i*16;
        
        if end_idx <= length(data_binary)
            binary_char = data_binary(start_idx:end_idx);
            char_code = bin2dec(binary_char);
            
            % Thêm ký tự (để nguyên kể cả null chars nếu có)
            text = [text, char(char_code)];
        else
            fprintf('Warning: Không đủ data cho ký tự thứ %d\n', i);
            break;
        end
    end
    
    fprintf('Recovered: %d chars -> Text: "%s"\n', length(text), text);
    
catch err
    error('Lỗi trong binary_to_text: %s', err.message);
end
end

