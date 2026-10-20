$fn = 64;

// Dimensions (mm)
collar_od = 13;       // Diameter of the bottom collar
collar_h = 1.5;       // Height of the bottom collar
body_od = 10.8;       // Outer diameter of the main sleeve body
body_h = 21.5;        // Height of the main sleeve body
bore_d = 6.2;         // Diameter of the internal bore

// Derived dimensions
collar_r = collar_od / 2;
body_r = body_od / 2;
bore_r = bore_d / 2;
total_h = collar_h + body_h;

// Construct the adapter
difference() {
    union() {
        // Bottom collar (resting on bed at z=0)
        translate([0, 0, 0])
        cylinder(r = collar_r, h = collar_h);

        // Main body (rising from collar)
        translate([0, 0, collar_h])
        cylinder(r = body_r, h = body_h);
    }

    // Internal bore
    // Height is extended by 1mm to ensure it cuts through the top face of the collar
    // and the top face of the body, satisfying the "extend past faces" rule.
    cylinder(r = bore_r, h = total_h + 1);
}