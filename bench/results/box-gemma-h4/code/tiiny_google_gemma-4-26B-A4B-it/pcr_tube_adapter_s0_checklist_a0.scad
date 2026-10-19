// Adapter sleeve for 0.2 mL PCR tubes in 1.5 mL rack holes.
// Designed to be printed upside down (collar on the bed).

collar_d = 13.0;      // Diameter of the base collar
collar_t = 1.5;       // Thickness of the base collar
sleeve_d = 10.8;      // Outer diameter of the main sleeve body
total_h  = 21.5;      // Total height from the bed to the top of the sleeve
bore_d   = 6.2;       // Diameter of the central bore

$fn = 64;

// The part is modeled sitting on the XY plane (z=0)
// The collar is the base, and the sleeve rises from it.

difference() {
    // Main Body: Union of the collar and the sleeve cylinder
    union() {
        // The collar (base)
        cylinder(h = collar_t, d = collar_d);
        
        // The sleeve body (rising from the collar)
        // Note: The sleeve body height is total_h - collar_t
        translate([0, 0, collar_t])
            cylinder(h = total_h - collar_t, d = sleeve_d);
    }

    // The Bore: A straight hole through the entire height
    // We extend the cylinder slightly beyond the top and bottom to ensure a clean cut
    translate([0, 0, -1])
        cylinder(h = total_h + 2, d = bore_d);
}