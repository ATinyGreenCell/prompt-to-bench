// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded along +Z

// ---------------- Parameters ----------------
rod_id      = 12.7;   // stand rod inner diameter
rod_wall    = 3;      // stand rod ring wall thickness
rod_od      = rod_id + 2 * rod_wall;  // stand rod ring outer diameter (18.7)

tubing_id   = 6;      // tubing inner diameter
tubing_wall = 2;      // tubing ring wall thickness
tubing_od   = tubing_id + 2 * tubing_wall;  // tubing ring outer diameter (10)

bridge_w    = 6;      // solid bridge width along X (from x = 8 to x = 12)
bridge_h    = bridge_w;  // bridge height along Y (keeps it at 6 mm)

opening_rod = 10;     // width of the opening cut from the rod ring (-X side)
opening_tub = 4.5;    // width of the opening cut from the tubing ring (+X side)

eps         = 0.5;    // cutter overshoot past faces
$fn         = 96;     // curve resolution

// ---------------- Profile (in XY) ----------------
module clip_profile() {
    union() {
        // Rod ring, centred at origin
        difference() {
            cylinder(d = rod_od, h = eps);
            translate([-rod_od - eps, -opening_rod / 2, 0])
                cube([rod_od + 2 * eps, opening_rod, eps]);
        }

        // Tubing ring, centred at x = 15, y = 0
        translate([15, 0, 0])
            difference() {
                cylinder(d = tubing_od, h = eps);
                translate([eps, -opening_tub / 2, 0])
                    cube([opening_tub + 2 * eps, tubing_od, eps]);
            }

        // Solid bridge between x = 8 and x = 12
        translate([8 - eps, -bridge_h / 2, 0])
            cube([bridge_w + 2 * eps, bridge_h, eps]);
    }
}

// ---------------- Part ----------------
difference() {
    // 10 mm tall extrusion of the profile
    linear_extrude(height = 10)
        clip_profile();

    // Support the clip while it snaps onto the rod: remove the rod from the bore
    translate([0, 0, -eps])
        cylinder(d = rod_id, h = 10 + 2 * eps);
}