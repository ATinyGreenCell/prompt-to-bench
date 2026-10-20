// Rack for six 50 mL Falcon tubes
// Print orientation: upside down, flipped after printing
// Units: mm

$fn = 64; // smoothness for cylinders

// Plate dimensions
plate_X = 130;
plate_Y = 90;
plate_Z = 4;

// Hole parameters
hole_d = 30.5;
hole_h = plate_Z + 0.02; // extend 0.01 mm beyond each face
hole_z = plate_Z / 2;   // center at middle of plate

// Hole grid: 3 columns (X) and 2 rows (Y)
// centre‑to‑centre spacing 40 mm
hole_X_offsets = [-40, 0, 40];
hole_Y_offsets = [-20, 20];

// Wall parameters
wall_X = plate_X;          // 130 mm long in X
wall_Y = 4;                // 4 mm thick in Y
wall_Z = 70 - plate_Z;     // 66 mm tall
wall_Z_ext = wall_Z + 0.02; // extend 0.01 mm beyond top and bottom
wall_z = plate_Z - 0.01;   // bottom starts 0.01 mm below plate top

// Plate origin: centred on X and Y, bottom at z = 0
plate_origin = [ -plate_X/2, -plate_Y/2, 0 ];

// Wall origins: left wall at Y = -plate_Y/2 - wall_Y,
// right wall at Y = plate_Y/2
left_wall_origin  = [ -plate_X/2, -plate_Y/2 - wall_Y, wall_z ];
right_wall_origin = [ -plate_X/2,  plate_Y/2,          wall_z ];

// Build plate with holes
module plate_with_holes() {
    difference() {
        // Plate
        translate(plate_origin) cube([plate_X, plate_Y, plate_Z]);

        // Holes
        for (x = hole_X_offsets) {
            for (y = hole_Y_offsets) {
                translate([x, y, hole_z]) cylinder(d=hole_d, h=hole_h, center=true);
            }
        }
    }
}

// Build walls
module walls() {
    union() {
        // Left wall
        translate(left_wall_origin) cube([wall_X, wall_Y, wall_Z_ext]);

        // Right wall
        translate(right_wall_origin) cube([wall_X, wall_Y, wall_Z_ext]);
    }
}

// Final rack
union() {
    plate_with_holes();
    walls();
}