// Two-part enclosure for small electronics board
// Print orientation: box standing on the bed, lid flat on top

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_thk    = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height from plate

plate_t    = 2;     // lid plate thickness
eps        = 0.5;   // cutter overshoot

gap        = 10;    // gap between box and lid

$fn = 64;

// ---------------- Model ----------------
union() {
    // Box
    difference() {
        cube([box_x, box_y, box_z]);
        translate([-box_x/2, -box_y/2, box_floor])
            cube([box_x, box_y, box_z - box_floor + eps]);
    }

    // Lid (shifted up by gap, so it prints above the box)
    translate([0, 0, box_z + gap]) {
        union() {
            // Base plate
            translate([-lip_x/2, -lip_y/2, 0])
                cube([lip_x, lip_y, plate_t]);

            // Lip
            translate([-lip_x/2, -lip_y/2, plate_t])
                cube([lip_x, lip_y, lip_h]);
        }

        // Cut the lip opening (outer size 65.6 x 45.6, so 0.2 mm clearance)
        translate([-lip_x/2 - 0.1, -lip_y/2 - 0.1, -eps])
            cube([lip_x + 0.2, lip_y + 0.2, plate_t + eps]);
    }
}