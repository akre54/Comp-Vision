% Computer Vision Assignment 3
% Adam Krebs (Spring 2012)
% 
% Driver script - calls and runs parts 1 and 2


function [] = master_a3()

% initialization
river = imread('part1_1.jpg');
ein = imread('einstein.jpg');

% use ~ to suppress output
[~] = part1();
[~] = part2();


end