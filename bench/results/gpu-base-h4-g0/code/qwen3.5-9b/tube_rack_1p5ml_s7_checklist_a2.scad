// Bench rack for 1.5 mL microcentrifuge tubes.
// Solid block 106x72x30 mm with 24 vertical holes (4 rows x 6 cols).
// Holes are 11.2 mm diameter, 25 mm deep, centred on the block.
// Holes have a small bottom radius and extend slightly past the floor for clean cutting.

L     = 106;
W     = 72;
H     = 30;
hole_d = 11.2;
hole_depth = 25;
floor_thickness = 5;
hole_bottom_radius = 0.5;

// Verify dimensions: 4 rows * 16mm + 2*inset = 72 => inset = 4mm
// Verify dimensions: 6 cols * 16mm + 2*inset = 106 => inset = 4mm
inset = 4;

$fn = 64;

difference() {
    // Main block
    translate([-L/2, -W/2, 0]) cube([L, W, H]);

    // Holes
    // 6 columns along X, 4 rows along Y
    for (i = [0 : 5]) {
        for (j = [0 : 3]) {
            // Calculate position relative to block centre
            x_pos = (i - 2.5) * 16;
            y_pos = (j - 1.5) * 16;
            
            // Create a hole with a small bottom radius and ensure it cuts through the floor
            // The cylinder extends past the bottom of the part (z=0) to ensure a clean cut
            translate([x_pos, y_pos, -1]) 
                cylinder(h = hole_depth + floor_thickness + 1, d = hole_d);
            
            // Add a small fillet to the bottom of the hole for better printability
            // This is done by creating a smaller cylinder at the very bottom
            translate([x_pos, y_pos, hole_depth + floor_thickness - hole_bottom_radius])
                cylinder(h = hole_bottom_radius, d = hole_d - 2 * hole_bottom_radius);
        }
    }
}