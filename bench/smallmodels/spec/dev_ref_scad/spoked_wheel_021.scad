// Spoked wheel for a small sample cart
// Print orientation: flat on the bed, centred on origin

$fn = 128;

// ---- Dimensions (mm) ----
thickness    = 6;    // overall part thickness (Z)
rim_od       = 80;   // rim outer diameter
rim_width    = 6;    // rim radial width
hub_d        = 20;   // hub diameter
axle_d       = 5;    // axle hole diameter
spoke_count  = 8;    // number of spokes
spoke_width  = 4;    // spoke width
spoke_start_angle = 0; // first spoke along +X

// ---- Derived ----
rim_id       = rim_od - 2 * rim_width;      // rim inner diameter (68)
spoke_r0     = hub_d / 2 - 1;               // spoke starts inside hub (overlap)
spoke_r1     = rim_id / 2 + 1;              // spoke ends inside rim (overlap)
eps          = 0.5;                         // cut overshoot

difference() {
    union() {
        // Outer rim
        difference() {
            cylinder(d = rim_od, h = thickness);
            translate([0, 0, -eps])
                cylinder(d = rim_id, h = thickness + 2 * eps);
        }

        // Hub
        cylinder(d = hub_d, h = thickness);

        // Spokes
        for (i = [0 : spoke_count - 1])
            rotate([0, 0, spoke_start_angle + i * 360 / spoke_count])
                translate([spoke_r0, -spoke_width / 2, 0])
                    cube([spoke_r1 - spoke_r0, spoke_width, thickness]);
    }

    // Axle hole
    translate([0, 0, -eps])
        cylinder(d = axle_d, h = thickness + 2 * eps);
}
