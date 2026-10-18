// DIY Magnetic Stirrer Housing - built upside down on the print bed.
// Top plate (z=0 to 2) with screw holes, walls rising to z=40, open top.
// Outer size: 90x90 mm. Fan size: 80x80 mm.

$fn = 64;

// Dimensions
outer_w = 90;
outer_h = 90;
top_t   = 2;
wall_t  = 2.5;
wall_h  = 40; // Total height from bed
fan_w   = 80;
fan_h   = 80;

// Screw holes
screw_d = 4.5;
screw_p = 71.5; // Pattern size
n_screws = 4;

// Cable notch
notch_w = 12;
notch_d = 8; // Depth from open edge (z=40 down to z=32)

// Calculated positions
// Top plate is 90x90, centred on origin, sitting on z=0.
// Screw pattern is 71.5x71.5, centred on origin.
// Walls rise from the perimeter of the top plate.
// The open top is at z = wall_h.
// The notch is in one wall (let's say the front wall, facing +Y), 
// centred along the wall width, cutting from z=32 to z=40.

// Define the main block (top plate + walls)
// We build a solid block 90x90x40 and subtract the internal void and the notch.
// To ensure clean cuts, we extend the cutting shapes slightly.

module build_housing() {
    difference() {
        // 1. The solid base: Top plate + Walls
        // Outer dimensions: 90 x 90 x 40
        translate([0, 0, 0]) 
            cube([outer_w, outer_h, wall_h]);

        // 2. The internal void (the open box)
        // The box is open at the top (z=40).
        // The inner void starts at z = top_t (2mm) and goes up to z = 40.
        // Inner width/height = Outer - 2*WallThickness = 90 - 5 = 85.
        // Wait, the fan is 80mm. The walls are 2.5mm thick.
        // Usually, the fan sits inside. Let's assume the inner void matches the fan size roughly or is defined by the wall thickness.
        // If outer is 90 and wall is 2.5, inner is 85.
        // Let's define the void based on the wall thickness from the outer edges.
        inner_w = outer_w - 2 * wall_t;
        inner_h = outer_h - 2 * wall_t;
        
        // Void starts at z = top_t
        translate([0, 0, top_t]) 
            cube([inner_w, inner_h, wall_h - top_t]);

        // 3. Screw holes
        // Pattern: 71.5 mm square, centred on origin.
        // Holes go through the top plate (z=0 to z=2).
        // Extend slightly below z=0 and above z=2 to ensure clean cut.
        for (i = [0 : n_screws - 1]) {
            // Calculate X and Y positions for the 4 screws
            // Pattern is square, so x and y are independent but linked by index logic or just list them.
            // Let's generate coordinates for a square pattern.
            // Indices: 0, 1, 2, 3.
            // We want corners of a 71.5x71.5 square.
            // Offset from center = 71.5 / 2 = 35.75.
            // Positions: (-35.75, -35.75), (35.75, -35.75), (-35.75, 35.75), (35.75, 35.75).
            
            // Logic to map i to x, y
            if (i == 0) {
                tx = -screw_p / 2;
                ty = -screw_p / 2;
            } else if (i == 1) {
                tx = screw_p / 2;
                ty = -screw_p / 2;
            } else if (i == 2) {
                tx = -screw_p / 2;
                ty = screw_p / 2;
            } else {
                tx = screw_p / 2;
                ty = screw_p / 2;
            }
            
            translate([tx, ty, -1]) 
                cylinder(h = top_t + 2, d = screw_d);
        }

        // 4. Cable Notch
        // Located in one wall. Let's pick the wall at Y = +outer_h/2 (Front wall).
        // The wall spans X from -outer_w/2 to +outer_w/2.
        // Notch is 12mm wide, centred along the wall.
        // Notch depth is 8mm from the open edge (z=40). So it cuts from z=32 to z=40.
        // We cut a rectangular prism from the solid block.
        
        // Position:
        // X: centred on 0. Width 12.
        // Y: at the front face. The wall is at Y = outer_h/2 - wall_t/2? 
        // Actually, the solid block is 90x90. The front face is at Y=45.
        // The notch goes INTO the wall.
        // So the notch volume is at Y = 45, extending in -Y direction by wall_t (2.5mm).
        // Wait, the notch is a hole in the wall.
        // The wall is the material between Y=42.5 and Y=45.
        // The notch removes material from Y=42.5 to Y=45, X from -6 to +6, Z from 32 to 40.
        
        translate([-notch_w / 2, outer_h / 2 - wall_t, 32]) 
            cube([notch_w, wall_t, notch_d]);
    }
}

build_housing();