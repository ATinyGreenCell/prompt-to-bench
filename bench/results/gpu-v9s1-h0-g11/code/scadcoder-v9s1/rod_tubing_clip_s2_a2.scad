// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, extruded up in +Z

// ---------------- Parameters ----------------
rod_id      = 12.7;   // stand rod inner diameter
rod_wall    = 3;      // stand rod ring wall thickness
rod_od      = rod_id + 2 * rod_wall;  // stand rod ring outer diameter (18.7)

tubing_id   = 6;      // tubing inner diameter
tubing_wall = 2;      // tubing ring wall thickness
tubing_od   = tubing_id + 2 * tubing_wall;  // tubing ring outer diameter (10)

bridge_w    = 6;      // solid bridge width along X (joins the two rings)
bridge_h    = 6;      // solid bridge height along Y

opening_rod = 10;     // width of the opening cut from the rod ring (-X side)
opening_tub = 4.5;    // width of the opening cut from the tubing ring (+X side)

eps         = 0.5;    // cutter overshoot past faces
$fn         = 96;     // curve resolution

// ---------------- Profile (in XY) ----------------
module clip_profile() {
    union() {
        // Rod ring, centred at origin
        difference() {
            cylinder(d = rod_od, h = 1);
            translate([-rod_od - eps, 0, 0])
                cube([opening_rod + 2 * eps, 2 * (rod_od / 2), 1]);   // -X opening
        }

        // Tubing ring, centred at x = 15, y = 0
        translate([15, 0, 0])
            difference() {
                cylinder(d = tubing_od, h = 1);
                translate([eps, -opening_tub / 2, 0])
                    cube([opening_tub + 2 * eps, opening_tub, 1]);    // +X opening
            }

        // Solid bridge between x = 8 and x = 12
        translate([8 - bridge_w / 2, -bridge_h / 2, 0])
            cube([bridge_w, bridge_h, 1]);
    }
}

// ---------------- Part ----------------
// 2-D profile drawn in XY, extruded up to 10 mm (Z), centred in X/Y, resting on z = 0
translate([0, 0, 0])
    linear_extrude(height = 10)
        clip_profile();