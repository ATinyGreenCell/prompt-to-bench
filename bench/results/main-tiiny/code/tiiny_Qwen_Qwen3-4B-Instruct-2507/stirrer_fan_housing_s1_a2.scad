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

// Power cable notch: 12 mm wide, centered along the wall, reaching 8 mm down from open edge (from z=32 to z=40)
notch_width = 12;
notch_depth = 8;

// Correct the model so that:
// - The housing is properly centered and starts at z=0
// - The top plate lies on z=0 to z=2, and walls rise from z=0 to z=40
// - The part is watertight and fully solid with correct geometry
// - The top plate is at z=0 to z=2, and walls extend from z=0 to z=40
// - The notch is cut in one wall (front wall) from z=32 to z=40, 12 mm wide, centered in y

// Start with the top plate (z=0 to z=2)
cube([outer_size_x, outer_size_y, top_thickness], center=true);

// Add the four walls, extending from z=0 to z=40
// Wall on left (x=0 to x=90)
translate([0, 0, 0]) 
    cube([wall_thickness, outer_size_y, housing_height], center=true);

// Wall on right (x=90 to x=0)
translate([outer_size_x - wall_thickness, 0, 0]) 
    cube([wall_thickness, outer_size_y, housing_height], center=true);

// Wall on front (y=0 to y=90)
translate([0, 0, 0]) 
    cube([outer_size_x, wall_thickness, housing_height], center=true);

// Wall on back (y=90 to y=0)
translate([0, outer_size_y - wall_thickness, 0]) 
    cube([outer_size_x, wall_thickness, housing_height], center=true);

// Drill four 4.5 mm holes for M4 screws on the top plate (centered, 71.5 mm apart)
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

// Cut a notch for power cable in the front wall (from z=32 to z=40, 12 mm wide, centered in y)
// The notch should be 8 mm deep (from z=32 to z=40), 12 mm wide, centered at y=45
// We use difference to cut the notch from the front wall
translate([0, 0, 0]) // start at z=0
difference() {
    // Front wall: 90x2.5x40, from z=0 to z=40
    cube([outer_size_x, wall_thickness, housing_height], center=true);
    
    // Notch: 12 mm wide, centered in y, from z=32 to z=40 (8 mm deep)
    translate([0, 0, 32]) 
        cube([outer_size_x, notch_width, notch_depth], center=true);
}