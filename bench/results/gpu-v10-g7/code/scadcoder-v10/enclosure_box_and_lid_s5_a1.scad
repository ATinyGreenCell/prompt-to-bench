// Two-part enclosure for small electronics board
// Print orientation: box upright, lid upside down (lip on top)

// ---- Parameters ----
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box height (Z)
box_w      = 2;     // box wall thickness
box_floor  = 2;     // box floor thickness
gap        = 10;    // gap between box and lid
lip_t      = 1.5;   // lid lip thickness (wall)
lip_h      = 4;     // lid lip height
eps        = 0.5;   // cutter overshoot

$fn = 64;

// ---- Derived ----
box_id_x = box_x - 2*box_w;   // inner length
box_id_y = box_y - 2*box_w;   // inner width
lip_w    = box_id_x - 0.4;    // lip outer length (0.2 clearance each side)
lip_d    = box_id_y - 0.4;    // lip outer width (0.2 clearance each side)

// ---- Model ----
union() {
    // Box
    translate([-box_x/2, -box_y/2, 0])
        cube([box_x, box_y, box_floor]);
    translate([-box_x/2, -box_y/2, box_floor])
        cube([box_x, box_y, box_z - box_floor]);

    // Lid (plate + lip), centred on origin, placed on +X side
    translate([gap, 0, 0])
        union() {
            // Plate
            cube([box_x, box_y, lip_t]);
            // Lip
            translate([0, -lip_d/2, 0])
                cube([lip_w, lip_d, lip_h]);
        }
}