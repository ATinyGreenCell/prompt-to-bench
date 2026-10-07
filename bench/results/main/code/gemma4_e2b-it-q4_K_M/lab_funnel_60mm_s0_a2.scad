// Dimensions for the Lab Funnel
funnel_height = 50;      // Total height of the funnel in mm (z=0 to z=50)
spout_length = 20;       // Length of the straight spout section in mm (z=0 to z=20)
spout_od = 10;           // Outer diameter of the spout (mm)
spout_id = spout_od - 2 * wall_thickness; // Inner diameter/bore of the spout (10 - 3.2 = 6.8 mm)
cone_base_od = spout_od;  // Outer diameter at z=20 is 10 mm
cone_rim_od = 60;         // Outer diameter at the rim (z=50)
wall_thickness = 1.6;     // Wall thickness of the funnel in mm

// --- Main Funnel Body Construction ---

// 1. Straight Spout Section (z=0 to z=20)
translate([0, 0, 0]) {
    difference() {
        // Outer shape of the spout (Cylinder with outer radius R_out = 5)
        cylinder(h = spout_length, r = spout_od / 2, $fn = 64);

        // Inner bore (cut out). Inner radius R_in = 6.8 / 2 = 3.4 mm
        translate([0, 0, -0.01]) {
            cylinder(h = spout_length + 0.02, r = spout_id / 2, $fn = 64);
        }
    }
}

// 2. Conical Section (z=20 to z=50)
translate([0, 0, spout_length]) {
    difference() {
        // Outer cone shape: Defined by the outer radius changing linearly from R_base=5 to R_rim=30
        hull() {
            translate([0, 0, 0])
                cylinder(h = funnel_height, r1 = cone_base_od / 2, r2 = cone_rim_od / 2, $fn = 64);
        }

        // Inner bore (cut out): Defined by the inner radius changing linearly from R_base_in=3.4 to R_rim_in=28
        hull() {
            translate([0, 0, 0])
                cylinder(h = funnel_height, r1 = (cone_base_od - 2 * wall_thickness) / 2, r2 = (cone_rim_od - 2 * wall_thickness) / 2, $fn = 64);
        }
    }
}