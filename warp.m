#------------------------------------------------------------------------------
# File:         warp.m
# Author:       Igor Janjic
# Description:  Octave script that warps an image to another image frame.
##-----------------------------------------------------------------------------
function [A2, oi] = warp(H, A1)

# Determine the dimensions of the images.
[m, n, l] = size(A1);

# Find the corner points (x, y) of the original image.
s = zeros(4, 2);
s(1, :) = [1, 1];
s(2, :) = [n, 1];
s(3, :) = [n, m];
s(4, :) = [1, m];

# Map the corners to the second image frame using forward warping.
sh   = [s'; ones(1, 4)];
sph  = H*sh;
sphh = sph./sph(3, :);
sp   = sphh(1:2, :)';

# Get the origin.
oi = [sp(1, 1); sp(1, 2)];
#oi = [0; 0]

# Get the output image dimensions.
minxp = min(sp(:, 1));
maxxp = max(sp(:, 1));
minyp = min(sp(:, 2));
maxyp = max(sp(:, 2));
np = round(maxxp - minxp);
mp = round(maxyp - minyp);
lp = l;

# Initialize the output image.
B = zeros(mp, np, lp);
[X, Y] = meshgrid(1:np, 1:mp);
X = reshape(X, [1, prod(size(X))]);
Y = reshape(Y, [1, prod(size(Y))]);

# Construct the points to be inverse warpped.
P  = [X; Y];
P  = P + oi;
Ph = [P; ones(1, length(X))];

# Do the inverse warping.
PPh = inv(H)*Ph;
PPhh = PPh./PPh(3, :);
PP = PPhh(1:2, :);
Xp = PP(1, :);
Yp = PP(2, :);

Xp = reshape(Xp, [mp, np]);
Yp = reshape(Yp, [mp, np]);

# Get the color from the original image frame.
A2(:, :, 1) = interp2(A1(:, :, 1), Xp, Yp);
A2(:, :, 2) = interp2(A1(:, :, 2), Xp, Yp);
A2(:, :, 3) = interp2(A1(:, :, 3), Xp, Yp);
