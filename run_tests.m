function run_tests()
% RUN_TESTS - Kiểm thử tự động cho RDH (HS & DE)

tests = {@test_hs_gray, @test_de_gray, @test_color_y, @test_capacity_error};
passed = 0;

fprintf('==============================\n');
fprintf(' CHẠY BỘ KIỂM THỬ RDH\n');
fprintf('==============================\n');

for k = 1:numel(tests)
    test_fn = tests{k};
    name = func2str(test_fn);
    try
        test_fn();
        fprintf('✓ %s\n', name);
        passed = passed + 1;
    catch err
        fprintf('✗ %s\n   -> %s\n', name, err.message);
    end
end

fprintf('\nTổng kết: %d/%d test vượt qua.\n', passed, numel(tests));
if passed ~= numel(tests)
    error('Có test thất bại, vui lòng kiểm tra log ở trên.');
end
end

%% Test cases
function test_hs_gray()
    img = create_demo_image();
    secret = 'Hello RDH!';
    bits = text_to_binary(secret);
    [wm, info] = embed_HS(img, bits);
    [recovered, extracted_bits] = extract_HS(wm, info);
    assert(isequal(recovered, img), 'HS grayscale: ảnh khôi phục không khớp.');
    assert(strcmp(binary_to_text(extracted_bits), secret), 'HS grayscale: dữ liệu trích xuất sai.');
end

function test_de_gray()
    img = create_demo_image();
    secret = 'DE test';
    bits = text_to_binary(secret);
    [wm, info] = embed_DE(img, bits);
    [recovered, extracted_bits] = extract_DE(wm, info);
    assert(isequal(recovered, img), 'DE grayscale: ảnh khôi phục không khớp.');
    assert(strcmp(binary_to_text(extracted_bits), secret), 'DE grayscale: dữ liệu trích xuất sai.');
end

function test_color_y()
    % Ảnh màu đồng nhất để đảm bảo peak lớn
    color_img = uint8(cat(3, ones(64)*150, ones(64)*120, ones(64)*200));
    secret = 'HS';
    bits = text_to_binary(secret);
    [wm, info] = embed_HS(color_img, bits);
    [recovered, extracted_bits] = extract_HS(wm, info);
    assert(isequal(recovered, color_img), 'HS color: ảnh khôi phục không khớp.');
    assert(strcmp(binary_to_text(extracted_bits), secret), 'HS color: dữ liệu trích xuất sai.');
end

function test_capacity_error()
    tiny_img = uint8(ones(8, 8) * 120);
    long_secret = repmat('A', 1, 50); % 50 chars -> 808 bit
    bits = text_to_binary(long_secret);
    try
        embed_HS(tiny_img, bits);
        error('Không phát sinh lỗi dung lượng như mong đợi.');
    catch err
        assert(contains(err.message, 'Dung lượng không đủ'), 'Thông báo lỗi dung lượng không đúng.');
    end
end
