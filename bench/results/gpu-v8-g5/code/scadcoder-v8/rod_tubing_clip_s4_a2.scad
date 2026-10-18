// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded 10 mm in Z (y = -profile_y .. profile_y)
//
// Profile (in XY, drawn as if looking down +Z):
//   (1) Rod ring: 18.7 mm outer diameter, 3 mm wall, centred at origin.
//       Opening cut from the -X side: everything with x < 0 and -5 < y < 5 is removed.
//   (2) Tubing ring: 10 mm outer diameter, 2 mm wall, centred at x = 15, y = 0.
//       Opening cut from the +X side: x > 15 and -4 < y < 4.
//   (3) Solid bridge: 6 mm wide in Y, running from x = 8 to x = 12.
//       It joins the two rings without blocking either ring's hole.
//
// The file uses only built-in OpenSCAD. All dimensions are in millimetres.

// ---------------- Parameters ----------------
ring_od      = 18.7;   // rod ring outer diameter
ring_wall    = 3;      // rod ring wall thickness
ring_id      = ring_od - 2 * ring_wall;  // rod ring inner diameter (12.7 mm)

tube_od      = 10;     // tubing ring outer diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_id      = tube_od - 2 * tube_wall;  // tubing ring inner diameter (6 mm)

bridge_w     = 6;      // bridge width in Y
bridge_x0    = 8;      // bridge start in X
bridge_x1    = 12;     // bridge end in X

opening_r    = 5;      // half-width of the rod ring opening (y = -5 .. 5)
tube_open_y  = 4;      // half-width of the tubing ring opening (y = -4 .. 4)

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------------- Profile ----------------
profile = union() {
    // Rod ring with -X opening
    difference() {
        translate([-ring_od / 2, -ring_od / 2])
            circle(d = ring_od);
        translate([-ring_od / 2 - eps, -opening_r - eps, 0])
            cube([opening_r + eps, ring_od + 2 * eps, ring_wall + eps]);
    }

    // Tubing ring with +X opening
    translate([15, 0])
        difference() {
            circle(d = tube_od);
            translate([tube_od / 2 - eps, -tube_open_y - eps, 0])
                cube([tube_open_y + eps, tube_od + 2 * eps, tube_wall + eps]);
        }

    // Solid bridge between the two rings
    translate([bridge_x0, -bridge_w / 2, 0])
        cube([bridge_x1 - bridge_x0, bridge_w, 1]);
}

// ---------------- Part ----------------
translate([0, 0, 0])
    linear_extrude(height = 10)
        profile;