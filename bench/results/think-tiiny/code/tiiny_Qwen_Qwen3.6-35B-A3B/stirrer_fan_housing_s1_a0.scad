$fn = 64;

// Dimensions
OUTER_X = 90;
OUTER_Y = 90;
TOP_Z = 2;
WALL_THICK = 2.5;
WALL_H = 40;
PITCH = 71.5;
HOLE_R = 2.25;
NOTCH_W = 12;
NOTCH_H = 8;
NOTCH_Z_START = WALL_H - NOTCH_H;

// Base plate
base = translate([0, 0, 0]) cube([OUTER_X, OUTER_Y, TOP_Z], center=false);

// Walls (hollow box rising from top plate)
outer_walls = translate([0, 0, TOP_Z]) cube([OUTER_X, OUTER_Y, WALL_H - TOP_Z], center=false);
inner_void = translate([0, 0, TOP_Z]) cube([OUTER_X - 2*WALL_THICK + 0.02, OUTER_Y - 2*WALL_THICK + 0.02, WALL_H - TOP_Z + 0.01], center=false);

// Combine base and walls
housing = union() {
    base;
    difference() {
        outer_walls;
        inner_void;
    }
};

// Screw holes (cut from top face at z=2)
screw_holes = for (x = [-PITCH/2, PITCH/2], y = [-PITCH/2, PITCH/2])
    translate([x, y, 2]) cylinder(r=HOLE_R, h=0.1, center=false);

// Cable notch (cuts through Y=45 wall)
notch_cut = translate([0, 45 - WALL_THICK - 0.01, NOTCH_Z_START]) 
            cube([NOTCH_W, WALL_THICK + 0.02, NOTCH_H], center=false);

// Final part
difference() {
    housing;
    screw_holes;
    notch_cut;
}