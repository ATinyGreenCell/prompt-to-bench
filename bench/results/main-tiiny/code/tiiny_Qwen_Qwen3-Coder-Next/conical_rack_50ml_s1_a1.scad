// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down and flipped over after printing

$fn = 64;

// Plate dimensions
plate_x = 130; // mm
plate_y = 90;  // mm
plate_z = 4;   // mm

// Hole dimensions
hole_dia = 30.5; // mm
hole_spacing_x = 40; // mm
hole_spacing_y = 40; // mm

// Calculate hole positions (centered on plate)
// 3 holes along X: positions at -40, 0, +40 mm relative to center
// 2 holes along Y: positions at -20, +20 mm relative to center
hole_positions_x = [-40, 0, 40];
hole_positions_y = [-20, 20];

// Wall dimensions
wall_thickness = 4; // mm
wall_height = 70;   // mm

// Generate holes
module holes() {
    for (x_pos = hole_positions_x) {
        for (y_pos = hole_positions_y) {
            translate([x_pos, y_pos, -1]) 
                cylinder(h = plate_z + 2, d = hole_dia);
        }
    }
}

// Generate walls
module walls() {
    // Left wall (along X axis at left edge)
    translate([-plate_x/2 - wall_thickness/2, -plate_y/2, plate_z])
        cube([wall_thickness, plate_y, wall_height]);
    
    // Right wall (along X axis at right edge)
    translate([plate_x/2 - wall_thickness/2, -plate_y/2, plate_z])
        cube([wall_thickness, plate_y, wall_height]);
}

// Main body: plate with holes and walls
module rack() {
    difference() {
        union() {
            // Base plate
            translate([0, 0, plate_z/2])
                cube([plate_x, plate_y, plate_z], center=true);
            
            // Walls
            walls();
        }
        
        // Holes
        holes();
    }
}

rack();