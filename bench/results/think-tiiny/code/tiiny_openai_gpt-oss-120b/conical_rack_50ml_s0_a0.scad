// Rack for six 50 mL Falcon tubes
// All dimensions in millimetres

$fn = 64;                         // smoothness for circles and cylinders

// Plate dimensions
plate_length   = 130;   // X direction
plate_width    = 90;    // Y direction
plate_thick    = 4;     // Z direction (thickness)

// Hole dimensions and layout
hole_dia       = 30.5;  // tube outer diameter
hole_spacing  = 40;    // centre‑to‑centre spacing (both X and Y)
hole_rows      = 2;    // number of rows along Y
hole_cols      = 3;    // number of columns along X

// Wall dimensions
wall_thick     = 4;    // thickness in Y
wall_height    = 70 - plate_thick;   // rises from plate top (z=4) to z=70

// Helper: plate half‑sizes for centering
half_len = plate_length/2;
half_wid = plate_width/2;

// Create the base plate (centered on origin, bottom at z=0)
plate = translate([-half_len, -half_wid, 0])
        cube([plate_length, plate_width, plate_thick]);

// Create the through‑holes (extend beyond the plate by 0.5 mm on each side)
hole_cut = [];
for (i = [-1,0,1]) {               // columns: -hole_spacing, 0, +hole_spacing
    for (j = [-1,1]) {            // rows: -hole_spacing/2, +hole_spacing/2
        x_pos = i * hole_spacing;
        y_pos = j * (hole_spacing/2);
        // cylinder placed slightly below and above the plate
        hole = translate([x_pos, y_pos, -0.5])
               cylinder(d=hole_dia, h=plate_thick + 1, center=false);
        hole_cut = concat(hole_cut, [hole]);
    }
}

// Create the two long side walls (flush with the long edges of the plate)
wall_long = cube([plate_length, wall_thick, wall_height]); // X×Y×Z

// +Y wall (inner side at Y = +half_wid)
wall_pos_plus = translate([-half_len, half_wid, plate_thick])
                wall_long;

// -Y wall (inner side at Y = -half_wid)
wall_pos_minus = translate([-half_len, -half_wid - wall_thick, plate_thick])
                 wall_long;

// Assemble the whole rack
rack = union() {
    plate,
    wall_pos_plus,
    wall_pos_minus
};

// Subtract the holes
final_part = difference() {
    rack,
    // each hole cylinder must extend beyond the faces it cuts
    // (the loop already creates the required cylinders)
    // we include them as a single union for simplicity
    union() {
        for (h = hole_cut) { h }
    }
};

final_part;