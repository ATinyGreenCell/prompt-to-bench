// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down and flipped over after printing

$fn = 64;

// Plate dimensions
plate_length = 130; // X direction
plate_width  = 90;  // Y direction
plate_thick  = 4;   // Z direction

// Hole pattern
hole_dia = 30.5;
hole_pitch_x = 40; // X direction spacing
hole_pitch_y = 40; // Y direction spacing
num_holes_x = 3;
num_holes_y = 2;

// Wall dimensions
wall_thick = 4;
wall_height = 70;

// Calculate hole positions (centred on plate)
plate_centre_x = plate_length / 2;
plate_centre_y = plate_width / 2;

// Total span of holes
holes_span_x = (num_holes_x - 1) * hole_pitch_x;
holes_span_y = (num_holes_y - 1) * hole_pitch_y;

// Offset from plate centre to first hole
offset_x = (holes_span_x) / 2;
offset_y = (holes_span_y) / 2;

// Plate
module plate() {
    translate([0, 0, 0])
        cube([plate_length, plate_width, plate_thick]);
}

// Holes
module holes() {
    for (i = [0 : num_holes_x - 1]) {
        for (j = [0 : num_holes_y - 1]) {
            x = plate_centre_x - offset_x + i * hole_pitch_x;
            y = plate_centre_y - offset_y + j * hole_pitch_y;
            translate([x, y, -1])
                cylinder(d = hole_dia, h = plate_thick + 2);
        }
    }
}

// Walls (along long edges, i.e., along X-axis at Y = 0 and Y = plate_width)
module walls() {
    // Front wall (Y = 0)
    translate([0, 0, plate_thick])
        cube([plate_length, wall_thick, wall_height]);
    
    // Back wall (Y = plate_width - wall_thick)
    translate([0, plate_width - wall_thick, plate_thick])
        cube([plate_length, wall_thick, wall_height]);
}

// Build the rack
difference() {
    union() {
        plate();
        walls();
    }
    holes();
}