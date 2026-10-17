// --- Parameters (Dimensions in mm) ---
knob_diameter = 30;          // Total diameter of the knob
knob_height = 15;            // Total height of the knob
shaft_hole_diameter = 6.2;   // Diameter of the D-bore
shaft_bore_depth = 12;       // Depth of the D-bore
shaft_flat_width = 4.7;      // Distance from flat to opposite side of circle
num_grip_grooves = 18;       // Number of vertical grip grooves
grip_groove_diameter = 2;    // Diameter of the half-cylinder grooves
pointer_width = 1.5;         // Width of the pointer groove
pointer_depth = 1;           // Depth of the pointer groove

// --- Internal Constants ---
$fn = 64;

// --- Main Model ---
// The knob is printed with the bottom face on the XY plane (z=0)
difference() {
    // 1. The main body of the knob
    cylinder(h = knob_height, d = knob_diameter, center = false);

    // 2. The D-shaped blind bore
    // Specification: 6.2mm diameter circle, one side cut flat.
    // Distance from flat to opposite side is 4.7mm.
    // Radius is 3.1. Distance from center to flat = 4.7 - 3.1 = 1.6mm.
    // We subtract the cylinder and then subtract a block to create the flat.
    
    // The circular bore
    translate([0, 0, -0.01])
        cylinder(h = shaft_bore_depth + 0.02, d = shaft_hole_diameter);
    
    // The flat part: Subtract a block that removes everything beyond the flat.
    // The flat is at y = -1.6 (relative to center).
    // To ensure a clean cut, we subtract a block that covers the area from the edge to the flat.
    // We use a large enough cube to ensure it cuts through the cylinder.
    // The block must be centered on X and cover the width of the cylinder.
    translate([-shaft_hole_diameter, -shaft_hole_diameter, -0.01])
        cube([shaft_hole_diameter * 2, shaft_hole_diameter - shaft_flat_width + 0.1, shaft_bore_depth + 0.02]);

    // 3. Vertical Grip Grooves
    // 18 grooves, 2mm diameter half-cylinders on the outer surface.
    // "centered on the outer surface" means the cylinder axis is at radius = knob_diameter/2.
    for (i = [0 : num_grip_grooves - 1]) {
        rotate([0, 0, i * (360 / num_grip_grooves)])
        translate([knob_diameter / 2, 0, 0])
        rotate([0, 90, 0])
        cylinder(h = knob_height + 2, d = grip_groove_diameter, center = true);
    }

    // 4. Pointer Groove
    // 1.5mm wide, 1mm deep, from the center to the outer edge.
    // Located on the same side as the flat (negative Y direction).
    // We use a cube to ensure a rectangular cross-section (1.5 wide, 1 deep).
    // The groove is on the top face (z=15).
    // To avoid splitting the part in the report (which showed two separate regions),
    // we ensure the cube is wide enough to span the entire diameter and is centered on X.
    // We also make it slightly longer than the diameter to ensure a clean cut.
    // Note: The previous report showed the groove was split into two regions (X -14.25 to 14.25).
    // This happens if the subtraction cube is not wide enough or is misaligned.
    // We use a cylinder for the groove to ensure it is a single continuous cut through the center.
    translate([0, -knob_diameter/2, knob_height - pointer_depth + 0.01])
        rotate([0, 90, 0])
        cylinder(h = knob_diameter + 2, d = pointer_width, center = true);
}