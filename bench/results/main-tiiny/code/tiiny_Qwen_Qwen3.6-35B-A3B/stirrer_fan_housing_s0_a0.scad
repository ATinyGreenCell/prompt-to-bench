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

// --- Main Body ---
// The part is an open box. We model it as a solid block with the inside hollowed out.
// Since it's printed upside down, the "top" is at z=0..2, and walls go up to z=40.

module housing() {
    // 1. Create the outer shell (walls + top plate)
    // We build the walls first, then cap them with the top plate.
    
    // Calculate inner dimensions
    inner_w = W - 2 * wall_thick;
    inner_d = D - 2 * wall_thick;
    
    // Walls height (from top plate top surface to open edge)
    wall_height = H - top_thick;
    
    // Build the four walls
    // Front wall (Y=0 side)
    translate([W/2, wall_thick/2, top_thick])
        cube([W, wall_thick, wall_height], center=false);
    
    // Back wall (Y=D side)
    translate([W/2, D - wall_thick/2, top_thick])
        cube([W, wall_thick, wall_height], center=false);
    
    // Left wall (X=0 side) - excluding corners already covered by front/back
    translate([wall_thick/2, wall_thick, top_thick])
        cube(wall_thick, inner_d, wall_height, center=false);
        
    // Right wall (X=W side) - excluding corners
    translate([W - wall_thick/2, wall_thick, top_thick])
        cube(wall_thick, inner_d, wall_height, center=false);
        
    // Top plate (at z=0 to z=top_thick)
    translate([0, 0, 0])
        cube([W, D, top_thick], center=false);
        
    // 2. Hollow out the inside
    // The inner cavity starts at z=top_thick and goes up to z=H
    // We use a cutting block that extends slightly past the boundaries to ensure clean boolean operations
    
    cut_z_start = top_thick - 0.01; // Extend slightly below top plate to ensure clean cut
    cut_z_end = H + 0.01;           // Extend slightly above open edge
    
    inner_cut = cube([inner_w, inner_d, cut_z_end - cut_z_start], center=false);
    translate([wall_thick, wall_thick, cut_z_start])
        difference() {
            // This difference is applied to the whole assembly later, 
            // but here we define the cutter.
            // Actually, it's easier to define the whole solid and subtract the inner void.
        }
        
    // Let's rebuild using a single union of solids and then subtract the inner void
}

// Re-defining using a cleaner approach: Union of walls and top, then subtract inner void.

module stirrer_housing() {
    // Define the solid parts
    part = union() {
        // Top plate
        translate([0, 0, 0])
            cube([W, D, top_thick], center=false);
            
        // Front Wall
        translate([W/2, wall_thick/2, top_thick])
            cube([W, wall_thick, H - top_thick], center=false);
            
        // Back Wall
        translate([W/2, D - wall_thick/2, top_thick])
            cube([W, wall_thick, H - top_thick], center=false);
            
        // Left Wall (between front and back)
        translate([wall_thick/2, wall_thick, top_thick])
            cube(wall_thick, D - 2*wall_thick, H - top_thick, center=false);
            
        // Right Wall (between front and back)
        translate([W - wall_thick/2, wall_thick, top_thick])
            cube(wall_thick, D - 2*wall_thick, H - top_thick, center=false);
    };
    
    // Inner void cutter
    // Inner dimensions
    i_w = W - 2*wall_thick;
    i_d = D - 2*wall_thick;
    
    // Cutter extends from just below top plate to just above the open edge
    cutter = translate([wall_thick, wall_thick, top_thick - 0.01])
             cube([i_w, i_d, (H - top_thick) + 0.02], center=false);
             
    // Apply boolean difference
    difference() {
        part;
        cutter;
    }
    
    // 3. Drill Fan Mounting Holes
    // Pattern: 71.5mm square, centered on plate
    // Plate is 90x90. Center is (45, 45).
    // Holes are at +/- 71.5/2 = +/- 35.75 from center.
    // X coords: 45 - 35.75 = 9.25 and 45 + 35.75 = 80.75
    // Y coords: 9.25 and 80.75
    
    hole_x1 = 9.25;
    hole_x2 = 80.75;
    hole_y1 = 9.25;
    hole_y2 = 80.75;
    
    // Holes go through the top plate (z=0 to z=2)
    // We extend them slightly into the void below to ensure clean holes
    hole_cut = union() {
        translate([hole_x1, hole_y1, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
            
        translate([hole_x2, hole_y1, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
            
        translate([hole_x1, hole_y2, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
            
        translate([hole_x2, hole_y2, -0.01])
            cylinder(h=H + 0.02, d=hole_dia, center=false);
    };
    
    difference() {
        stirrer_housing(); // This creates a syntax error if nested like this. 
                           // I need to structure the code linearly.
    }
}

// Correct Structure:
// 1. Base Solid (Walls + Top)
// 2. Subtract Inner Void
// 3. Subtract Holes
// 4. Subtract Notch

// Step 1: Base Solid
base_solid = union() {
    // Top Plate
    translate([0, 0, 0])
        cube([W, D, top_thick], center=false);
        
    // Front Wall
    translate([W/2, wall_thick/2, top_thick])
        cube([W, wall_thick, H - top_thick], center=false);
        
    // Back Wall
    translate([W/2, D - wall_thick/2, top_thick])
        cube([W, wall_thick, H - top_thick], center=false);
        
    // Left Wall
    translate([wall_thick/2, wall_thick, top_thick])
        cube(wall_thick, D - 2*wall_thick, H - top_thick, center=false);
        
    // Right Wall
    translate([W - wall_thick/2, wall_thick, top_thick])
        cube(wall_thick, D - 2*wall_thick, H - top_thick, center=false);
};

// Step 2: Inner Void
inner_w = W - 2*wall_thick;
inner_d = D - 2*wall_thick;
void_cut = translate([wall_thick, wall_thick, top_thick - 0.01])
           cube([inner_w, inner_d, (H - top_thick) + 0.02], center=false);

// Step 3: Fan Holes
hole_x1 = 9.25;
hole_x2 = 80.75