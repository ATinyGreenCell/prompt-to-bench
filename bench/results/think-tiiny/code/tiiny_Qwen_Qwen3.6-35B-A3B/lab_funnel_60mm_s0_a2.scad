$fn = 64;

// Spout dimensions
SPOUT_OD = 10;        // Outer diameter of the straight tube
SPOUT_H = 20;         // Height of the straight tube

// Cone dimensions
CONE_BOT_OD = 10;     // Outer diameter at the base of the cone (z=20)
CONE_TOP_OD = 60;     // Outer diameter at the rim (z=50)
CONE_H = 30;          // Height of the cone section

// Wall thickness
WALL = 1.6;           // Uniform wall thickness

// Derived radii
SPOUT_R = SPOUT_OD / 2;
SPOUT_IR = SPOUT_R - WALL;
CONE_BOT_R = CONE_BOT_OD / 2;
CONE_TOP_R = CONE_TOP_OD / 2;
CONE_BOT_IR = CONE_BOT_R - WALL;
CONE_TOP_IR = CONE_TOP_R - WALL;

difference() {
    union() {
        cylinder(r = SPOUT_R, h = SPOUT_H);
        translate([0, 0, SPOUT_H]) {
            cylinder(r1 = CONE_BOT_R, r2 = CONE_TOP_R, h = CONE_H);
        }
    }
    union() {
        translate([0, 0, -0.5]) {
            cylinder(r = SPOUT_IR, h = SPOUT_H + 1);
        }
        translate([0, 0, SPOUT_H]) {
            cylinder(r1 = CONE_BOT_IR, r2 = CONE_TOP_IR, h = CONE_H + 1);
        }
    }
}