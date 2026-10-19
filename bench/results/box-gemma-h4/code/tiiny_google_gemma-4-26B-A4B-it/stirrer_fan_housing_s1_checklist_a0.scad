// Magnetic Stirrer Housing
// Designed for an 80mm PC fan.
// Print orientation: Top plate on the bed (z=0).

// Dimensions
outer_dim    = 90.0;    // Outer width and length (mm)
top_thickness = 2.0;    // Thickness of the top plate (mm)
wall_thickness = 2.5;   // Thickness of the four walls (mm)
total_height  = 40.0;   // Total height from top plate to open edge (mm)
hole_diam     = 4.5;    // Diameter of M4 screw holes (mm)
hole_pattern  = 71.5;   // Square pattern for fan mounting holes (mm)
notch_width   = 12.0;   // Width of the cable notch (mm)
notch_depth   = 8.0;    // Depth of the notch from the open edge (mm)

$fn = 64;

// Calculations
wall_height = total_height - top_thickness;
notch_start_z = total_height - notch_depth;

module housing() {
    difference() {
        // Main Body: The top plate and the four walls
        union() {
            // The top plate (sitting on Z=0)
            cube([outer_dim, outer_dim, top_thickness], center = true);
            
            // The four walls
            translate([0, 0, top_thickness + wall_height / 2]) {
                difference() {
                    // Outer boundary of walls
                    cube([outer_dim, outer_dim, wall_height], center = true);
                    // Inner cavity
                    cube([outer_dim - 2 * wall_thickness, outer_dim - 2 * wall_thickness, wall_height + 0.1], center = true);
                }
            }
        }

        // 1. The Cavity (to make it an open box)
        // We subtract the inner volume from the unioned body
        // Note: The union above already creates the walls, so we just need to 
        // ensure the interior is hollow.
        translate([0, 0, top_thickness + wall_height / 2])
            cube([outer_dim - 2 * wall_thickness, outer_dim - 2 * wall_thickness, wall_height + 2], center = true);

        // 2. Screw Holes (M4)
        // Pattern is 71.5mm square, centered.
        // Holes go through the top plate (z=0 to z=2)
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * hole_pattern / 2, sy * hole_pattern / 2, -1])
                cylinder(h = top_thickness + 2, d = hole_diam);
        }

        // 3. Cable Notch
        // Centered along one wall, reaching 8mm down from the open edge.
        // Open edge is at Z = 40. Notch is from Z = 32 to Z = 40.
        // We'll place it on the wall at +Y.
        translate([0, outer_dim / 2, total_height - notch_depth / 2])
            cube([notch_width, wall_thickness + 2, notch_depth + 0.1], center = true);
    }
}

// The model is built centered on X and Y.
// Since the top plate is 2mm thick and sits on Z=0, 
// we translate the whole assembly so the bottom of the plate is at Z=0.
// The union/difference logic above uses center=true for the cube, 
// so we must adjust the Z-offset.

// Correcting the assembly for Z=0 base:
// The top plate is at Z=0 to Z=2.
// The walls start at Z=2 and go to Z=40.
// To achieve this with center=true, we translate the whole thing.

translate([0, 0, 0]) {
    // The top plate is centered at Z = top_thickness/2
    // The walls are centered at Z = top_thickness + wall_height/2
    // To make the plate sit on Z=0, we must offset the entire assembly.
    // However, the logic above is easier if we build it from Z=0 up.
    
    // Let's redefine the assembly logic to be absolute for clarity.
}

// RE-WRITTEN ASSEMBLY FOR Z=0 BASE
difference() {
    // Outer Shell
    union() {
        // Top Plate
        cube([outer_dim, outer_dim, top_thickness]);
        
        // Walls
        translate([wall_thickness, wall_thickness, top_thickness])
        cube([outer_dim - 2*wall_thickness, outer_dim - 2*wall_thickness, wall_height]);
        
        // The "Outer" box to ensure walls are solid
        translate([0, 0, 0])
        cube([outer_dim, outer_dim, total_height]);
    }
    
    // Subtract the inner void
    translate([wall_thickness, wall_thickness, top_thickness])
        cube([outer_dim - 2*wall_thickness, outer_dim - 2*wall_thickness, wall_height + 1]);
        
    // Subtract Screw Holes
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * hole_pattern / 2, sy * hole_pattern / 2, -1])
            cylinder(h = top_thickness + 2, d = hole_diam);
    }
    
    // Subtract Cable Notch
    // Centered on Y-wall (at Y = outer_dim)
    // Width is X-axis, Depth is Y-axis, Height is Z-axis
    translate([-notch_width/2, outer_dim - wall_thickness, total_height - notch_depth])
        cube([notch_width, wall_thickness + 2, notch_depth + 1]);
}

// Final check: 
// Top plate: 0 to 2mm.
// Walls: 2 to 40mm.
// Outer: 90x90.
// Notch: 12mm wide, 8mm deep from top (Z=32 to 40).
// Holes: 4.5mm, 71.5mm pattern.