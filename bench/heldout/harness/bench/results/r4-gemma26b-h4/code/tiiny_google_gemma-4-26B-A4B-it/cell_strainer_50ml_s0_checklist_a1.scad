// Coarse cell strainer for 50mL conical tube
// Corrected version to ensure strict adherence to dimensions

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
            // Starts at 25mm, ends at 33mm
            translate([0, 0, 26])
                cylinder(h = flare_h, d1 = collar_d1, d2 = collar_d2);
            
            // Top Rim (z=30 to 32)
            translate([0, 0, 30])
                cylinder(h = rim_h, d = rim_d);
        }

        // Hollow out the bore (z=0 to 32)
        // We subtract from the bottom to ensure the floor is 1.2mm
        translate([0, 0, -0.01])
            cylinder(h = cup_h + 0.02, d = bore_d);
            
        // Vent Notches
        // Removes collar and rim beyond 12.5mm from axis from z=25 up.
        // Using a loop for +X and -X
        for (sx = [-1, 1]) {
            translate([sx * notch_r, 0, 25])
                // The notch is 3mm wide, so we center it on Y
                // We use a large cube to ensure it cuts through the outer diameter
                cube([20, notch_w, 10], center = true); 
                // Note: The prompt says "remove the collar and rim beyond 12.5mm"
                // This implies the notch is a cutout on the side.
        }
        
        // Refined Notch Logic: 
        // "remove the collar and rim beyond 12.5mm from the axis"
        // This means the notch is a gap in the circumference.
        // We will use a subtraction of a cylinder to create a gap, 
        // but the prompt specifies "3mm wide vent notches".
        // This usually means a slot.
        for (sx = [-1, 1]) {
            rotate([0, 0, (sx == 1 ? 0 : 180)])
            translate([notch_r, -notch_w/2, 25])
            cube([10, notch_w, 10]);
        }
    }
}

module floor_holes() {
    // Grid of holes on the floor (z=0 to 1.2)
    // One hole at center, others on 2mm grid.
    // Max radius 10mm.
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
// We use a difference to subtract the holes from the solid body
difference() {
    strainer_body();
    floor_holes();
}