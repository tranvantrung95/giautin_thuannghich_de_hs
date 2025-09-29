function binary_string = text_to_binary(text)
% TEXT_TO_BINARY - Chuyển đổi text thành chuỗi bit
% Sử dụng encoding cực kỳ đơn giản: 8-bit length + 16-bit per char

try
    if isempty(text)
        binary_string = '';
        return;
    end
    
    % Giới hạn độ dài text (tối đa 255 ký tự)
    if length(text) > 255
        error('Text quá dài. Tối đa 255 ký tự.');
    end
    
    % Chuyển mỗi character thành 16-bit trước
    char_codes = double(text);
    data_binary = '';
    
    for i = 1:length(char_codes)
        char_code = char_codes(i);
        binary_char = dec2bin(char_code, 16);
        data_binary = [data_binary, binary_char];
    end
    
    % Tạo 8-bit độ dài ở cuối (bảo vệ header)
    length_header = dec2bin(length(text), 8);
    
    % Kết hợp: data + 8-bit length (header ở cuối)
    binary_string = [data_binary, length_header];
    
    fprintf('Chuyển đổi text thành binary:\n');
    fprintf('Text: "%s"\n', text);
    fprintf('Length: %d chars -> Total bits: %d (%d data bits + 8-bit protected header)\n', ...
        length(text), length(binary_string), length(data_binary));
    
catch err
    error('Lỗi trong text_to_binary: %s', err.message);
end
end

