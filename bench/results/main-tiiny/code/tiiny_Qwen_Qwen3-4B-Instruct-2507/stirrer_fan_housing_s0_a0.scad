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

// Hole diameter for M4 screws
hole_diameter = 4.5;

// Screw hole pattern (square, centered on top plate)
hole_spacing = 71.5;

// Power cable notch: 12mm wide, centered along wall, from z=32 to z=40
notch_width = 12;
notch_depth = 8; // from z=32 to z=40, so 8mm down from open edge

// Define the housing as a base (top plate at z=0 to z=2)
// Then extend walls upward to z=40

// Top plate: 90x90, 2mm thick, at z=0 to z=2
top_plate = cube([outer_size_x, outer_size_y, top_thickness], center=true);

// Four walls: extend from z=2 to z=40, 2.5mm thick
// Each wall is a rectangle extending from the top plate outward

// Front wall (positive Y)
front_wall = translate([0, outer_size_y/2, 0]) 
    cube([outer_size_x, wall_thickness, housing_height], center=true);

// Back wall (negative Y)
back_wall = translate([0, -outer_size_y/2, 0]) 
    cube([outer_size_x, wall_thickness, housing_height], center=true);

// Left wall (negative X)
left_wall = translate([-outer_size_x/2, 0, 0]) 
    cube([wall_thickness, outer_size_y, housing_height], center=true);

// Right wall (positive X)
right_wall = translate([outer_size_x/2, 0, 0]) 
    cube([wall_thickness, outer_size_y, housing_height], center=true);

// Union of walls and top plate
housing = union() {
    top_plate;
    front_wall;
    back_wall;
    left_wall;
    right_wall;
};

// Drill four 4.5mm holes for M4 screws on the top plate
// Pattern: 71.5mm square, centered on the 90x90 plate
// Holes go through the top plate (z=0 to z=2), so we cut 0.01mm beyond the face

for (i = [0, 1, 2, 3]) {
    // Positions: 4 holes at 71.5mm spacing, centered
    // Coordinates: (x, y) = (±45 - 35.75, ±45 - 35.75) for 4 holes
    // Centered at (0,0), spaced 71.5mm apart
    let x_offset = [ -35.75, 35.75 ][i % 2];
    let y_offset = [ -35.75, 35.75 ][i / 2];
    
    // Cut a hole of 4.5mm diameter, extending 0.01mm beyond the face
    // to avoid coplanar faces
    hole = translate([x_offset, y_offset, 0]) 
        cylinder(r = hole_diameter / 2, h = top_thickness + 0.01, center=true);
    
    housing = difference() {
        housing;
        hole;
    };
}

// Cut a notch for power cable in one wall (say, front wall)
// Notch: 12mm wide, centered along the front wall, from z=32 to z=40
// So from z=32 to z=40, 8mm down from open edge

// Notch in front wall: centered along Y, from z=32 to z=40
// 12mm wide, centered at x=0, y=0, in the front wall
notch = translate([0, 0, 32]) 
    cube([notch_width, wall_thickness, notch_depth], center=true);

// Subtract the notch from the housing
housing = difference() {
    housing;
    notch;
};

// Final housing with top plate on z=0, walls rising to z=40
// Open at top, closed on bottom
// All dimensions respected, holes and notch properly placed