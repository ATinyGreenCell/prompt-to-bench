// Coarse cell strainer for 50mL conical tube
// Corrected version: Fixed notch orientation and penetration

// --- Dimensions ---
od_cup      = 25.0;    // Outer diameter of the main cup
wall_t      = 1.2;     // Wall thickness
bore_d      = 22.6;    // Inner diameter of the cup
cup_h       = 32.0;    // Height of the cup body
floor_t     = 1.2;     // Thickness of the floor
hole_d      = 1.0;     // Diameter of the strainer holes
grid_step   = 2.0;     // Spacing of the hole grid
max_hole_r  = 10.0;    // Maximum radius for hole centers
collar_d1   = 25.0;    // Diameter at the start of the flare (z=26)
collar_d2   = 33.0;    // Diameter at the top of the flare (z=30)
flare_h     = 4.0;     // Height of the flare (30 - 26)
rim_d       = 33.0;    // Diameter of the top rim
rim_h       = 2.0;     // Height of the top rim (32 - 30)
notch_w     = 3.0;     // Width of the vent notches
notch_r     = 12.5;    // Radius at which the notch starts cutting

$fn = 128;

module strainer_body() {
    difference() {
        union() {
            // Main Cup Body (z=0 to 32)
            cylinder(h = cup_h, d = od_cup);
            
            // Flare (z=26 to 30)
            translate([0, 0, 26])
                cylinder(h = flare_h, d1 = collar_d1, d2 = collar_d2);
            
            // Top Rim (z=30 to 32)
            translate([0, 0, 30])
                cylinder(h = rim_h, d = rim_d);
        }

        // Hollow out the bore (z=0 to 32)
        translate([0, 0, -0.01])
            cylinder(h = cup_h + 0.02, d = bore_d);
            
        // Vent Notches
        // "remove the collar and rim beyond 12.5mm from the axis"
        // "3mm wide vent notches, on the +X and -X sides"
        // This means the notch is a slot centered on the X axis, 
        // cutting through the Y-dimension of the part.
        for (sx = [-1, 1]) {
            translate([0, 0, 25])
            rotate([0, 0, (sx == 1 ? 0 : 180)])
            // We place the notch such that it cuts the outer part of the rim.
            // To "remove beyond 12.5mm", we cut a slot that is 3mm wide (in Z)
            // and spans from the 12.5mm radius to the edge of the part.
            // Wait, "3mm wide" usually refers to the dimension perpendicular to the cut.
            // If it's on the +X side, the notch is a slot at X=12.5.
            // Let's interpret "3mm wide" as the dimension along the X axis.
            // And it removes everything beyond 12.5mm.
            // This is best achieved by subtracting a shape that is 
            // wider than the part and positioned at the notch location.
            
            // Let's use a cube that is 3mm wide (along X) and very wide (along Y)
            // and positioned at X = 12.5.
            translate([notch_r, -20, -1])
                cube([20, 40, 10]); 
        }
    }
}

module floor_holes() {
    // Grid of holes on the floor (z=0 to 1.2)
    for (x = [-10 : grid_step : 10]) {
        for (y = [-10 : grid_step : 10]) {
            if (sqrt(x*x + y*y) <= max_hole_r) {
                translate([x, y, -0.01])
                    cylinder(h = floor_t + 0.02, d = hole_d);
            }
        }
    }
}

// --- Final Assembly ---
difference() {
    strainer_body();
    floor_holes();
}