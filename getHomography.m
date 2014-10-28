#------------------------------------------------------------------------------
# File:         getHomography.m
# Author:       Igor Janjic
# Description:  Octave function that computes the homography matrix.
##-----------------------------------------------------------------------------

function H = getHomography(P)

m = size(P, 1);

# Construct the b (2m x 1) matrix.
b = zeros(2*m, 1);
b(1:2:end, 1) = P(:, 1, 2);
b(2:2:end, 1) = P(:, 2, 2);

# Construct the A (2n x 8) matrix.
A = zeros(2*m, 8);
A(1:2:end, 1:3) = horzcat(P(:, :, 1), ones(m, 1));
A(2:2:end, 4:6) = A(1:2:end, 1:3);
A(:, 7) = -P([ceil([1:(2*m)]./2)], 1, 1).*b;
A(:, 8) = -P([ceil([1:(2*m)]./2)], 2, 1).*b;

# Compute the homography matrix h in Ah = b.
h = A\b;

# Convert h (8 x 1) to H (3 x 3).
H = reshape(vertcat(h, 1), [3, 3])';

# Test a few points to see if H is correct.
t1 = [470; 494]; # <-> [346; 162]
t1h = vertcat(t1, 1);
t1ph = H*t1h;
t1phh = round(t1ph./t1ph(end));
t1p = t1phh(1:end-1);
