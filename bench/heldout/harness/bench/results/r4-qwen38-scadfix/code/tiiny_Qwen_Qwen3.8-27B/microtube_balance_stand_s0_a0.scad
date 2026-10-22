// Stand for a 1.5 mL microcentrifuge tube, printed standing up.
// All dimensions in millimetres, measured with calipers.

$fn = 64;

// Base disc
base_d = 50;      // base disc diameter
base_h = 4;       // base disc height (z = 0 to 4)

// Cone (base to column)
cone_top_d = 22;  // cone top diameter (at z = 14)
cone_z0 = 4;      // cone starts at z = 4
cone_z1 = 14;     // cone ends at z = 14

// Column
col_d = 22;       // column diameter
col_z0 = 14;      // column starts at z = 14
col_z1 = 33;      // column ends at z = 33 (top)

// Tube seat (bore from the top)
seat_d = 11;      // seat diameter (z = 33 down to 23)
seat_z0 = 23;     // seat bottom (z = 23)
seat_z1 = 33;     // seat top (z = 33, open at top)

// Tip cone (follows the tube's conical tip)
tip_top_d = 11;   // tip cone top diameter (at z = 23)
tip_bot_d = 3;    // tip cone bottom diameter (at z = 6)
tip_z0 = 6;       // tip cone bottom (z = 6)
tip_z1 = 23;      // tip cone top (z = 23)

// Viewing window (cut through the +X column wall)
win_w = 4;       // window width in Y
win_z0 = 18;     // window bottom (z = 18)
win_z1 = 30;     // window top (z = 30)

// ------------------------------------------------------------------
// Build the solid stand (base + cone + column), then subtract the
// tube seat and the viewing window.
// ------------------------------------------------------------------

// Base disc: 50 mm diameter, z = 0 to 4
module base() { translate([0, 0, 0])
    cylinder(h = base_h, d = base_d, $fn = $fn); }

// Cone: 50 mm at z = 4 narrowing to 22 mm at z = 14
module cone() { translate([0, 0, cone_z0])
    cylinder(h = cone_z1 - cone_z0, d1 = base_d, d2 = cone_top_d, $fn = $fn); }

// Column: 22 mm diameter, z = 14 to 33
module column() { translate([0, 0, col_z0])
    cylinder(h = col_z1 - col_z0, d = col_d, $fn = $fn); }

// Tube seat: 11 mm bore from z = 33 down to z = 23
module seat() { translate([0, 0, seat_z0])
    cylinder(h = seat_z1 - seat_z0, d = seat_d, $fn = $fn); }

// Tip cone: 11 mm at z = 23 narrowing to 3 mm at z = 6
module tip() { translate([0, 0, tip_z0])
    cylinder(h = tip_z1 - tip_z0, d1 = tip_bot_d, d2 = tip_top_d, $fn = $fn); }

// Viewing window: 4 mm wide in Y, cut straight through the +X wall
// from the seat to the outside, between z = 18 and z = 30.
// The box extends past the +X face (x = 11) and past the -X face
// (x = -11) so the cut is clean; it is centred in Y and spans the
// full Z range of the window.
module window() { translate([-11.01, -win_w/2, win_z0])
    cube([22.02, win_w, win_z1 - win_z0]); }

// Final part
difference() {
    union() {
        base();
        cone();
        column();
    }
    union() {
        seat();
        tip();
    }
    window();
}