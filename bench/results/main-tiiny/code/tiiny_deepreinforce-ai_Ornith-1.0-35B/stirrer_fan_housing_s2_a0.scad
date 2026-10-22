// === Dimensions ===
// Top plate thickness
top_plate_thick = 2;
// Wall thickness
wall_thick = 2.5;
// Wall height (from top of plate)
wall_height = 40;
// Outer width (X)
outer_w = 90;
// Outer depth (Y)
outer_d = 90;
// Total height (plate + walls)
total_h = top_plate_thick + wall_height;
// Screw hole diameter
screw_dia = 4.5;
// Screw hole pattern size (square)
screw_pattern = 71.5;
// Cable notch width
notch_w = 12;
// Cable notch depth from top edge
notch_depth = 8;
// Notch position (which wall: 0=X+, 1=Y+, 2=X-, 3=Y-)
notch_wall = 0; // X+ wall

// === Calculated ===
// Inner width
inner_w = outer_w - 2 * wall_thick;
// Inner depth
inner_d = outer_d - 2 * wall_thick;
// Notch start Z (from bottom)
notch_z_start = total_h - notch_depth;

// === Build ===
union() {
    // Top plate (on bed)
    cube([outer_w, outer_d, top_plate_thick], center=false);
    
    // Four walls
    // X+ wall
    translate([outer_w - wall_thick, 0, top_plate_thick])
        cube([wall_thick, outer_d, wall_height]);
    // X- wall
    translate([0, 0, top_plate_thick])
        cube([wall_thick, outer_d, wall_height]);
    // Y+ wall
    translate([0, outer_d - wall_thick, top_plate_thick])
        cube([outer_w, wall_thick, wall_height]);
    // Y- wall
    translate([0, 0, top_plate_thick])
        cube([outer_w, wall_thick, wall_height]);
    
    // Cable notch in X+ wall
    translate([outer_w - wall_thick - 0.01, (outer_d - notch_w)/2, notch_z_start])
        cube([wall_thick + 0.02, notch_w, notch_depth + 0.01]);
}

// Screw holes through top plate
for (i = [-1, 1]) {
    for (j = [-1, 1]) {
        translate([
            (outer_w/2) + (i * screw_pattern/2),
            (outer_d/2) + (j * screw_pattern/2),
            -0.01
        ])
        cylinder(d=screw_dia, h=total_h + 0.02, center=false, $fn=64);
    }
}