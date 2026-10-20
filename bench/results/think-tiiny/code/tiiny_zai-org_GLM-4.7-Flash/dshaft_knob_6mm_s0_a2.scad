// Knob Dimensions
knob_diameter = 30;
knob_height = 15;
shaft_diameter = 6.2;
shaft_flat_width = 4.7;
shaft_depth = 12;
groove_diameter = 2;
groove_count = 18;
pointer_width = 1.5;
pointer_depth = 1;
$fn = 64;

difference() {
    // Main Body
    cylinder(d = knob_diameter, h = knob_height, center = false, $fn = $fn);

    // D-Bore
    // Shape: Cylinder + Box to create the flat side
    // The flat is on the same side as the pointer groove (Right side, positive X)
    translate([shaft_flat_width / 2, 0, 0]) {
        cylinder(d = shaft_diameter, h = shaft_depth, $fn = $fn);
        cube([shaft_flat_width, shaft_diameter, shaft_depth], center = true);
    }

    // Grip Grooves
    for (i = [0 : groove_count - 1]) {
        rotate([0, 0, i * (360 / groove_count)]) {
            // Half cylinder centered on outer surface
            // Surface is at 15. Groove radius is 1. Center of groove is 14.
            // We place a full cylinder at 15, then cut it in half.
            translate([15, 0, 0]) {
                intersection() {
                    cylinder(d = groove_diameter, h = knob_height, $fn = $fn);
                    cube([1, groove_diameter, knob_height], center = true);
                }
            }
        }
    }

    // Pointer Groove
    // 1.5 wide, 1 deep, 15 tall. Center to edge. Same side as D-bore (Right).
    translate([0, 0, 0]) {
        cube([pointer_width, pointer_depth, knob_height], center = false);
    }
}