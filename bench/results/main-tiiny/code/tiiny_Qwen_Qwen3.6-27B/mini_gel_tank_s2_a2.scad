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

// Gel tray platform
platform_x = 60;
platform_y = inner_y; // spans full inner width
platform_z = 10; // height above inner floor
platform_z_top = floor_thickness + platform_z; // absolute z of top surface (13)

// Electrode wire holes
hole_diameter = 2;
hole_y = 0; // centred in Y
hole_z = 30; // absolute z

// Resolution for curved shapes
$fn = 64;

// Main tank body (outer shell minus inner cavity)
// The tank sits on z=0.
difference() {
    // Outer block sitting on z=0
    translate([0, 0, 0])
        cube([outer_x, outer_y, outer_z], center = false);
    
    // Inner cavity (open top)
    // Starts at z = floor_thickness, goes up to z = outer_z + small extension
    translate([wall_thickness, wall_thickness, floor_thickness - 0.5])
        cube([inner_x, inner_y, outer_z - floor_thickness + 1], center = false);
}

// Gel tray platform (solid raised structure in the middle)
// Centered in X and Y, sitting on the floor (z = floor_thickness)
translate([0, 0, floor_thickness])
    cube([platform_x, platform_y, platform_z], center = true);

// Electrode wire holes through end walls
// Left end wall hole
translate([-outer_x/2, hole_y, hole_z])
    rotate([0, 90, 0])
        cylinder(r = hole_diameter/2, h = outer_x + 1, center = true);

// Right end wall hole
translate([outer_x/2, hole_y, hole_z])
    rotate([0, 90, 0])
        cylinder(r = hole_diameter/2, h = outer_x + 1, center = true);