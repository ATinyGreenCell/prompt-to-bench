// Design a 10-well comb for casting agarose gels, printed lying flat.
// The whole comb is a flat plate 1.5 mm thick (Z) lying on the bed.
// Seen from above, it has a straight spine (back bar) 70 mm long (X) and 12 mm wide (Y), 
// and 10 rectangular teeth that hang from one long edge of the spine in the -Y direction.
// Each tooth is 5.0 mm wide (X) and 12 mm long (Y). The gaps between neighbouring teeth are 1.5 mm, 
// and the row of teeth is centred on the spine in X.

// Dimensions measured with calipers
length_spine = 70.0; // mm
width_spine = 12.0;  // mm
thickness_plate = 1.5; // mm
num_teeth = 10;       // teeth along Y axis (from spine edge)
teeth_width = 5.0;    // mm width of each tooth in X direction
teeth_length = 12.0;  // mm length of each tooth in Y direction
gap_between_teeth = 1.5; // mm gap between teeth

// Create the main plate body (spine + teeth)
plate_body = union(
    // Spine: A flat rectangle from spine edge to end, extruded along Z
    cube([length_spine, width_spine, thickness_plate]),
    
    // Teeth: 10 rectangular prisms hanging down in -Y direction
    for (i = 0; i < num_teeth; i++) {
        translate([0.0, -(i + 1) * gap_between_teeth, 0.0]) * cube([teeth_width, teeth_length, thickness_plate]);
    }
);

// Create the mounting base on XY plane (Z=0), centered at origin
base = cube([length_spine + 2.0, width_spine + 2.0, thickness_plate], center = [0.0, 0.0, 0.0]);

// Final assembly: Combine plate body and mounting base
final_comb = union(plate_body, base);

// Print orientation: Lying flat on XY plane (Z=0), building up +Z
print_orientation = translate([0.0, 0.0, thickness_plate / 2.0]) * final_comb; // Center in X/Y, extend Z upwards