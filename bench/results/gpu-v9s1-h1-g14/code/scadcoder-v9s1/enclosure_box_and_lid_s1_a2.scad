// Two-part enclosure for small electronics board (e.g., Arduino-based logger)
// Print orientation: both parts on the bed, lid on the +X side of the box,
// with a 10 mm gap between them. The lid is printed upside down so its lip
// hangs into the box opening.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

lip_w      = 65.6;  // lid lip outer size in X (mm)
lip_y      = 45.6;  // lid lip outer size in Y (mm)
lip_t      = 1.5;   // lid lip thickness (mm)
lip_h      = 4;     // lid lip height / wall above plate (mm)

eps        = 0.2;   // clearance between lip and box opening (mm)
gap        = 10;    // gap between box and lid on the bed (mm)
plate_t    = 2;     // lid plate thickness (mm)

overcut    = 0.5;   // extra length on cutting shapes past faces (mm)

$fn = 32;

// ---------------- Derived ----------------
box_inner_x = box_x - 2 * box_wall;   // 66 mm
box_inner_y = box_y - 2 * box_wall;   // 46 mm
// Lip overall size includes the overcut wall on each side:
// wall thickness (lip_t) + clearance (eps) + inner dimension
lip_over_x  = lip_t + eps + box_inner_x;  // 73.0 mm
lip_over_y  = lip_t + eps + box_inner_y;  // 48.0 mm

// ---------------- Modules ----------------
module box() {
    // Open-top box: full outer cube, cut out the interior up to the top face.
    // The floor (box_floor) and side walls (box_wall) remain.
    difference() {
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, box_z]);
        translate([-box_inner_x / 2 - overcut, -box_inner_y / 2 - overcut, box_floor])
            cube([box_inner_x + 2 * overcut,
                  box_inner_y + 2 * overcut,
                  box_z - box_floor + overcut]);
    }
}

module lid() {
    // Plate with a rectangular lip on top, centred on the plate.
    // Printed upside down: plate on the bed, lip hanging into the box.
    translate([-lip_over_x / 2, -lip_over_y / 2, 0])
        union() {
            // Base plate
            cube([lip_w, lip_y, plate_t]);
            // Lip: wall from plate top up to lip_h
            translate([-lip_w / 2, -lip_y / 2, plate_t])
                cube([lip_w, lip_y, lip_h]);
        }
}

// ---------------- Assembly ----------------
box();
translate([box_x / 2 + gap, 0, 0])
    lid();