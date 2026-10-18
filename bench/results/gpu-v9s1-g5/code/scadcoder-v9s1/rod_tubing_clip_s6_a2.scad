// Tubing clip with a stand rod
// Print orientation: flat on bed, extruded along +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_id     = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
ring_od    = rod_id + 2 * ring_w;  // rod ring outer diameter (18.7)
ring_h     = 10;     // extrusion height (Z)

tubing_id  = 6;      // tubing inner diameter
tubing_w   = 2;      // tubing ring wall thickness
tubing_od  = tubing_id + 2 * tubing_w;  // tubing ring outer diameter (10)
tubing_x   = 15;     // tubing ring centre X
tubing_y   = 0;      // tubing ring centre Y

bridge_w   = 6;      // solid bridge width (X) between x = 8 and x = 12
bridge_h   = 6;      // solid bridge height (Y)

opening_r  = 10;     // rod ring opening width (-X side)
opening_t  = 4.5;    // tubing ring opening width (+X side)

eps        = 0.5;    // cutter overshoot past faces

// ---- Profile in XY ----
module profile() {
    union() {
        // Rod ring with -X opening
        difference() {
            cylinder(d = ring_od, h = 1);
            translate([-ring_od - eps, -eps, 0])
                cube([opening_r + 2 * eps, 2 * eps, 1]);
        }

        // Tubing ring with +X opening
        translate([tubing_x, tubing_y, 0])
            difference() {
                cylinder(d = tubing_od, h = 1);
                translate([tubing_x + eps, -opening_t / 2, 0])
                    cube([opening_t + 2 * eps, opening_t, 1]);
            }

        // Solid bridge (x = 8..12, y = -3..3)
        translate([tubing_x - bridge_w, -bridge_h / 2, 0])
            cube([bridge_w, bridge_h, 1]);
    }
}

// ---- Part ----
difference() {
    linear_extrude(height = ring_h) profile();

    // Rod pocket (extends past top and bottom faces)
    translate([0, 0, -eps])
        cylinder(d = rod_id, h = ring_h + 2 * eps);
}