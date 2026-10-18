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

// Screw coordinates: 71.5 mm square pattern centred on origin.
// Corners at +/- 35.75.
screw_coords = [
    [-screw_p / 2, -screw_p / 2],
    [screw_p / 2, -screw_p / 2],
    [-screw_p / 2, screw_p / 2],
    [screw_p / 2, screw_p / 2]
];

// Define the main block (top plate + walls)
// We build a solid block 90x90x40 and subtract the internal void and the notch.

difference() {
    // 1. The solid base: Top plate + Walls
    // Outer dimensions: 90 x 90 x 40
    translate([0, 0, 0]) 
        cube([outer_w, outer_h, wall_h]);

    // 2. The internal void (the open box)
    // The box is open at the top (z=40).
    // The inner void starts at z = top_t (2mm) and goes up to z = 40.
    // Inner width/height = Outer - 2*WallThickness = 90 - 5 = 85.
    inner_w = outer_w - 2 * wall_t;
    inner_h = outer_h - 2 * wall_t;
    
    // Void starts at z = top_t
    translate([0, 0, top_t]) 
        cube([inner_w, inner_h, wall_h - top_t]);

    // 3. Screw holes
    // Pattern: 71.5 mm square, centred on origin.
    // Holes go through the top plate (z=0 to z=2).
    // Extend slightly below z=0 and above z=2 to ensure clean cut.
    for (coord in screw_coords) {
        tx = coord[0];
        ty = coord[1];
        
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
    // Y: The wall is at the front face. The solid block ends at Y=45.
    // The wall material is between Y=42.5 and Y=45.
    // The notch removes material from Y=42.5 to Y=45, X from -6 to +6, Z from 32 to 40.
    // We extend the cut slightly in Y to ensure it cuts through the wall cleanly.
    
    translate([-notch_w / 2, outer_h / 2 - wall_t, 32]) 
        cube([notch_w, wall_t + 0.1, notch_d + 0.1]);
}