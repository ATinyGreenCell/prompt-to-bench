// PCR Tube Adapter Sleeve - fits a 0.2 mL tube into a 1.5 mL rack hole.
// Print orientation: Collar on bed (z=0 to 1.5), body rises to z=21.5.

// Dimensions
collar_od   = 13;      // Outer diameter of the collar
collar_t    = 1.5;     // Thickness of the collar
body_od     = 10.8;    // Outer diameter of the sleeve body
body_h      = 21.5;    // Total height of the body (from top of collar)
bore_d      = 6.2;     // Diameter of the straight bore

// Derived dimensions
collar_z_top = collar_t;
body_z_start = collar_z_top;
body_z_end   = body_z_start + body_h;
total_height = body_z_end;

// Overcuts for clean printing (Rule 5)
overcut = 0.1;

$fn = 64;

difference() {
    union() {
        // 1. The Collar (lies on the bed)
        translate([0, 0, 0]) 
            cylinder(h = collar_t, d = collar_od);

        // 2. The Sleeve Body (rises from the collar)
        translate([0, 0, collar_z_top]) 
            cylinder(h = body_h, d = body_od);
    }

    // 3. The Bore (straight hole through the full height)
    // Extends slightly past top and bottom to ensure it is open
    translate([0, 0, -overcut]) 
        cylinder(h = total_height + 2 * overcut, d = bore_d);
}