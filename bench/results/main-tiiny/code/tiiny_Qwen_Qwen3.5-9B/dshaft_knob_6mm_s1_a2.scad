$fn = 128;

// --- Dimensions ---
// Shaft diameter (for reference)
$shaft_diameter = 6;

// Knob overall dimensions
$knob_diameter = 30;
$knob_height = 15;

// D-shaft bore dimensions
// Total depth of bore
$bore_depth = 12;
// Diameter of the circular part of the bore
$bore_circle_diameter = 6.2;
// Distance from the flat side of the D to the opposite side (chord length)
$bore_flat_to_edge = 4.7;

// Grip grooves dimensions
$groove_count = 18;
$groove_diameter = 2;

// Top pointer groove dimensions
$pointer_width = 1.5;
$pointer_depth = 1;
$pointer_radius = $pointer_width / 2;

// --- Variables for D-shape calculation ---
$bore_circle_radius = $bore_circle_diameter / 2;
// Distance from center of circle to the flat side
$bore_flat_offset = ($bore_circle_radius - ($bore_flat_to_edge / 2));

// --- Main Construction ---

module knob() {
    // 1. Create the main cylinder body
    difference() {
        // Base Cylinder
        cylinder(
            h = $knob_height,
            r = $knob_diameter / 2,
            center = true
        );

        // 2. Cut the D-shaped blind bore
        // Starts at Z=0 (bottom of part) and goes up to Z=12
        translate([0, 0, 0]) {
            difference() {
                // The full circular hole volume
                cylinder(
                    h = $bore_depth,
                    r = $bore_circle_radius,
                    center = true
                );

                // The flat side of the D-shape
                // This is a rectangular prism cut into the cylinder
                // Position: Y = bore_flat_offset
                translate([0, $bore_flat_offset, 0]) {
                    // Dimensions: Width (X) = bore diameter, Height (Z) = bore depth, Depth (Y) = bore diameter
                    // We extend slightly in Y to ensure a clean cut across the full width of the bore
                    cube([
                        $bore_circle_diameter, 
                        $bore_depth + 0.1, 
                        $bore_circle_diameter 
                    ]);
                }
            }
        }

        // 3. Cut the 18 vertical grip grooves
        // These are half-cylinders (semi-circular cross-section) centered on the outer surface
        for (i = [0 : $groove_count - 1]) {
            angle = (i / $groove_count) * 360;
            translate([0, 0, 0]) {
                rotate([0, 0, angle]) {
                    // We subtract a cylinder of diameter $groove_diameter
                    // This creates a semi-circular groove on the surface
                    cylinder(
                        h = $knob_height,
                        r = $groove_diameter / 2,
                        center = true
                    );
                }
            }
        }

        // 4. Cut the top pointer groove
        // Runs from center to edge, 1.5mm wide, 1mm deep
        // Located on the same side as the flat of the D (positive Y side relative to the D cut)
        // Position: Centered at X=0, Y = (Radius - Width/2)
        translate([
            0, 
            ($knob_diameter / 2) - $pointer_radius, 
            $knob_height - $pointer_depth
        ]) {
            cylinder(
                h = $pointer_depth,
                r = $pointer_radius,
                center = true
            );
        }
    }
}

// Render the knob centered on the origin, but shifted up so the bottom is at Z=0
translate([0, 0, $knob_height / 2]) {
    knob();
}