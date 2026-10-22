// Dimensions for 6x 50 mL Falcon Tubes Rack
// Units: mm

// Plate Dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;

// Tube Hole Dimensions
hole_diameter = 30.5;
hole_z_height = 70; // Height of the rack walls

// Grid Dimensions
grid_cols = 3;
grid_rows = 2;
grid_spacing_x = 40;
grid_spacing_y = 40;

// Wall Dimensions
wall_thickness = 4;
wall_height = hole_z_height;

$fn = 64;

// Main Rack Assembly
module rack() {
    union() {
        // 1. Base Plate
        translate([0, 0, 0])
            cube([plate_x, plate_y, plate_z], center = true);

        // 2. Tube Holes (Through holes)
        // Center the grid on the plate
        grid_offset_x = (grid_cols - 1) * grid_spacing_x / 2;
        grid_offset_y = (grid_rows - 1) * grid_spacing_y / 2;

        for (i = [0 : grid_cols - 1]) {
            for (j = [0 : grid_rows - 1]) {
                translate([
                    i * grid_spacing_x - grid_offset_x,
                    j * grid_spacing_y - grid_offset_y,
                    plate_z / 2
                ]) {
                    cylinder(
                        h = plate_z + 0.1, // Slightly extend to ensure clean through-hole
                        d = hole_diameter,
                        center = true
                    );
                }
            }
        }

        // 3. Side Walls
        // Left Wall (at Y = -plate_y/2)
        translate([0, -plate_y / 2, plate_z])
            cube([plate_x, wall_thickness, wall_height], center = true);

        // Right Wall (at Y = +plate_y/2)
        translate([0, plate_y / 2, plate_z])
            cube([plate_x, wall_thickness, wall_height], center = true);
    }
}

// Render
rack();