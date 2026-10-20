// Dimensions for DIY Magnetic Stirrer Housing
// Based on 80mm PC fan, printed upside down (top plate on bed)

// Overall outer dimensions
W = 90;       // Width (X)
D = 90;       // Depth (Y)
H = 40;       // Height of walls

// Wall thickness
wall_thick = 2.5;

// Top plate thickness
top_thick = 2;

// Fan mounting holes
hole_dia = 4.5;
hole_spacing = 71.5; // Center-to-center distance of holes

// Cable notch dimensions
notch_width = 12;
notch_depth = 8; // Depth from the open edge (z=40) down to z=32

// --- Setup ---
$fn = 64;

// --- Helper: Fan Holes ---
// Pattern: 71.5mm square, centered on plate
// Plate is 90x90. Center is (45, 45).
// Holes are at +/- 71.5/2 = +/- 35.75 from center.
// X coords: 45 - 35.75 = 9.25 and 45 + 35.75 = 80.75
// Y coords: 9.25 and 80.75
hole_x1 = 9.25;
hole_x2 = 80.75;
hole_y1 = 9.25;
hole_y2 = 80.75;

// --- Main Model ---
difference() {
    // 1. Build the solid outer shell (walls + top plate)
    union() {
        // Top Plate (z=0 to z=2)
        translate([0, 0, 0])
            cube([W, D, top_thick], center=false);
            
        // Front Wall (Y=0 side)
        // Extends from z=top_thick to z=H
        translate([W/2, wall_thick/2, top_thick])
            cube([W, wall_thick, H - top_thick], center=false);
            
        // Back Wall (Y=D side)
        translate([W/2, D - wall_thick/2, top_thick])
            cube([W, wall_thick, H - top_thick], center=false);
            
        // Left Wall (X=0 side) - between front and back walls
        translate([wall_thick/2, wall_thick, top_thick])
            cube(wall_thick, D - 2*wall_thick, H - top_thick, center=false);
            
        // Right Wall (X=W side) - between front and back walls
        translate([W - wall_thick/2, wall_thick, top_thick])
            cube(wall_thick, D - 2*wall_thick, H - top_thick, center=false);
    }

    // 2. Hollow out the inside
    // Inner dimensions
    inner_w = W - 2*wall_thick;
    inner_d = D - 2*wall_thick;
    
    // Cutter extends from just below top plate to just above the open edge
    // to ensure clean boolean operations.
    void_cut = translate([wall_thick, wall_thick, top_thick - 0.01])
               cube([inner_w, inner_d, (H - top_thick) + 0.02], center=false);
    void_cut;

    // 3. Drill Fan Mounting Holes
    // Holes go through the top plate (z=0 to z=2)
    // Extend them slightly into the void below to ensure clean holes
    union() {
        translate([hole_x1, hole_y1, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
            
        translate([hole_x2, hole_y1, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
            
        translate([hole_x1, hole_y2, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
            
        translate([hole_x2, hole_y2, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
    }

    // 4. Cut Cable Notch
    // In one wall (let's use the Back Wall, Y=D side).
    // Notch is 12mm wide, centered along the wall (X=45).
    // Reaches 8mm down from the open edge (z=40) -> z=32 to z=40.
    // The notch goes through the wall thickness.
    
    // Wall is at Y from D-wall_thick to D.
    // Notch X range: 45 - 12/2 to 45 + 12/2 -> 39 to 51.
    // Notch Z range: 32 to 40.
    // We cut a slot through the back wall.
    
    notch_cut = translate([45, D - wall_thick/2, 32])
                cube([notch_width, wall_thick, notch_depth], center=false);
    notch_cut;
}