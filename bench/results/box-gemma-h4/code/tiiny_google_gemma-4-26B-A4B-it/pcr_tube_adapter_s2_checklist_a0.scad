// Adapter sleeve for 0.2 mL PCR tubes in 1.5 mL rack holes.
// Designed to be printed upside down (collar on the bed).

collar_d = 13.0;      // Diameter of the base collar
collar_t = 1.5;       // Thickness of the base collar
sleeve_d = 10.8;      // Outer diameter of the sleeve body
sleeve_h = 21.5 - 1.5; // Height of the sleeve body (total height 21.5 - collar 1.5)
bore_d   = 6.2;       // Diameter of the central bore

$fn = 64;

// The model is built with the collar at z=0 as requested.
union() {
    // The base collar
    cylinder(h = collar_t, d = collar_d);
    
    // The sleeve body rising from the collar
    translate([0, 0, collar_t])
        cylinder(h = sleeve_h, d = sleeve_d);
}

// Subtract the bore through the entire height
difference() {
    // We use a union of the parts above and then subtract the bore.
    // To keep the code clean, we'll wrap the whole thing in a difference.
    // However, to follow the "build upward" rule, we define the solid first.
    
    // This is a structural rewrite to ensure the difference works correctly:
}

// Corrected structure for the difference operation
difference() {
    // The solid object
    union() {
        cylinder(h = collar_t, d = collar_d);
        translate([0, 0, collar_t])
            cylinder(h = sleeve_h, d = sleeve_d);
    }
    
    // The bore (drilled through the full height)
    // We extend the cylinder slightly below z=0 and above z=21.5 to ensure clean cuts
    translate([0, 0, -1])
        cylinder(h = 21.5 + 2, d = bore_d);
}