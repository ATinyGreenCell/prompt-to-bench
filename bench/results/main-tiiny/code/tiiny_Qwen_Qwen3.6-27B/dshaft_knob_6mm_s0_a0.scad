// Replacement knob for hotplate stirrer
// Dimensions measured with calipers

// Main body dimensions
knob_diameter = 30;
knob_radius = knob_diameter / 2;
knob_height = 15;

// D-shaft bore dimensions
bore_diameter = 6.2;
bore_radius = bore_diameter / 2;
bore_depth = 12;
// Distance from flat to opposite side of circle is 4.7 mm
// So the flat is offset from center by: bore_radius - (4.7 - bore_radius) = 2*bore_radius - 4.7
flat_offset = bore_radius - (4.7 - bore_radius);

// Grip groove dimensions
num_grooves = 18;
groove_diameter = 2;
groove_radius = groove_diameter / 2;

// Pointer groove dimensions
pointer_width = 1.5;
pointer_depth = 1;

// Set resolution for smooth curves
$fn = 64;

// Main knob body
translate([0, 0, 0])
    cylinder(h = knob_height, r = knob_radius, center = false);

// D-shaped blind bore (cut from bottom, going up 12 mm)
// The bore is a cylinder with a flat side
// The flat is on the side where the pointer groove will be (let's say +Y direction)
difference() {
    // This is handled by subtracting from the main body below
}

// We need to subtract the D-shaped bore from the main body
// The D-shape: a cylinder of diameter 6.2 mm, with a flat cut on one side
// The flat is at distance flat_offset from center, towards +Y
// The distance from flat to opposite side is 4.7 mm

// Create the D-shaped bore as a solid to subtract
// It's a cylinder minus a rectangular block that cuts the flat
translate([0, 0, 0])
difference() {
    // Main body is already created above, we need to subtract the bore
    // Let's restructure: create main body, then subtract bore, grooves, and pointer
}

// Restructured approach: build main body, then subtract all features

// Main body
translate([0, 0, 0])
    cylinder(h = knob_height, r = knob_radius, center = false);

// Subtract D-shaped blind bore
// The bore goes from z=0 to z=12
// D-shape: cylinder with flat on +Y side
translate([0, 0, 0])
difference() {
    // Bore cylinder
    cylinder(h = bore_depth + 0.1, r = bore_radius, center = false);
    
    // Cut the flat: a rectangular block that removes material from the +Y side
    // The flat is at y = flat_offset from center
    // We need to remove everything from y = flat_offset to y = bore_radius + extra
    translate([0, flat_offset, -0.05])
        cube([bore_diameter + 0.2, bore_radius - flat_offset + 0.1, bore_depth + 0.2], center = false);
}

// Subtract 18 evenly spaced vertical grip grooves
// Each groove is a half-cylinder of 2 mm diameter, centered on the outer surface
// They run the full height of the knob
for (i = [0 : num_grooves - 1]) {
    angle = i * 360 / num_grooves;
    // Position the groove on the outer surface
    // The groove center is at radius = knob_radius - groove_radius/2? No, centered on outer surface means
    // the center of the half-cylinder is on the surface, so half is inside, half is outside
    // For a half-cylinder groove, we want the flat side facing outward or inward?
    // "centred on the outer surface" - the center of the circle is on the surface
    // So we translate to the surface, then rotate to face inward
    
    translate([
        knob_radius * cos(angle),
        knob_radius * sin(angle),
        0
    ])
    rotate([0, 0, -angle])
    translate([0, 0, 0])
    difference() {
        // Half-cylinder pointing inward (toward center)
        // A full cylinder centered at origin, then we keep only the half toward -X (inward)
        // Actually, let's think: the groove is on the outside, so it cuts into the knob
        // The half-cylinder should have its flat face on the outside, curved part inside
        // Or curved part on outside? "grip grooves" - typically the curved part is the groove
        // Let's make the curved part face inward (into the knob material)
        
        // Cylinder for the groove
        cylinder(h = knob_height + 0.1, r = groove_radius, center = false);
        
        // Cut away the half that's outside the knob (keep the half that's inside)
        // The half toward +X is outside, half toward -X is inside
        translate([0, -0.05, -0.05])
            cube([groove_radius + 0.1, groove_diameter + 0.1, knob_height + 0.2], center = false);
    }
}

// Subtract pointer groove on top face
// 1.5 mm wide, 1 mm deep, from center to outer edge
// On the same side as the flat of the D (which is +Y direction)
translate([0, 0, knob_height - pointer_depth])
difference() {
    // Rectangular slot from center to edge
    // Width 1.5 mm, length from center (y=0) to edge (y=knob_radius)
    // Depth is already handled by z-position
    translate([0, knob_radius/2, 0])
        cube([pointer_width, knob_radius, pointer_depth + 0.1], center = true);
    
    // Round the ends? The user didn't specify, so keep it rectangular
    // But let's make sure it doesn't go beyond the knob
    // The cube extends from y=0 to y=knob_radius, which is correct
}