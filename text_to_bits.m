function bits = text_to_bits(text)
    % CHUYỂN ĐỔI TEXT THÀNH CHUỖI BIT
    % Input: text - chuỗi ký tự cần chuyển đổi
    % Output: bits - mảng bit (0/1)
    
    if isempty(text)
        bits = [];
        return;
    end
    
    % Chuyển text thành mã ASCII
    ascii_codes = double(text);
    
    % Chuyển mỗi ký tự thành 8 bit
    num_chars = length(ascii_codes);
    bits = zeros(1, num_chars * 8);
    
    for i = 1:num_chars
        % Chuyển ASCII code thành binary (8 bit)
        binary_str = dec2bin(ascii_codes(i), 8);
        
        % Chuyển string thành array of numbers
        start_idx = (i-1) * 8 + 1;
        end_idx = i * 8;
        bits(start_idx:end_idx) = binary_str - '0'; % Chuyển '0','1' thành 0,1
    end
    
    fprintf('Đã chuyển đổi "%s" thành %d bits\n', text, length(bits));
end
