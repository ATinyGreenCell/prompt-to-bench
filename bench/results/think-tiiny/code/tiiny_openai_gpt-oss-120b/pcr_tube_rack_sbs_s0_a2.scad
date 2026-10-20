// Dimensions (mm)
X = 127.76;               // block length along X
Y = 85.48;                // block width  along Y
Z = 20;                   // block height along Z
hole_d = 6.2;             // diameter of tube holes
spacing = 9.0;            // centre‑to‑centre spacing of holes
first_x = 14.38;          // X offset of first hole (A1) from left edge
first_y = 11.24;          // Y offset of first hole (A1) from back edge
cols = 12;                // number of hole columns
rows = 8;                 // number of hole rows
chamfer_leg = 5.0;        // leg length of 45° chamfer
chamfer_extend = 0.01;    // extra extension to avoid coplanar faces

$fn = 64; // smoothness for cylinders and extrusions

module rack() {
    // Base block (centered on origin, rests on Z = 0)
    block = translate([-X/2, -Y/2, 0]) cube([X, Y, Z]);

    // Through holes (extend 1 mm beyond each face)
    holes = union() {
        for (c = [0:cols-1])
            for (r = [0:rows-1])
                translate([
                    -X/2 + first_x + c*spacing,
                    -Y/2 + first_y + r*spacing,
                    Z/2
                ]) cylinder(d = hole_d, h = Z + 2, center = true);
    };

    // 45° chamfer at the left‑back corner (A1) as an orientation mark
    chamfer = translate([
                    -X/2 - chamfer_extend,
                    -Y/2 - chamfer_extend,
                    0
                ])
        linear_extrude(height = Z + 2, center = false)
            polygon(points = [
                [0, 0],
                [chamfer_leg, 0],
                [0, chamfer_leg]
            ]);

    // Final part: block minus holes minus chamfer
    difference() {
        block;
        holes;
        chamfer;
    }
}

// Render the rack
rack();