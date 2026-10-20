// Dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;
hole_dia = 30.5;
hole_rows = 2; // along Y
hole_cols = 3; // along X
spacing_x = 40;
spacing_y = 40;
wall_x = 130;
wall_y = 4;
wall_top_z = 70;
wall_start_z = plate_z;

// Hole centers
x_centers = [ -spacing_x, 0, spacing_x ];
y_centers = [ -spacing_y/2, spacing_y/2 ];
hole_r = hole_dia / 2;

// Build plate
plate = translate([0, 0, plate_z/2]) cube([plate_x, plate_y, plate_z], center=true);

// Build walls
wall1 = translate([-wall_x/2, -plate_y/2, wall_start_z]) cube([wall_x, wall_y, wall_top_z - wall_start_z], center=false);
wall2 = translate([-wall_x/2, plate_y/2 - wall_y, wall_start_z]) cube([wall_x, wall_y, wall_top_z - wall_start_z], center=false);

// Union plate and walls
rack_body = union() {
    plate;
    wall1;
    wall2;
};

// Cut holes
$fn = 64;
difference() {
    rack_body;
    for (x = x_centers) {
        for (y = y_centers) {
            translate([x, y, -1]) cylinder(r=hole_r, h=6, center=false);
        }
    }
}