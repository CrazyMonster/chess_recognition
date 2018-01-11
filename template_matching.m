clear;
close all;

% cells
Q = im2double(imread('datasets/1/tmp_G/cells/029/6x1.jpg'));
%n = im2double(imread('datasets/1/tmp_G/cells/029/8x3.jpg'));

% template
[~, ~, T_Q1] = (imread('templates/images/k.w.png'));
[~, ~, T_Q2] = (imread('templates/images/k.b.png'));
%T_n = imread('datasets/1/tmp_G/cells/029/8x3.png');

T_Q1 = im2double(~T_Q1);
T_Q2 = im2double(~T_Q2);



out1 = imfilter(Q, T_Q1);
out2 = imfilter(Q, T_Q2);
%out2 = imfilter(n, T_n);

%figure;imagesc(out1);
%figure;imagesc(out2);


avg = mean2(T_Q1);
T_Q12 = T_Q1-avg;
Q2 = Q-avg;

avg2 = mean2(T_Q2);
T_Q22 = T_Q2-avg2;
Q22 = Q-avg2;


out3 = imfilter(T_Q12, Q2);
out4 = imfilter(T_Q22, Q22);
figure;imagesc(out3);
figure;imagesc(out4);

figure; imshow(Q);
figure; imagesc(T_Q1);
figure; imagesc(T_Q2);