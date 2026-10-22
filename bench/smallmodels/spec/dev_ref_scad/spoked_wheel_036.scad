// Spoked wheel for a small sample cart
// Flat part, prints lying on the bed, centred on origin

// ---------------- Parameters ----------------
thickness      = 5;    // wheel thickness (Z)
rim_od         = 60;   // rim outer diameter
rim_width      = 5;    // rim radial width
hub_d          = 16;   // hub diameter
axle_d         = 6;    // axle hole diameter
spoke_count    = 8;    // number of spokes
spoke_width    = 4;    // spoke width
spoke_start_ang = 0;   // first spoke along +X
eps            = 0.5;  // cut overlap past faces
overlap        = 0.5;  // spoke overlap into hub/rim for clean union
$fn            = 128;  // curve resolution

// ---------------- Derived ----------------
rim_or = rim_od / 2;              // rim outer radius
rim_ir = rim_or - rim_width;      // rim inner radius
hub_r  = hub_d / 2;               // hub radius
spoke_r0 = hub_r - overlap;       // spoke start radius
spoke_r1 = rim_ir + overlap;      // spoke end radius

// ---------------- Model ----------------
difference() {
    union() {
        // Rim
        difference() {
            cylinder(h = thickness, r = rim_or);
            translate([0, 0, -eps])
                cylinder(h = thickness + 2 * eps, r = rim_ir);
        }

        // Hub
        cylinder(h = thickness, r = hub_r);

        // Spokes
        for (i = [0 : spoke_count - 1])
            rotate([0, 0, spoke_start_ang + i * 360 / spoke_count])
                translate([spoke_r0, -spoke_width / 2, 0])
                    cube([spoke_r1 - spoke_r0, spoke_width, thickness]);
    }

    // Axle hole
    translate([0, 0, -eps])
        cylinder(h = thickness + 2 * eps, d = axle_d);
}
