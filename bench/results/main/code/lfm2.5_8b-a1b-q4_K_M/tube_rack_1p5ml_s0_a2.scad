// Dimensions of the bench rack
BLOCK_X = 106;
BLOCK_Y = 72;
BLOCK_Z = 30;

// Hole parameters
HOLE_DIAMETER = 11.2;
HOLE_DEPTH = 25;
OFFSET = 0.01;

N_X = 6;
N_Y = 4;
HOLES_PER_X = N_X;
HOLES_PER_Y = N_Y;

cube(BLOCK_X, BLOCK_Y, BLOCK_Z);

for(y=1:N_Y) {
    for(x=1:N_X) {
        xc = (N_X - 0.5) * (BLOCK_X / N_X);
        yc = (N_Y - 0.5) * (BLOCK_Y / N_Y);
        cylinder(HOLE_DIAMETER, HOLE_DEPTH, OFFSET);
        translate(xc, yc, 0) cylinder(HOLE_DIAMETER, HOLE_DEPTH, OFFSET);
    }
}