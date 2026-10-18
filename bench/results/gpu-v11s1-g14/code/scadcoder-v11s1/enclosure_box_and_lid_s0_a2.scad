// Two-part enclosure for small electronics board (e.g. Arduino-based logger)
// Print orientation: box standing on the bed, lid on top printed upside down

$fn = 64;

// ---- Box ----
box_x = 70;    // outer length (X)
box_y = 50;    // outer width (Y)
box_z = 30;    // outer height (Z)
box_wall = 2;  // wall thickness
box_floor = 2; // floor thickness

// ---- Lid ----
lip_x = 65.6;  // lip outer length (X)
lip_y = 45.6;  // lip outer width (Y)
lip_t = 1.5;   // lip thickness (Z)
lip_h = 4;     // lip height from plate top (Z)
plate_t = 2;   // plate thickness

// ---- Placement ----
gap = 10;      // gap between box and lid (X)

// Derived
box_inner_x = box_x - 2*box_wall;
box_inner_y = box_y - 2*box_wall;
lip_top_z = box_z + lip_h;   // for cutter to clear the lip top

module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        // open-top cavity (extends past top face)
        translate([box_wall, box_wall, box_floor])
            cube([box_inner_x, box_inner_y, box_z - box_floor + 0.5]);
    }
}

module lid() {
    translate([box_x + gap, 0, 0])
        difference() {
            union() {
                // base plate
                cube([lip_x, lip_y, plate_t]);
                // lip on top of plate
                translate([0, 0, plate_t])
                    cube([lip_x, lip_y, lip_t]);
            }
            // cutter from above so the lip is hollow (no coplanar faces)
            translate([0, 0, plate_t - 0.01])
                cube([lip_x, lip_y, lip_h + 0.5]);
        }
}

module enclosure() {
    union() {
        box();
        // lid must be above the box so it doesn't intrude into the cavity
        translate([0, 0, box_z - 0.01])
            lid();
    }
}

enclosure();