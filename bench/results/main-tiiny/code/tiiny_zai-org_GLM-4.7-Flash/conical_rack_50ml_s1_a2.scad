// Dimensions for 6x 50 mL Falcon Tubes Rack
// Units: mm

// Plate Dimensions
plate_x = 130;
plate_y = 90;
plate_thickness = 4;

// Tube Hole Dimensions
hole_diameter = 30.5;
hole_spacing_x = 40;
hole_spacing_y = 40;

// Wall Dimensions
wall_thickness = 4;
wall_height = 70;

// Derived Dimensions
hole_radius = hole_diameter / 2;
wall_y_offset = (plate_y / 2) - (wall_thickness / 2);

// Render
$fn = 64;

// Main Assembly
module rack_assembly() {
    union() {
        // 1. The Base Plate
        translate([0, 0, 0])
            cube([plate_x, plate_y, plate_thickness], center=true);

        // 2. The Walls
        // Left Wall
        translate([0, -wall_y_offset, 0])
            cube([plate_x, wall_thickness, wall_height], center=true);
        
        // Right Wall
        translate([0, wall_y_offset, 0])
            cube([plate_x, wall_thickness, wall_height], center=true);

        // 3. The Through-Holes
        // Calculate grid offsets
        // 3 holes along X, 2 rows along Y
        // Spacing is 40mm. 
        // Center of grid is (0,0).
        // X offsets: -40, 0, 40
        // Y offsets: -20, 20
        
        for (x_offset = [-hole_spacing_x, 0, hole_spacing_x]) {
            for (y_offset = [-hole_spacing_y / 2, hole_spacing_y / 2]) {
                translate([x_offset, y_offset, 0])
                    cylinder(h = plate_thickness + 1, r = hole_radius, center=true);
            }
        }
    }
}

// Generate the part
rack_assembly();