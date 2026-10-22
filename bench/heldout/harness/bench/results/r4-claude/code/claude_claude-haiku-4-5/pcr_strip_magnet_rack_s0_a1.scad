// Dimensions (in mm)
block_length_x = 80;        // Block length in X
block_width_y = 24;         // Block width in Y
block_height_z = 20;        // Block height in Z

// Tube seat dimensions
num_tubes = 8;              // Number of PCR tubes
tube_spacing = 9;           // Center-to-center spacing
tube_hole_dia = 6.4;        // Top hole diameter
tube_cone_dia = 3;          // Cone tip diameter at floor
tube_hole_depth = 8;        // Cylindrical hole depth (z=20 to z=12)
tube_cone_height = 10;      // Cone height (z=12 to z=2)

// Magnet pocket dimensions
magnet_length = 60.4;       // Length in X
magnet_width = 3.3;         // Width in Y
magnet_height = 10.2;       // Height (z=0 to z=10.2)

$fn = 64;

// Build the part
difference() {
    // Main solid block, centered on XY, resting on z=0
    translate([0, 0, block_height_z / 2]) {
        cube([block_length_x, block_width_y, block_height_z], center=true);
    }
    
    // 8 tube seats along y=0
    tube_start_x = -(num_tubes - 1) * tube_spacing / 2;
    
    for (i = [0:num_tubes-1]) {
        tube_x = tube_start_x + i * tube_spacing;
        
        // Top cylindrical hole from z=20 down to z=12, diameter 6.4mm
        translate([tube_x, 0, block_height_z - tube_hole_depth / 2]) {
            cylinder(h=tube_hole_depth + 0.5, d=tube_hole_dia, center=true);
        }
        
        // Conical hole from z=12 down to z=2, narrowing from 6.4mm to 3mm
        translate([tube_x, 0, (12 + 2) / 2]) {
            cylinder(h=tube_cone_height + 0.5, 
                    d1=tube_cone_dia, d2=tube_hole_dia, center=true);
        }
    }
    
    // Magnet pocket at y=-6, open at bottom face (z=0 to z=10.2)
    translate([0, -6, 0]) {
        cube([magnet_length, magnet_width, magnet_height], 
            center=[true, true, false]);
    }
    
    // Magnet pocket at y=6, open at bottom face (z=0 to z=10.2)
    translate([0, 6, 0]) {
        cube([magnet_length, magnet_width, magnet_height], 
            center=[true, true, false]);
    }
}