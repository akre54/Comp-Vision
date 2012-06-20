% Part 3: Scale-Invariance
% 
% by Adam Krebs (Spring 2012)


function [res] = part3(im)

    if nargin ~= 1
        im = imread('einstein.jpg');
    end

    % resize image by half
    im_half = imresize(im, 0.5);

    for sigma = 3:0.4:15
        temp_ein = conv2(double(im), lp(sigma), 'same');
        temp_half = conv2(double(im_half), lp(sigma), 'same');
        gradI = combine(temp_ein, sigma, lp(sigma));
        gradI_half = combine(temp_half, sigma, lp(sigma));
        gradIn = (sigma^2)* combine(temp_ein, sigma, lp(sigma));
        gradIn_half = (sigma^2)* combine(temp_half, sigma, lp(sigma));
    end

end

% Generate a Laplacian filter
function [filt] = lp(sigma)
    filt = fspecial('gaussian', (sigma*6), sigma);
end

function [output] = combine(img, sigma, filt)
    % Convolve image and combine
    dxx = [1 -2 1];
    dyy = [1 -2 1];
    Sxx = conv2(lp(sigma), dxx, 'same');
    s1 = Sxx .* img;
    Syy = conv2(lp(sigma), dyy, 'same');
    s2 = Syy .* img;
    
    % overlay image
    output = s1 + s2;

    mesh(output);
    hold on;
end