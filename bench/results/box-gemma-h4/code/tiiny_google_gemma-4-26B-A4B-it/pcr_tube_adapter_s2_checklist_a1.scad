// Adapter sleeve for 0.2 mL PCR tubes in 1.5 mL rack holes.
// Designed to be printed upside down (collar on the bed).

// Dimensions
collar_d = 13.0;      // Diameter of the base collar
collar_t = 1.5;       // Thickness of the base collar
sleeve_d = 10.8;      // Outer diameter of the sleeve body
total_h  = 21.5;      // Total height of the part
bore_d   = 6.2;       // Diameter of the central bore

// Resolution
$fn = 128;

// The part is built from z=0 upwards.
difference() {
    // --- Solid Body ---
    union() {
        // Base collar
        cylinder(h = collar_t, d = collar_d);
        
        // Sleeve body rising from the collar
        // Height of sleeve = total height - collar thickness
        translate([0, 0, collar_t])
            cylinder(h = total_h - collar_t, d = sleeve_d);
    }

    // --- Bore ---
    // A straight 6.2 mm diameter bore runs through the full height, open at both ends.
    // We extend the cylinder slightly beyond the boundaries to ensure a clean cut.
    translate([0, 0, -1])
        cylinder(h = total_h + 2, d = bore_d);
}