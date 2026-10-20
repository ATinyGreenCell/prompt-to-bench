// Dimensions for DIY magnetic stirrer housing from 80mm PC case fan
$fn = 64;

// Outer size of housing (X x Y)
outer_size_x = 90;
outer_size_y = 90;

// Wall thickness (2.5 mm)
wall_thickness = 2.5;

// Top plate thickness (2 mm)
top_thickness = 2.0;

// Height of housing (from z=0 to z=40)
housing_height = 40;

// Hole diameter (4.5 mm) for M4 screws
hole_diameter = 4.5;

// Screw hole pattern (71.5 mm square, centered on top plate)
hole_spacing = 71.5;

// Power cable notch: 12 mm wide, centered, from z=32 to z=40 (8 mm down from open edge)
notch_width = 12;
notch_depth = 8;

// Define the housing as a union of top plate and walls
module housing() {
    // Top plate: 90x90x2 mm, at z=0 to z=2
    cube([outer_size_x, outer_size_y, top_thickness], center=true);

    // Four walls: 2.5 mm thick, extending from z=2 to z=40
    // Wall on left (x=0 to x=90)
    translate([0, 0, 2]) cube([wall_thickness, outer_size_y, housing_height - 2], center=true);
    
    // Wall on right (x=90 to x=0)
    translate([outer_size_x - wall_thickness, 0, 2]) cube([wall_thickness, outer_size_y, housing_height - 2], center=true);
    
    // Wall on front (y=0 to y=90)
    translate([0, 0, 2]) cube([outer_size_x, wall_thickness, housing_height - 2], center=true);
    
    // Wall on back (y=90 to y=0)
    translate([0, outer_size_y - wall_thickness, 2]) cube([outer_size_x, wall_thickness, housing_height - 2], center=true);
}

// Create the housing
housing();

// Drill four 4.5 mm holes for M4 screws on top plate (centered, 71.5 mm apart)
// Holes are centered on the top plate (z=0 to z=2)
// Pattern: 71.5 mm square, centered at (45, 45)
for (i = [0, 1]) {
    for (j = [0, 1]) {
        translate([
            45 - hole_spacing/2 + i * hole_spacing,
            45 - hole_spacing/2 + j * hole_spacing,
            0
        ]) 
        cylinder(d=hole_diameter, h=top_thickness, center=true);
    }
}

// Cut a notch for power cable in one wall (say, the front wall)
// Notch: 12 mm wide, centered along the front wall, from z=32 to z=40
// Position: centered along y-axis, at x=45, from y=0 to y=12
translate([0, 0, 2]) // start at z=2 (bottom of wall)
difference() {
    // Front wall (from z=2 to z=40)
    cube([outer_size_x, wall_thickness, housing_height - 2], center=true);
    
    // Notch: 12 mm wide, centered in y, from z=32 to z=40
    translate([0, 0, 32]) // start at z=32
    cube([outer_size_x, notch_width, 8], center=true); // 8 mm deep
}