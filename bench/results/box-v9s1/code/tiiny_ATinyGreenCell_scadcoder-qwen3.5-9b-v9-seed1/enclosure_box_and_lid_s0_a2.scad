// Two-part enclosure: box (left) and lid (right), printed side by side
// Units: mm

// ---- Box ----
box_outer_x = 70;    // outer length (X)
box_outer_y = 50;    // outer width (Y)
box_outer_z = 30;    // outer height (Z)
wall        = 2;     // side wall thickness
floor       = 2;     // floor thickness under open top

// ---- Lid ----
lip_x      = 65.6;   // lip outer length (X)
lip_y      = 45.6;   // lip outer width (Y)
lip_h      = 4;      // lip height above plate
lip_t      = 1.5;    // lip thickness (wall)
plate_t    = 2;      // plate thickness under lip
gap        = 0.2;    // clearance between lip and box opening

// ---- Misc ----
eps        = 0.5;    // cutter overshoot past faces
$fn        = 64;

// Derived
box_v  = box_outer_x * box_outer_y * box_outer_z;   // box volume
lip_v  = lip_x * lip_y * (lip_h + lip_t);            // lip volume
area   = lip_x * lip_y;                              // lip area

// Model
union() {
    // Box: solid outer block, open top (cut down to floor level)
    translate([-box_outer_x / 2, -box_outer_y / 2, 0])
        difference() {
            cube([box_outer_x, box_outer_y, box_outer_z]);
            translate([0, 0, floor])
                cube([box_outer_x - 2 * wall, box_outer_y - 2 * wall,
                      floor + eps]);                  // open-top cut
        }

    // Lid: plate on bed, lip on top of plate, centred on plate
    translate([-lip_x / 2, -lip_y / 2, 0])
        union() {
            translate([0, 0, -plate_t])
                cube([lip_x, lip_y, 2 * plate_t]);     // plate (through)
            translate([0, 0, plate_t])
                cube([lip_x, lip_y, lip_t]);           // lip
        }
}

// Check (commented out)
// translate([0, 0, -eps])
//     difference() {
//         translate([0, 0, 0])
//             cube([box_v, 1, 1]);                     // box volume
//         translate([0, 0, plate_t])
//             cube([area, lip_h + eps, 1]);           // lip volume
//     }
// translate([0, 0, -eps])
//     difference() {
//         translate([0, 0, 0])
//             cube([box_outer_x * box_outer_y, 1, 1]); // outer area
//         translate([0, 0, plate_t])
//             cube([area, lip_h + eps, 1]);           // lip area
//     }