%% CHƯƠNG TRÌNH DEMO GIẤU TIN THUẬN NGHỊCH TRONG ẢNH
% Đề tài: Reversible Data Hiding trong ảnh số
% Thuật toán: Difference Expansion (DE) và Histogram Shifting (HS)
% Tác giả: [Tên sinh viên]
% Ngày: September 2025

clear all; close all; clc;

%% THIẾT LẬP CHƯƠNG TRÌNH
fprintf('========================================\n');
fprintf('DEMO GIẤU TIN THUẬN NGHỊCH TRONG ẢNH\n');
fprintf('========================================\n\n');

% Menu lựa chọn thuật toán
fprintf('Chọn thuật toán:\n');
fprintf('1. Difference Expansion (DE)\n');
fprintf('2. Histogram Shifting (HS)\n');
fprintf('3. So sánh cả hai thuật toán\n');
choice = input('Nhập lựa chọn (1-3): ');

% Menu lựa chọn ảnh
fprintf('\nChọn ảnh test:\n');
fprintf('1. Lena (512x512)\n');
fprintf('2. Cameraman (256x256)\n');
fprintf('3. Ảnh tùy chỉnh\n');
img_choice = input('Nhập lựa chọn (1-3): ');

%% TẠI ẢNH TEST
switch img_choice
    case 1
        % Tạo ảnh Lena test
        img = create_test_lena();
        img_name = 'Lena';
    case 2
        % Tạo ảnh Cameraman test  
        img = create_test_cameraman();
        img_name = 'Cameraman';
    case 3
        [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, 'Chọn ảnh');
        if filename ~= 0
            img = imread(fullfile(pathname, filename));
            if size(img, 3) == 3
                img = rgb2gray(img);
            end
            img = double(img);
            [~, name, ~] = fileparts(filename);
            img_name = name;
        else
            error('Không có ảnh được chọn!');
        end
    otherwise
        error('Lựa chọn không hợp lệ!');
end

% Chuẩn bị dữ liệu giấu
secret_message = 'Hello World! This is a secret message for RDH demo.';
secret_bits = text_to_bits(secret_message);

fprintf('\nẢnh gốc: %s (%dx%d)\n', img_name, size(img,1), size(img,2));
fprintf('Thông tin cần giấu: "%s"\n', secret_message);
fprintf('Số bit cần giấu: %d bits\n\n', length(secret_bits));

%% THỰC HIỆN THUẬT TOÁN
switch choice
    case 1
        demo_difference_expansion(img, secret_bits, img_name);
    case 2
        demo_histogram_shifting(img, secret_bits, img_name);
    case 3
        demo_comparison(img, secret_bits, img_name);
    otherwise
        error('Lựa chọn không hợp lệ!');
end

fprintf('\n========================================\n');
fprintf('DEMO HOÀN THÀNH!\n');
fprintf('========================================\n');
