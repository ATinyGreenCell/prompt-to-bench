// Dimensions
outer_diameter_plate = 80;
inner_diameter_camera_hole = 12;
camera_hole_x = -20;
camera_hole_y = 10;
sleeve_outer_diameter = 36.6;
bore_stop_diameter = 22;
bore_open_diameter = 30.6;
hole_diameter_screw = 2.5;
screw_positions = [0, 120, 240];

// Plate
plate = cube([outer_diameter_plate, outer_diameter_plate, 3]);

// Camera hole
camera_hole = cylinder(r = inner_diameter_camera_hole / 2, h = 3 + 0.01);

// Sleeve
sleeve = cylinder(r = sleeve_outer_diameter / 2, h = 31 - 3 + 0.01);
bore_stop = cylinder(r = bore_stop_diameter / 2, h = 11 - 3 + 0.01);
bore_open = cylinder(r = bore_open_diameter / 2, h = 31 - 11 + 0.01);

// Screw holes
screw_holes = union() {
    for (i = [0:length(screw_positions)-1]) {
        rotate([0, 0, screw_positions[i]]) {
            translate([camera_hole_x, camera_hole_y, 21])
                cylinder(r = hole_diameter_screw / 2, h = 3 + 0.01);
        }
    }
};

// Final model
final_model = difference() {
    plate;
    camera_hole;
    sleeve;
    bore_stop;
    bore_open;
    screw_holes;
};