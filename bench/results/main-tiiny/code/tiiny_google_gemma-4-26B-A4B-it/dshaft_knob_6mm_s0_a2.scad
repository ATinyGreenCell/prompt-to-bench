// --- Dimensions (mm) ---
knob_diameter = 30.0;          // Total diameter of the knob
knob_height = 15.0;            // Total height of the knob
d_shaft_circle_dia = 6.2;      // Diameter of the circular part of the D-bore
d_shaft_flat_dist = 4.7;       // Distance from the flat to the opposite side of the D-bore
d_bore_depth = 12.0;           // Depth of the D-shaped bore
grip_groove_dia = 2.0;         // Diameter of the half-cylinder grooves
grip_groove_count = 18;        // Number of vertical grooves
pointer_width = 1.5;           // Width of the pointer groove
pointer_depth = 1.0;           // Depth of the pointer groove

// --- Constants ---
$fn = 64;

// --- Geometry Calculations ---
// The user specifies: "6.2 mm diameter circle with one side cut flat, 
// and the distance from the flat to the opposite side is 4.7 mm."
// This means the "height" of the D-shape is 4.7mm.
// Since the radius is 3.1mm, the flat face is located at:
// distance_from_center = 4.7 - 3.1 = 1.6mm.
// To make the D-shape centered on the origin, the flat face must be at y = -1.6.
shaft_radius = d_shaft_circle_dia / 2;
dist_center_to_flat = d_shaft_flat_dist - shaft_radius;

// --- Main Model ---
difference() {
    // 1. Main Body
    cylinder(h = knob_height, d = knob_diameter, center = false);

    // 2. D-shaped Blind Bore
    // We subtract a cylinder and then subtract a block to create the flat.
    // The block must be positioned to cut the side of the cylinder.
    translate([0, 0, -0.01])
    difference() {
        cylinder(h = d_bore_depth + 0.01, d = d_shaft_circle_dia);
        
        // The flat face is at y = -dist_center_to_flat.
        // We subtract a block that covers the area from the edge of the cylinder 
        // up to the flat face.
        translate([-shaft_radius - 1, -shaft_radius - 1, -0.01])
        cube([shaft_radius * 2 + 2, shaft_radius - dist_center_to_flat, d_bore_depth + 0.02]);
    }

    // 3. Grip Grooves (Vertical half-cylinders)
    // "Around the outside, cut 18 evenly spaced vertical grip grooves"
    // These are centered on the outer surface.
    for (i = [0 : grip_groove_count - 1]) {
        rotate([0, 0, i * (360 / grip_groove_count)])
        translate([knob_diameter / 2, 0, -0.01])
        cylinder(h = knob_height + 0.02, d = grip_groove_dia);
    }

    // 4. Pointer Groove (Top face)
    // "On the top face, cut a pointer groove 1.5 mm wide and 1 mm deep 
    // that runs from the centre to the outer edge, on the same side as the flat of the D."
    // The flat is at y = -1.6. To be on the same side, we align the groove along the Y axis.
    // We use a cube to cut from the center (0,0) to the edge (0, -15).
    translate([-pointer_width / 2, -knob_diameter / 2, knob_height - pointer_depth])
    cube([pointer_width, knob_diameter, pointer_depth + 0.01]);
}