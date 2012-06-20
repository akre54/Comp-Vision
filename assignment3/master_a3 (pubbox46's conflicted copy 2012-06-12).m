% Computer Vision Assignment 3
% Adam Krebs (Spring 2012)
% 
% Driver script - calls and runs parts 1, 2, 3, and 4


function [] = master_a3()

% initialization
river = imread('part1_1.jpg');
ein = imread('einstein.jpg');

% use ~ to suppress output
[~] = part1(river);
[~] = part2(ein,5e-4,3,3);
[~] = part3;
[~] = part4();


end