// Two-part enclosure for small electronics board
// Print orientation: box on bed (z = 0), lid on +X side, printed upside down

// ---------- Parameters ----------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness
box_open   = box_x - 2*box_wall : box_y - 2*box_wall : box_z - box_floor; // opening size

lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_wall   = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height from plate (Z)
lip_z0     = box_z - 0.01; // lip starts just below box top to avoid coplanar faces

plate_x    = lip_x; // plate length (X)
plate_y    = lip_y; // plate width (Y)
plate_t    = 2;     // plate thickness (Z)

gap        = 10;    // gap between box and lid (X)
eps        = 0.5;   // cutter overshoot

$fn = 64;

// ---------- Model ----------
union() {
    // Box
    difference() {
        cube([box_x, box_y, box_z]);
        translate([box_wall, box_wall, box_floor])
            cube(box_open);
    }

    // Lid: plate + lip, centred on origin in X/Y, placed on +X side of box
    translate([gap, 0, 0]) {
        union() {
            // Plate
            translate([-plate_x/2, -plate_y/2, 0])
                cube([plate_x, plate_y, plate_t]);

            // Lip on top of plate
            translate([-lip_x/2, -lip_y/2, lip_z0])
                cube([lip_x, lip_y, lip_h]);
        }

        // Cut lip pocket (extends past top face of plate)
        translate([-lip_x/2, -lip_y/2, 0])
            cube([lip_x - 0.4, lip_y - 0.4, plate_t + eps]);
    }
}