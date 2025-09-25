function text = bits_to_text(bits)
    % CHUYỂN ĐỔI CHUỖI BIT THÀNH TEXT
    % Input: bits - mảng bit (0/1)
    % Output: text - chuỗi ký tự được khôi phục
    
    if isempty(bits)
        text = '';
        return;
    end
    
    % Đảm bảo số bit chia hết cho 8
    num_bits = length(bits);
    if mod(num_bits, 8) ~= 0
        warning('Số bit không chia hết cho 8, có thể mất dữ liệu');
        % Padding với 0 nếu cần
        padding_needed = 8 - mod(num_bits, 8);
        bits = [bits, zeros(1, padding_needed)];
        num_bits = length(bits);
    end
    
    num_chars = num_bits / 8;
    ascii_codes = zeros(1, num_chars);
    
    % Chuyển mỗi 8 bit thành một ký tự
    for i = 1:num_chars
        start_idx = (i-1) * 8 + 1;
        end_idx = i * 8;
        
        % Lấy 8 bit
        char_bits = bits(start_idx:end_idx);
        
        % Chuyển binary thành decimal
        binary_str = num2str(char_bits);
        binary_str = binary_str(binary_str ~= ' '); % Loại bỏ space
        ascii_codes(i) = bin2dec(binary_str);
    end
    
    % Chuyển ASCII codes thành characters
    try
        text = char(ascii_codes);
        % Loại bỏ null characters nếu có
        text = text(text ~= 0);
    catch
        warning('Lỗi khi chuyển đổi ASCII codes thành text');
        text = '';
    end
    
    fprintf('Đã khôi phục text: "%s" từ %d bits\n', text, num_bits);
end
