// Spoked wheel for a small sample cart
// Print orientation: flat on bed, centred on origin, builds up +Z

$fn = 96;

// ---- Dimensions (mm) ----
thickness      = 5;    // overall part thickness (Z)
rim_od         = 60;   // rim outer diameter
rim_width      = 5;    // rim radial width
hub_d          = 20;   // hub diameter
axle_d         = 5;    // axle hole diameter
spoke_count    = 6;    // number of spokes
spoke_width    = 5;    // spoke width
spoke_start_angle = 0; // first spoke along +X

// ---- Derived ----
rim_id      = rim_od - 2 * rim_width;     // rim inner diameter (50)
spoke_r0    = hub_d / 2 - 1;              // spoke starts inside hub (overlap)
spoke_r1    = rim_id / 2 + 1;             // spoke ends inside rim (overlap)
spoke_len   = spoke_r1 - spoke_r0;
eps         = 0.5;                        // cutter overshoot

difference() {
    union() {
        // Outer rim
        difference() {
            cylinder(h = thickness, d = rim_od);
            translate([0, 0, -eps])
                cylinder(h = thickness + 2 * eps, d = rim_id);
        }

        // Hub
        cylinder(h = thickness, d = hub_d);

        // Spokes
        for (i = [0 : spoke_count - 1])
            rotate([0, 0, spoke_start_angle + i * 360 / spoke_count])
                translate([spoke_r0, -spoke_width / 2, 0])
                    cube([spoke_len, spoke_width, thickness]);
    }

    // Axle hole
    translate([0, 0, -eps])
        cylinder(h = thickness + 2 * eps, d = axle_d);
}
