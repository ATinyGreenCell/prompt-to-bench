// Dimensions (measured in mm)
knob_diameter = 30;           // Total diameter of the knob
knob_height = 15;             // Total height of the knob
bore_diameter = 6.2;          // Diameter of the D-shaped bore
bore_depth = 12;              // Depth of the D-shaped bore
d_flat_to_edge = 4.7;         // Distance from the flat to the opposite side of the D-bore
num_grooves = 18;             // Number of vertical grip grooves
groove_diameter = 2;          // Diameter of the grip grooves
pointer_width = 1.5;          // Width of the pointer groove
pointer_depth = 1;            // Depth of the pointer groove

// Smoothness for curved surfaces
fn_val = 64;

// Calculated values
bore_radius = bore_diameter / 2;
// The distance from the center to the flat side of the D-bore
dist_center_to_flat = d_flat_to_edge - bore_radius;

// The part is printed with the bottom face on the XY plane (z=0)
difference() {
    // 1. Main Knob Body
    cylinder(d=knob_diameter, h=knob_height, $fn=fn_val);

    // 2. D-shaped Blind Bore
    // We create the D-shape by subtracting a segment from a cylinder,
    // and then subtract that D-shape from the main knob.
    difference() {
        // The base cylinder for the bore
        cylinder(d=bore_diameter, h=bore_depth + 0.1, $fn=fn_val);
        
        // The cube that cuts the side of the cylinder to create the "D" shape
        // We translate it to start at the flat's position
        translate([dist_center_to_flat, -bore_diameter, -0.1])
            cube([bore_diameter, bore_diameter * 2, bore_depth + 0.3], $fn=fn_val);
    }

    // 3. Vertical Grip Grooves
    // 18 evenly spaced half-cylinders centered on the outer surface
    for (i = [0 : num_grooves - 1]) {
        rotate([0, 0, i * (360 / num_grooves)])
        translate([knob_diameter / 2, 0, -0.1])
        cylinder(d=groove_diameter, h=knob_height + 0.2, $fn=fn_val);
    }

    // 4. Pointer Groove
    // A slot on the top face running from the center to the outer edge,
    // aligned with the axis perpendicular to the D-bore's flat.
    translate([0, -pointer_width / 2, knob_height - pointer_depth])
        cube([knob_diameter / 2 + 0.1, pointer_width, pointer_depth + 0.1], $fn=fn_val);
}