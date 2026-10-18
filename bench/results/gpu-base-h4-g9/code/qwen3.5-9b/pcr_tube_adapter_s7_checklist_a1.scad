// PCR Tube Adapter Sleeve - fits a 0.2 mL tube into a 1.5 mL rack hole.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od   = 13;      // Outer diameter of the collar
collar_t    = 1.5;     // Thickness of the collar
body_od     = 10.8;    // Outer diameter of the sleeve body
target_z_top = 21.5;   // Top of the sleeve body (absolute Z)
bore_d      = 6.2;     // Diameter of the straight bore

// Derived dimensions
collar_z_top = collar_t;
body_height  = target_z_top - collar_z_top; // 21.5 - 1.5 = 20.0
total_height = target_z_top;

// Overcuts for clean printing (Rule 5)
overcut = 0.1;

$fn = 64;

difference() {
    union() {
        // 1. The Collar (lies on the bed)
        translate([0, 0, 0]) 
            cylinder(h = collar_t, d = collar_od);

        // 2. The Sleeve Body (rises from the collar to target_z_top)
        translate([0, 0, collar_z_top]) 
            cylinder(h = body_height, d = body_od);
    }

    // 3. The Bore (straight hole through the full height)
    // Extends slightly past top and bottom to ensure it is open
    translate([0, 0, -overcut]) 
        cylinder(h = total_height + 2 * overcut, d = bore_d);
}