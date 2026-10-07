// Dimensions of the PCR tube rack (mm)
$fn = 64;
module("PCR_Rack") {
    // External dimensions
    var X = 127.76;   // Length
    var Y = 85.48;    // Width
    var Z = 20;       // Height

    // Hole grid parameters (96 tubes, ANSI/SLAS)
    var hole_diameter = 6.2;
    var hole_spacing = 9.0;      // Centre-to-centre spacing
    var tube_height = Z - 1.5;   // Subtract ~1mm for clearance

    // Chamfer dimensions (A1 corner chamfer)
    var chamfer_length = 5;

    // Calculate positions of hole centers relative to origin (centred in X/Y)
    var cols = 12;
    var rows = 8;
    var x_offset = (X - (cols * hole_spacing)) / 2 + hole_diameter/2;   // Half-length offset
    var y_offset = (Y - (rows * hole_spacing)) / 2 + hole_diameter/2;   // Half-width offset

    // Create the base block
    module("BaseBlock") {
        cube([X, Y, Z]);
    }

    // Create chamfer at A1 corner (bottom-left)
    translate([-x_offset - hole_diameter/2, -y_offset - hole_diameter/2, 0])
    rotate([90, 0, 0]) // Rotate to align chamfer plane with XZ
        difference() {
            cube([chamfer_length + 1.5, Z + 1.5, chamfer_length + 1.5]);
            for (var i = 0; i < 4; i++) {
                rotate([90 * i, 0, 0])
                    cube([chamfer_length + 2, Z + 1.5, hole_diameter + 1]);
            }
        }

    // Create vertical holes
    for (var col = 0; col < cols; col++) {
        var x_pos = -x_offset + col * hole_spacing;
        for (var row = 0; row < rows; row++) {
            var y_pos = -y_offset + row * hole_spacing;

            // Translate to correct position
            translate([x_pos, y_pos, 0])
                rotate([90, 0, 0]) // Align hole axis with Z-axis

                // Create vertical cylinder (hollow tube)
                difference() {
                    cylinder(h=Z+1.5, $fn=$fn, diameter=hole_diameter+2);
                    cube([hole_diameter + 1, hole_diameter + 1, tube_height]);
                };
        }
    }

    // Combine all parts
    BaseBlock();
}