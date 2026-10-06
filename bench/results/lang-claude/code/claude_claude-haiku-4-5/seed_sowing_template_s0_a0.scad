// Dimensions
disk_diameter = 85;          // mm
disk_radius = disk_diameter / 2;
disk_thickness = 2;          // mm
hole_diameter = 3;           // mm
hole_radius = hole_diameter / 2;
grid_size = 7;               // 7x7 grid
hole_spacing = 9;            // mm center-to-center
notch_width_x = 10;          // mm (X direction)
notch_depth_y = 4;           // mm (Y direction, from edge inward)

$fn = 64;

// Calculate grid extent (distance from center to outermost hole)
grid_extent = (grid_size - 1) * hole_spacing / 2;

// Main disk with holes and notch
difference() {
    // Base disk
    cylinder(h = disk_thickness, r = disk_radius, center = false);
    
    // Grid of holes (7x7, centered in disk)
    for (i = [0:grid_size-1]) {
        for (j = [0:grid_size-1]) {
            x = -grid_extent + i * hole_spacing;
            y = -grid_extent + j * hole_spacing;
            translate([x, y, -0.5]) {
                cylinder(h = disk_thickness + 1, r = hole_radius);
            }
        }
    }
    
    // Rectangular notch on +Y edge (orientation indicator)
    translate([0, disk_radius - notch_depth_y/2, -0.5]) {
        cube([notch_width_x, notch_depth_y + 1, disk_thickness + 1], center = true);
    }
}