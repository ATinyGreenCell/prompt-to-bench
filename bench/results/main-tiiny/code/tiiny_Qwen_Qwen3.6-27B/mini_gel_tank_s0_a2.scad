// Buffer tank for mini horizontal gel-electrophoresis box
// Dimensions measured with calipers

// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Inner dimensions (derived)
inner_x = outer_x - 2 * wall_thickness;
inner_y = outer_y - 2 * wall_thickness;
inner_z = outer_z - floor_thickness;

// Gel tray platform dimensions
platform_x = 60;
platform_y = inner_y; // spans full inner width
platform_z = 10; // height above inner floor
platform_top_z = floor_thickness + platform_z; // absolute z position of top surface (13 mm)

// Electrode wire holes
hole_diameter = 2;
hole_y = 0;
hole_z = 30;

// Rendering quality
$fn = 64;

// Main tank body (outer shell minus inner cavity)
difference() {
    // Outer block
    translate([-outer_x/2, -outer_y/2, 0])
        cube([outer_x, outer_y, outer_z]);
    
    // Inner cavity (open top)
    // The cavity starts at floor_thickness and goes up to outer_z + 1 to ensure full cut
    translate([-inner_x/2, -inner_y/2, floor_thickness])
        cube([inner_x, inner_y, outer_z - floor_thickness + 1]);
    
    // Gel tray platform
    // The platform sits on the inner floor (z = floor_thickness) and rises by platform_z
    translate([-platform_x/2, -platform_y/2, floor_thickness])
        cube([platform_x, platform_y, platform_z]);
    
    // Electrode wire holes (left and right end walls)
    // Left end wall hole
    translate([-outer_x/2 + wall_thickness/2, hole_y, hole_z])
        rotate([0, 90, 0])
            cylinder(r = hole_diameter/2, h = wall_thickness + 0.1, center = true);
    
    // Right end wall hole
    translate([outer_x/2 - wall_thickness/2, hole_y, hole_z])
        rotate([0, 90, 0])
            cylinder(r = hole_diameter/2, h = wall_thickness + 0.1, center = true);
}