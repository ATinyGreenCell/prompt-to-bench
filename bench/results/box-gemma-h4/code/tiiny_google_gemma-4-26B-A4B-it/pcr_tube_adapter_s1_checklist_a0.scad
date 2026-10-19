// Adapter sleeve for 0.2 mL PCR tubes in 1.5 mL rack holes
// Designed to be printed upside down (collar on the bed)

collar_d = 13.0;      // Diameter of the base collar
collar_t = 1.5;       // Thickness of the base collar
sleeve_d = 10.8;      // Outer diameter of the sleeve body
total_h  = 21.5;      // Total height from bed to top of sleeve
bore_d   = 6.2;       // Diameter of the central bore

$fn = 64;

// The part is built from z=0 upwards.
// The collar is the base (z=0 to 1.5).
// The sleeve body rises from the collar (z=1.5 to 21.5).

difference() {
    // Main Body
    union() {
        // The Collar (Base)
        cylinder(h = collar_t, d = collar_d);
        
        // The Sleeve Body
        // It starts at z = collar_t and goes to total_h
        translate([0, 0, collar_t])
            cylinder(h = total_h - collar_t, d = sleeve_d);
    }

    // The Bore
    // Runs through the full height, open at both ends.
    // We extend the cylinder slightly beyond the height to ensure a clean cut.
    translate([0, 0, -1])
        cylinder(h = total_h + 2, d = bore_d);
}