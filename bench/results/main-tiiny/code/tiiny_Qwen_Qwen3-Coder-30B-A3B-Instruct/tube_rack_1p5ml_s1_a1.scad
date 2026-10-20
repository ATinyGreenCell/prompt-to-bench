// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions in millimeters

// Block dimensions
length = 106;   // X direction
width = 72;     // Y direction
height = 30;    // Z direction

// Hole grid parameters
hole_count_x = 6;
hole_count_y = 4;
center_to_center = 16;
hole_diameter = 11.2;
hole_depth = 25;
floor_thickness = 5;

// Derived variables
hole_radius = hole_diameter / 2;
grid_width = (hole_count_x - 1) * center_to_center;
grid_length = (hole_count_y - 1) * center_to_center;
grid_offset_x = (length - grid_width) / 2;
grid_offset_y = (width - grid_length) / 2;

// Main block
base_block = cube([length, width, height], center=true);

// Create holes
hole_grid = 
    for (x = [0 : hole_count_x - 1]) {
        for (y = [0 : hole_count_y - 1]) {
            translate([
                grid_offset_x + x * center_to_center,
                grid_offset_y + y * center_to_center,
                height - hole_depth - floor_thickness
            ])
            cylinder(h = hole_depth + 0.01, r = hole_radius, center=false, $fn=64);
        }
    }

// Final assembly
difference() {
    base_block;
    union() {
        for (x = [0 : hole_count_x - 1]) {
            for (y = [0 : hole_count_y - 1]) {
                translate([
                    grid_offset_x + x * center_to_center,
                    grid_offset_y + y * center_to_center,
                    height - hole_depth - floor_thickness
                ])
                cylinder(h = hole_depth + 0.01, r = hole_radius, center=false, $fn=64);
            }
        }
    }
}