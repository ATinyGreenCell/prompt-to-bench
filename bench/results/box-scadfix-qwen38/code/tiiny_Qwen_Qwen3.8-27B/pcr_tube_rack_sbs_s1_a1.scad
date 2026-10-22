// 96-well PCR tube rack (0.2 mL) on standard microplate footprint
// Print orientation: rests on XY plane, builds +Z, centred on origin in X and Y

// ---- Block dimensions (ANSI/SLAS microplate footprint) ----
L = 127.76;   // length, along X (mm)
W = 85.48;    // width,  along Y (mm)
H = 20.0;     // height, along Z (mm)

// ---- Hole grid ----
nrows  = 8;   // rows along Y
ncols  = 12;  // columns along X
pitch  = 9.0; // centre-to-centre spacing (mm)
d_hole = 6.2; // hole diameter (mm)

// ---- Chamfer (orientation mark at A1 corner) ----
chamfer_leg = 5.0; // leg length of the 45° chamfer (mm)

// ---- Derived grid geometry (centres, relative to block origin) ----
// A1 (first hole) is 14.38 mm from left edge (X) and 11.24 mm from back edge (Y)
x0 = 14.38;
y0 = 11.24;

// ---- Chamfer corner in block coordinates ----
// A1 corner = left edge (X=0) + back edge (Y=0)
cx = 0.0;
cy = 0.0;

// ---- Chamfer cutter (45° wedge, 5 mm legs, extends 1 mm past each face) ----
// Triangle in XY: (cx, cy), (cx+leg, cy), (cx, cy+leg)
// Extruded from z=-1 to z=H+1 so it cleanly cuts the top and bottom faces.
module chamfer_cutter() {
    linear_extrude(height = H + 2.0, center = false) {
        polygon(points = [
            [cx,        cy],
            [cx + chamfer_leg, cy],
            [cx,        cy + chamfer_leg]
        ]);
    }
}

// ---- Hole cutter (extends 1 mm past top and bottom faces) ----
module hole_cutter() {
    cylinder(h = H + 2.0, r = d_hole / 2.0, $fn = 64);
}

// ---- Main body ----
module rack() {
    difference() {
        // Base block, centred on origin in X and Y
        translate([-L/2, -W/2, 0]) {
            cube([L, W, H]);
        }

        // 96 through-holes
        for (i = [0 : nrows-1]) {
            for (j = [0 : ncols-1]) {
                // Hole centre in block coords, then shift to centred frame
                hx = x0 + j * pitch;
                hy = y0 + i * pitch;
                translate([hx - L/2, hy - W/2, -1.0]) {
                    hole_cutter();
                }
            }
        }

        // 45° chamfer at A1 corner (left-back vertical edge)
        translate([-L/2, -W/2, -1.0]) {
            chamfer_cutter();
        }
    }
}

rack();