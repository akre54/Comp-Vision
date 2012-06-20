% Computer Vision Assignment 1
% Adam Krebs (Spring 2012)
% 
% Driver script - calls and runs assignments 1, 2, 3, and 4


function [] = master_a1()

% initialization
river = imread('part1_1.jpg');
ein = imread('einstein.jpg');

% use ~ to suppress output
[~] = part1(river);
[~] = part2(ein,5e-4,3,3);
[~] = part3;
[~] = part4();


end