// PCR Tube Adapter Sleeve - fits 0.2mL tubes into 1.5mL rack holes.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od = 13;      // Collar outer diameter
collar_t  = 1.5;     // Collar thickness (height)
body_od   = 10.8;    // Sleeve body outer diameter
bore_d    = 6.2;     // Bore diameter
total_h   = 21.5;    // Total height of the part (Collar + Body)

// Ensure smooth rendering for cylindrical surfaces
$fn = 96;

module adapter() {
    difference() {
        // 1. Main Body Cylinder (Outer Shell)
        // Starts at z=0, goes up to total_h
        cylinder(h = total_h, d = body_od);

        // 2. Collar (Outer Ring)
        // Starts at z=0, goes up to collar_t
        // We subtract this from the main body to create the step down
        cylinder(h = collar_t, d = collar_od);

        // 3. Bore (Inner Hole)
        // Runs through the full height of the part
        translate([0, 0, -1]) cylinder(h = total_h + 2, d = bore_d);
    }
}

// Translate the whole part down so the collar sits on the bed (z=0)
// The module is already defined with z=0 start, so no translation needed if we assume the module starts at 0.
// However, to be explicit and safe against any coordinate shifts:
translate([0, 0, 0]) adapter();