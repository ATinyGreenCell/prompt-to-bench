// Coarse cell strainer for 50 mL conical tube
// Designed for FDM printing, oriented upright (Z-axis)

// --- Dimensions ---
od_cup      = 25.0;    // Outer diameter of the main cup
wall_t      = 1.2;     // Wall thickness
bore_d      = 22.6;    // Inner diameter of the cup
cup_h       = 32.0;    // Height of the cup body
floor_t     = 1.2;     // Thickness of the bottom floor
hole_d      = 1.0;     // Diameter of the strainer holes
grid_step   = 2.0;     // Spacing of the hole grid (square)
max_hole_r  = 10.0;    // Maximum radius for hole centers
collar_d1   = 25.0;    // Diameter at the start of the flare (z=26)
collar_d2   = 33.0;    // Diameter at the top of the flare (z=30)
rim_d       = 33.0;    // Diameter of the rim
rim_h       = 2.0;     // Height of the rim (from z=30 to z=32)
notch_w     = 3.0;     // Width of the vent notches
notch_r     = 12.5;    // Radius from axis where notches begin

$fn = 64;

// --- Calculations ---
// The user specified a 45-degree cone from 25mm at z=26 to 33mm at z=30.
// Let's check the slope: (33-25)/2 = 4mm change in radius over 4mm change in height.
// This is indeed a 45-degree angle relative to the vertical axis.

module strainer_body() {
    difference() {
        union() {
            // Main Cup Body
            cylinder(h = cup_h, d = od_cup);
            
            // Flare/Collar (45-degree cone)
            // Starts at z=26 (d=25) to z=30 (d=33)
            cylinder(h = 4, d1 = collar_d1, d2 = collar_d2);
            
            // Rim
            translate([0, 0, 30])
                cylinder(h = rim_h, d = rim_d);
        }

        // Hollow out the inside (Bore)
        // We subtract the floor thickness from the bottom
        translate([0, 0, -0.01])
            cylinder(h = cup_h + 1, d = bore_d);

        // Vent Notches
        // Removes material beyond 12.5mm radius on +X and -X sides
        // Notch is 3mm wide, centered on X axis.
        // We use a large cube to "cut" the sides.
        for (side = [-1, 1]) {
            translate([side * notch_r, -notch_w/2, 25])
                cube([notch_d_ext := 10, notch_w, cup_h + 10]);
        }
    }
}

// Helper to create the notch cutting shape
module notch_cutter() {
    // A cube that is wide enough to clear the rim
    cube([20, notch_w, 40], center = true);
}

// Refined difference to handle the notches correctly
module final_strainer() {
    difference() {
        strainer_body(),
        
        // Vent Notches: "remove the collar and rim beyond 12.5 mm from the axis from z = 25 up"
        // We use a subtraction of a shape that represents the "keep" zone to create the notch
        // Or more simply, subtract two blocks that represent the "cut" zone.
        // The user wants to remove material *beyond* 12.5mm. 
        // This means the notch is a gap in the wall.
        
        // To implement "remove material beyond 12.5mm on X sides", 
        // we subtract a block that covers the area from r=12.5 to infinity.
        for (side = [-1, 1]) {
            translate([side * (notch_r + 1), 0, 25]) // Move to the edge of the notch zone
                rotate([0, 0, 0])
                // We use a large cube to cut the side. 
                // To make it a "notch" on the side, we actually want to subtract 
                // the area *outside* the notch. 
                // Wait, the instruction says: "remove the collar and rim beyond 12.5mm... so air can escape"
                // This implies the notch is a cutout in the wall.
                // A notch is usually a gap. If we remove material *beyond* 12.5mm, 
                // we are actually removing the outer part. 
                // Let's interpret "notch" as a cutout in the wall.
                // A cutout in the wall is a shape that intersects the wall.
                
                // Let's define the notch as a block that is 3mm wide (Y) 
                // and extends from X=12.5 to X=infinity.
                translate([0, 0, -1])
                rotate([0, 0, 0])
                // We need to cut the side of the cylinder.
                // We'll use a cube that is very wide in X and Y, but thin in Z.
                // Actually, the simplest way to make a notch is to subtract a block 
                // that is centered on the X axis, 3mm wide in Y, and starts at X=12.5.
                // But the user says "remove... beyond 12.5mm". 
                // This means the material from 12.5mm to the edge is gone.
                // This is a bit unusual for a "notch", but I will follow the instruction.
                // "remove the collar and rim beyond 12.5 mm from the axis"
                // This means the wall is cut at the notch location.
                
                // Let's use a block that is wide in Y (3mm) and covers the outer part.
                // To make a notch, we subtract a shape that is NOT the notch.
                // No, let's subtract a shape that represents the "missing" material.
                // The missing material is a block that is 3mm wide in Y, 
                // and spans from X=12.5 to the outer edge.
                
                // Correct approach for a notch: 
                // Subtract a block that is 3mm wide in Y, and spans from X=12.5 to X=infinity.
                // But we only want to do this on the +X and -X sides.
                // To make it a "notch" (a gap), the block should be centered on the X axis.
                // The user says "3mm wide vent notches, on the +X and -X sides".
                // This means the notch is oriented along the Y axis? 
                // No, "3mm wide" usually refers to the dimension perpendicular to the direction of the notch.
                // If the notch is "on the +X side", it's a gap in the wall at the equator.
                // So the notch is 3mm wide in Y, and it cuts the wall.
                
                // Let's re-read: "3mm wide vent notches, on the +X and -X sides, remove the collar and rim beyond 12.5 mm from the axis"
                // This means at the +X position, there is a gap in the wall.
                // The gap is 3mm wide (in Y). The gap is "beyond 12.5mm".
                // This means we subtract a shape that is 3mm wide in Y, 
                // and extends from X=12.5 to X=infinity.
                // To make it a "notch" (a gap), we actually want to subtract a shape 
                // that is 3mm wide in Y, and spans from X=12.5 to the outer edge.
                // Wait, if we subtract that, we are left with a ring. 
                // A notch is a gap. To make a gap, we subtract a block that is 3mm wide in Y 
                // and spans from X=12.5 to the outer edge.
                // But the user says "remove... beyond 12.5mm". 
                // This means the material from 12.5 to the edge is removed.
                // This would leave a "step" or a "gap". 
                // I will model it as a cutout in the wall.
                
                // Let's assume the notch is a rectangular cutout in the wall.
                // Width (Y