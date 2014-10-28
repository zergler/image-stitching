#------------------------------------------------------------------------------
# File:         mosaic.m
# Author:       Igor Janjic
# Description:  Creates a mosaic from two images.
##-----------------------------------------------------------------------------
function M = mosaic(I1, I2, P);

# Compute the homography matrix.
H = getHomography(P);

# Transform the points in wall1 to wall2 image plane.
[I1p, oi] = warp(H, I1);
oi  = round(oi);
oia = abs(oi);
#imshow(uint8(wall1p))

# Get sizes of the images.
[m, n, l]    = size(I2);
[mm, nm, lm] = size(I1p);

# Convert origin pixel coordinates to matlab matrix coordinates.
oiai    = [0; 0];
oiai(1) = oia(2);
oiai(2) = oia(1);

# Construct each image.
M1 = zeros(oiai(1) + m, oiai(2) + n, 3);
M2 = zeros(oiai(1) + m, oiai(2) + n, 3);
M1(1:mm, 1:nm, :) = I1p;
M2(oiai(1):(oiai(1) + m - 1), oiai(2):(oiai(2) + n - 1), :) = M2(oiai(1):(oiai(1) + m - 1), oiai(2):(oiai(2) + n - 1), :) + I2;

# Find the intersection of the two images.
mask = (M1 ~= 0) & (M2 ~= 0);
ind = find(mask == 1);

# Mosaic the two together.
M = M1 + M2;
M(ind) = M(ind)/2;
M = uint8(M);
