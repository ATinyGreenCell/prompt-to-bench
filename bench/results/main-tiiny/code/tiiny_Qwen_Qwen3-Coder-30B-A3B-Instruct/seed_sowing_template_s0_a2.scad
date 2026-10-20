// Sowing template for 90 mm Petri dish
// Flat disc, 85 mm diameter, 2 mm thick
// 7 x 7 grid of 3 mm diameter through-holes, 9 mm centre-to-centre spacing
// Orientation notch: 10 mm wide (X), 4 mm deep (Y), centered on rim

// Dimensions
disk_diameter = 85;
disk_thickness = 2;
hole_diameter = 3;
hole_spacing = 9;
grid_size = 7;
notch_width = 10;
notch_depth = 4;

// Create the base disc
disk = cylinder(d = disk_diameter, h = disk_thickness, center = true, $fn = 64);

// Create the hole grid
hole_grid = 
    for (x = [-3:1:3]) {
        for (y = [-3:1:3]) {
            translate([x * hole_spacing, y * hole_spacing, 0]) 
                cylinder(d = hole_diameter, h = disk_thickness + 0.1, center = true, $fn = 64);
        }
    };

// Create the orientation notch
notch = 
    translate([0, disk_diameter/2 - notch_depth, 0]) 
        cube([notch_width, notch_depth, disk_thickness + 0.1], center = [true, false, true]);

// Combine all parts
union() {
    disk;
    hole_grid;
    notch;
}