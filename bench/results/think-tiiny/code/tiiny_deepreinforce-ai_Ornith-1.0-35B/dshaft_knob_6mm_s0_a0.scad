// Replacement knob for hotplate stirrer
// Dimensions in millimetres

knob_dia = 30;              // Outer diameter
knob_h = 15;                // Total height
shaft_dia = 6;              // D-shaft diameter (reference)
bore_dia = 6.2;             // Bore diameter
bore_depth = 12;           // Bore depth
bore_flat_to_opposite = 4.7; // Distance from flat to opposite side
groove_count = 18;           // Number of grip grooves
groove_dia = 2;             // Groove half-cylinder diameter
pointer_width = 1.5;        // Pointer groove width
pointer_depth = 1;         // Pointer groove depth
$fn = 64;

bore_r = bore_dia / 2;
flat_x = -bore_r + bore_flat_to_opposite; // Position of the flat cut

difference() {
    // Main knob cylinder
    cylinder(h=knob_h + 0.1, d=knob_dia, center=false);

    // D-shaped blind bore
    cylinder(h=bore_depth + 0.1, d=bore_dia, center=false);
    // Flat cut for D-shape
    translate([flat_x, 0, 0])
        cube([10, bore_dia + 0.1, bore_depth + 0.1]);

    // 18 vertical grip grooves
    for (a = [0 : 360/groove_count : 360 - 360/groove_count]) {
        translate([knob_dia/2 * cos(a), knob_dia/2 * sin(a), 0])
            cylinder(h=knob_h + 0.1, d=groove_dia, center=false);
    }

    // Pointer groove on top face
    translate([7.55, 0, knob_h])
        cube([15.1, pointer_width, pointer_depth]);
}