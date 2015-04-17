function showImageMatrix(img)

M=max(img);
scaledimg=img .* 1/M;
imshow(mat2gray(scaledimg));