// Spoked wheel for a small sample cart
// Print orientation: flat on the bed, centred on origin

// ---- Parameters (mm) ----
thickness      = 8;     // overall wheel thickness (Z)
rim_od         = 100;   // rim outer diameter
rim_width      = 6;     // rim radial width
hub_d          = 16;    // hub outer diameter
axle_d         = 5;     // axle hole diameter
spoke_count    = 8;     // number of spokes
spoke_width    = 4;     // spoke width
overlap        = 0.5;   // spoke overlap into hub/rim for solid union
eps            = 0.5;   // cutter extension past faces

$fn = 128;

// ---- Derived ----
rim_ir       = rim_od / 2 - rim_width;  // rim inner radius
hub_r        = hub_d / 2;
spoke_start  = hub_r - overlap;          // spoke inner end (inside hub)
spoke_end    = rim_ir + overlap;         // spoke outer end (inside rim)
spoke_len    = spoke_end - spoke_start;

difference() {
    union() {
        // Outer rim
        difference() {
            cylinder(d = rim_od, h = thickness);
            translate([0, 0, -eps])
                cylinder(r = rim_ir, h = thickness + 2 * eps);
        }

        // Hub
        cylinder(d = hub_d, h = thickness);

        // Spokes, first along +X
        for (i = [0 : spoke_count - 1])
            rotate([0, 0, i * 360 / spoke_count])
                translate([spoke_start, -spoke_width / 2, 0])
                    cube([spoke_len, spoke_width, thickness]);
    }

    // Axle hole
    translate([0, 0, -eps])
        cylinder(d = axle_d, h = thickness + 2 * eps, $fn = 64);
}
