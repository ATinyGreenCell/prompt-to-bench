// Snap-on clip: holds a piece of tubing next to a 12.7 mm lab stand rod
// Printed flat: 2-D profile in XY, extruded 10 mm in +Z

$fn = 128;

// ---------------- Parameters ----------------
rod_d      = 12.7;              // rod ring inner diameter
rod_wall   = 3;                 // rod ring wall thickness
rod_r      = rod_d / 2;         // rod ring outer radius (18.7 mm)
tubing_d   = 6;                 // tubing ring inner diameter
tubing_r   = tubing_d / 2;      // tubing ring outer radius
tubing_wall = 2;                // tubing ring wall thickness
bridge_w   = 6;                 // bridge width in X (from x = 8 to x = 12)
bridge_y   = 6;                 // bridge width in Y
height     = 10;                // extrusion height (Z)
eps        = 0.5;               // overshoot for clean cuts

// ---------------- Derived ----------------
rod_od     = rod_d + 2 * rod_wall;   // 18.7 mm

// ---------------- Modules ----------------
// 2-D ring with an opening on the specified side
module ring_with_gap(inner_d, wall, gap_w, side) {
    r_out = inner_d / 2 + wall;
    r_in  = inner_d / 2;
    // Open half the gap on each side of the axis
    open_half = gap_w / 2;

    difference() {
        circle(r_out);
        circle(r_in);
        // Cut out the rectangular opening
        translate([side > 0 ? r_in : -r_out, -open_half])
            square([r_out + eps - side > 0 ? r_out + eps - side : gap_w, gap_w]);
    }
}

// Solid rectangle joining two X positions
module bridge(x1, x2) {
    translate([x1, -bridge_y / 2, 0])
        cube([x2 - x1, bridge_y, height]);
}

// ---------------- Part ----------------
difference() {
    union() {
        ring_with_gap(rod_d, rod_wall, 10, -1);   // rod ring, opening on -X
        ring_with_gap(tubing_d, tubing_wall, 4.5, 1);  // tubing ring, opening on +X
        bridge(8, 12);                            // joining bridge
    }
    translate([0, 0, -eps])
        cube([rod_od + 2 * eps, 16, eps]);        // support block for print
}

translate([0, 0, height])
    linear_extrude(height = eps)
        intersection() {
            translate([-rod_od / 2 - 1, -8, 0])
                cube([rod_od + 2, 16, height + eps]);
            // keep only the snap-on lip (x < 0, -5 < y < 5)
            translate([-rod_od / 2 - 1, -5, 0])
                cube([rod_d + 2 * eps, 10, height + eps]);
        }