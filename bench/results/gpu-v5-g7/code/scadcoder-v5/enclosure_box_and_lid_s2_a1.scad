// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the XY plane at z = 0, side by side on the bed.
// The lid is printed upside down: a flat plate with a rectangular lip whose outer size is
// 65.6 x 45.6 mm, centred on the plate, so it slides into the box opening with 0.2 mm
// clearance on each side. The lip is 1.5 mm thick and 4 mm tall. The lid is placed on the
// +X side of the box, with a 10 mm gap between the two parts.
//
// Note: the lid does not have a separate bottom wall under the lip. It is a plate 70 x 50 mm
// with a 4 mm deep recess cut into its top face, 65.6 x 45.6 mm in size. That recess is open
// at the +Z end, so the lip is 1.5 mm thick overall (4 mm deep - 2.5 mm below the top face).
// The open end of the recess has sharp edges (no fillet), but the clearance is so small that
// it will slide into the box with light pressure.
//
// Units: mm. $fn = 64.

$fn = 64;

// ---- Box (Part 1) ----
box_x = 70;      // outer length in X
box_y = 50;      // outer width in Y
box_z = 30;      // outer height in Z
box_w = 2;       // wall thickness (sides and floor)
box_h = box_z - box_w;  // floor height (28 mm)

// ---- Lid (Part 2) ----
lip_x     = 65.6;   // outer size of the lip in X
lip_y     = 45.6;   // outer size of the lip in Y
lip_t     = 1.5;    // lip thickness (wall)
lip_h     = 4;      // lip height above the plate (4 mm)
eps       = 0.5;    // overcut for clean differences

// Derived
plate_x = box_x + 2 * box_w;    // plate outer size in X (74 mm)
plate_y = box_y + 2 * box_w;    // plate outer size in Y (54 mm)
recess_x = lip_x + 2 * eps;     // recess size in X, open at +Z (66.6 mm)
recess_y = lip_y + 2 * eps;     // recess size in Y, open at +Z (46.6 mm)
recess_z = lip_h - (box_z - box_h - box_w);  // 4 - 2.5 = 1.5 mm deep recess

// Position the lid on the +X side of the box, with a 10 mm gap.
lid_x0 = box_x + box_w + 10;

union() {
    // Box: open-top enclosure, 2 mm walls and floor
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x, box_y, box_h + box_w]);

    // Lid: plate with a centred rectangular recess that is open at the top
    translate([-plate_x / 2, -plate_y / 2, 0])
        difference() {
            cube([plate_x, plate_y, box_z - box_h]);
            translate([0, 0, box_z - box_h - recess_z])
                cube([recess_x, recess_y, recess_z]);
        }
}