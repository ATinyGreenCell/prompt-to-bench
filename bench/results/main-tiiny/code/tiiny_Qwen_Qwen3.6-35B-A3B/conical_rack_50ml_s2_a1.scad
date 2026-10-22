// Dimensions
plate_x = 130;
plate_y = 90;
plate_z = 4;
hole_diameter = 30.5;
wall_height = 70;
wall_thickness = 4;
tube_rows = 2;
tube_cols = 3;
tube_pitch_x = 40;
tube_pitch_y = 40;

// Calculate hole positions
// Plate center is at (0, 0)
// X range: -65 to 65
// Y range: -45 to 45
// 3 columns along X: -40, 0, 40
// 2 rows along Y: -20, 20

x_positions = [-40, 0, 40];
y_positions = [-20, 20];

// Build the base plate with holes
base_plate = difference() {
    // Main plate block
    cube([plate_x, plate_y, plate_z], center = true);
    
    // Holes
    for (x = x_positions) {
        for (y = y_positions) {
            $fn = 64;
            translate([x, y, 0])
                cylinder(h = plate_z + 0.1, d = hole_diameter, center = true);
        }
    }
};

// Build the two long walls
// Walls run along X (130mm) and are at Y = +/- (plate_y/2 - wall_thickness/2)
// Wait, the prompt says "flush with the plate's long edge".
// Long edges are at Y = +/- 45.
// Wall thickness is 4mm in Y.
// So walls are at Y = 45 - 2 = 43 and Y = -45 + 2 = -43?
// Or does "flush" mean the outer face is at the edge?
// "Two solid walls run along the two long edges... flush with the plate's long edge"
// Usually, this means the wall is attached to the edge.
// If the wall is 4mm thick in Y, and flush with the edge, it likely extends inwards or outwards.
// Given it's a rack, it probably extends inwards to support the tubes or just forms a barrier.
// However, "flush with the plate's long edge" usually implies the outer surface aligns with the plate edge.
// Let's assume the wall is on the inside of the edge, or centered?
// "flush with" strongly suggests alignment of the outer boundary.
// So, Wall 1: X [-65, 65], Y [41, 45], Z [4, 70]
// Wall 2: X [-65, 65], Y [-45, -41], Z [4, 70]

wall_x = 130;
wall_y_start_pos = 45; // Outer face
wall_y_thickness = 4;

wall_1 = translate([0, wall_y_start_pos - wall_y_thickness/2, plate_z])
    cube([wall_x, wall_y_thickness, wall_height], center = true);

wall_2 = translate([0, -(wall_y_start_pos - wall_y_thickness/2), plate_z])
    cube([wall_x, wall_y_thickness, wall_height], center = true);

// Combine parts
rack = union() {
    base_plate;
    wall_1;
    wall_2;
};

// Ensure the final object is solid
// The holes go through the plate. The walls are separate.
// This creates the desired geometry.

render() {
    rack;
}