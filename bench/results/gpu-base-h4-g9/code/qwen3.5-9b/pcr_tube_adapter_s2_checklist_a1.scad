// PCR Tube Adapter Sleeve - fits 0.2mL tubes into 1.5mL rack holes.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od = 13;      // Collar outer diameter
collar_t  = 1.5;     // Collar thickness (height)
body_od   = 10.8;    // Sleeve body outer diameter
body_h    = 20.0;    // Sleeve body height (Total height 21.5 - Collar 1.5)
bore_d    = 6.2;     // Bore diameter

// Derived dimensions
total_height = collar_t + body_h; // Must equal 21.5

// Ensure smooth rendering for cylindrical surfaces
$fn = 96;

module adapter() {
    difference() {
        // 1. Main Body Cylinder (Outer Shell)
        // Starts at z=0, goes up to total_height
        cylinder(h = total_height, d = body_od);

        // 2. Collar (Outer Ring)
        // Starts at z=0, goes up to collar_t
        // We subtract this from the main body to create the step down
        cylinder(h = collar_t, d = collar_od);

        // 3. Bore (Inner Hole)
        // Runs through the full height of the part
        translate([0, 0, -1]) cylinder(h = total_height + 2, d = bore_d);
    }
}

// Translate the whole part down so the collar sits on the bed (z=0)
translate([0, 0, -collar_t]) adapter();