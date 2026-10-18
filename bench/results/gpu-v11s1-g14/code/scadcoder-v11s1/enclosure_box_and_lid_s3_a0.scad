// Two-part enclosure for small electronics board
// Print orientation: box on bed (z = 0), lid on +X side, printed upside down

// ---------- Parameters ----------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness

gap        = 10;    // gap between box and lid

lip_wall   = 1.5;   // lid lip wall thickness
lip_h      = 4;     // lid lip height
lip_x      = 65.6;  // lid lip outer length (X)
lip_y      = 45.6;  // lid lip outer width (Y)
lip_over   = 0.2;   // lip overhang past box opening (each side)

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
box_inner_x = box_x - 2 * box_wall;
box_inner_y = box_y - 2 * box_wall;
box_inner_z = box_z - box_floor;   // open-top cavity height

// ---------- Model ----------
union() {
    // Box
    difference() {
        cube([box_x, box_y, box_z]);
        translate([box_wall, box_wall, box_floor])
            cube([box_inner_x, box_inner_y, box_inner_z + 0.01]); // closed top for clean cut
    }

    // Lid (printed upside down: plate on bed, lip on top)
    union() {
        // Plate
        translate([box_x + gap, 0, 0])
            cube([lip_x, lip_y, lip_wall]);

        // Lip, overlapping the plate for a solid union
        translate([box_x + gap - lip_over,
                   lip_y / 2 - lip_over,
                   lip_wall])
            cube([lip_x + 2 * lip_over,
                  lip_y + 2 * lip_over,
                  lip_h]);
    }
}