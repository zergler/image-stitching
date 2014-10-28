#------------------------------------------------------------------------------
# File:         test.m
# Author:       Igor Janjic
# Description:  Octave script that stitches the two wall test images.
##-----------------------------------------------------------------------------

# Clear the screen and workspace.
clear; clc;

# Read in the points from a file.
pointsDelim = ' ';

pointsWall1Filename = 'pointsWall1.txt';
pointsWall2Filename = 'pointsWall2.txt';

pointsTapestry1Filename = 'pointsTapestry1.txt';
pointsTapestry2Filename = 'pointsTapestry2.txt';

wall1Filename = 'Wall1.png';
wall2Filename = 'Wall2.png';
tapestry1Filename = 'Tapestry1.png';
tapestry2Filename = 'Tapestry2.png';

# Grab the points for the wall image.
wallP1 = importdata(pointsWall1Filename, pointsDelim);
wallP2 = importdata(pointsWall2Filename, pointsDelim);

# Make sure the wall text files contain valid data.
[wallm1, walln1] = size(wallP1);
[wallm2, walln2] = size(wallP2);
wallm = wallm1;
walln = walln1;

if (walln1 != 2) || (walln2 != 2)
  error('error: points file does not contain valid data.')
end
if wallm1 != wallm2
  error('error: points files do not contain the same number of points.')
end

wallP = zeros(wallm, walln, 2);
wallP(:, :, 1) = wallP1;
wallP(:, :, 2) = wallP2;

# Grab the points for the tapestry image.
tapestryP1 = importdata(pointsTapestry1Filename, pointsDelim);
tapestryP2 = importdata(pointsTapestry2Filename, pointsDelim);

# Make sure the tapestry text files contain valid data.
[tapestrym1, tapestryn1] = size(tapestryP1);
[tapestrym2, tapestryn2] = size(tapestryP2);
tapestrym = tapestrym1;
tapestryn = tapestryn1;

if (tapestryn1 != 2) || (tapestryn2 != 2)
  error('error: points file does not contain valid data.')
end
if tapestrym1 != tapestrym2
  error('error: points files do not contain the same number of points.')
end

tapestryP = zeros(tapestrym, tapestryn, 2);
tapestryP(:, :, 1) = tapestryP1;
tapestryP(:, :, 2) = tapestryP2;

# Read in the image.
wall1 = imread(wall1Filename);
wall2 = imread(wall2Filename);

tapestry1 = imread(tapestry1Filename);
tapestry2 = imread(tapestry2Filename);

# Create the mosaics.
wallMosaic     = mosaic(wall1, wall2, wallP);
tapestryMosaic = mosaic(tapestry1, tapestry2, tapestryP);

# Show the final image.
imwrite(wallMosaic, 'WallMosaic.png');
imwrite(tapestryMosaic, 'TapestryMosaic.png');
imshow(tapestryMosaic)
