// DIY Magnetic Stirrer Housing - built upside down on the print bed.
// Top plate (z=0 to 2) with M4 screw holes, four walls rising to z=40.
// Outer size: 90x90mm. Fan size: 80x80mm.

$fn = 64;

// Dimensions
outer_w = 90;
outer_h = 90;
top_t   = 2;
wall_t  = 2.5;
box_h   = 40; // Total height from bed to open top
fan_w   = 80; // Inner clear width for the fan

// Screw holes
screw_d = 4.5;
screw_p = 71.5; // Pattern size
n_screws = 4;

// Cable notch
notch_w = 12;
notch_h = 8; // Depth from open edge (z=40) down to z=32

// Derived positions
// Top plate sits on z=0, so its top face is at z=top_t.
// Walls rise from z=top_t to z=box_h.
// Open edge is at z=box_h.
// Notch starts at z = box_h - notch_h.

// Calculate wall positions (centered on origin)
// Wall thickness is wall_t.
// Distance from center to inner face of wall = (outer_w - fan_w) / 2
// Distance from center to outer face of wall = outer_w / 2
// We will build the solid box first, then cut holes and notch.

// Define the main solid block
// It is a box of outer_w x outer_h x box_h.
// We will subtract the internal void to make it a shell.

module build_housing() {
    difference() {
        // 1. The solid outer block
        translate([0, 0, 0]) 
            cube([outer_w, outer_h, box_h]);

        // 2. Cut the internal void (the fan space)
        // The void is centered, has size fan_w x fan_w, and goes from z=0 to z=box_h.
        // We extend the cut slightly past the top and bottom to ensure clean faces.
        translate([0, 0, -1]) 
            cube([fan_w, fan_w, box_h + 2]);

        // 3. Cut the four screw holes through the top plate
        // Holes are at z=0 to z=top_t.
        // Pattern: 71.5mm square, centered.
        // Positions: +/- (screw_p/2) / 2 from center? No, pattern size is distance between centers.
        // So positions are: +/- (screw_p / 2) / 2? 
        // If pattern is 71.5mm, distance from center to first hole is 71.5 / 2 = 35.75.
        // Let's verify: 35.75 - (-35.75) = 71.5. Correct.
        
        hole_x = screw_p / 2;
        hole_y = screw_p / 2;

        for (i = [0 : n_screws - 1]) {
            // Map 0,1,2,3 to (-1,-1), (1,-1), (1,1), (-1,1)
            if (i == 0) { sx = -1; sy = -1; }
            else if (i == 1) { sx = 1; sy = -1; }
            else if (i == 2) { sx = 1; sy = 1; }
            else { sx = -1; sy = 1; }

            translate([sx * hole_x, sy * hole_y, 0])
                cylinder(h = top_t + 1, d = screw_d); // +1 to cut slightly past top
        }

        // 4. Cut the cable notch in one wall
        // Let's put it in the wall at y = -outer_h/2 + wall_t/2 (the front wall if Y is up, but let's say "front" is -Y).
        // Actually, let's put it in the wall at X = -outer_w/2 + wall_t/2 (Left wall).
        // Notch width: notch_w.
        // Notch depth: notch_h (from open edge z=box_h down to z=box_h-notch_h).
        // Position: Centered along the wall.
        // Wall center line is at x = -outer_w/2 + wall_t/2.
        // Notch is centered on this line.
        
        wall_x_pos = -outer_w / 2 + wall_t / 2;
        
        // The notch is a rectangular cutout.
        // It goes from z = box_h - notch_h to z = box_h.
        // Width is notch_w.
        // Depth into the wall is wall_t.
        
        translate([wall_x_pos, 0, box_h - notch_h])
            cube([notch_w, wall_t, notch_h]);
    }
}

build_housing();