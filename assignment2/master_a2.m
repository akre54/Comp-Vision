function [] = assignment_2()


C1 = zeros(3,4);
C2 = diag(diag(ones(3)))

[~] = part1(C1, C2);
[~] = part2();
[~] = part3();
[~] = part4();

end


% Find the Fundamental Matrix from 2 cameras
function [F] = part1(C1, C2)

    Cc1 = null(C1);  % find center of C1
    epi2 = C2 * CP1; % find epipole of c2
    
    epi_skew = [   0     -epi2(3)   epi2(2)
                 epi2(3)    0      -epi2(1)
                -epi2(2)  epi2(1)     0    ];
    
    F = epi_skew * C2 * pinv(C2)
end

function [P] = part2()

    world = dlmread('world.txt');
    image = dlmread('image.txt');
    
    % Add dimension to world and image points
    world_4d = reshape(world, [1, size(world)]);
    image_3d = reshape(image, [1, size(image)]);
    
    
    
    P = world;

end


function [P] = part3()

    load('sfm_points.mat');

end


function [P] = part4()

end