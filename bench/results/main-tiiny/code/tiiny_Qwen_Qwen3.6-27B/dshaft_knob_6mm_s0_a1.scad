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
// The flat is offset from center by: bore_radius - (4.7 - bore_radius) = 2*bore_radius - 4.7
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

// Subtract D-shaped blind bore
// The bore goes from z=0 to z=12
// D-shape: cylinder with flat on +Y side
// We subtract a cylinder, then add back the material that was removed by the flat cut?
// No, difference() subtracts the union of all children.
// So we define the D-shape as: Cylinder MINUS RectangularBlock
// But in difference(A, B, C), we subtract B and C from A.
// We want to subtract the D-shape from the knob.
// D-shape = Cylinder - Block.
// So we want to subtract (Cylinder - Block) from Knob.
// This is equivalent to: Subtract Cylinder, then Add Block back.
// OpenSCAD difference() only subtracts. It doesn't add.
// So we must define the D-shape as a single solid to subtract.
// A D-shape is a cylinder with a flat side.
// We can model the D-shape as a cylinder, and then use a difference to cut the flat.
// But we are already inside a difference() for the main knob.
// So: difference(Knob, DShape).
// DShape = difference(Cylinder, Block).
// We can nest this: difference(Knob, difference(Cylinder, Block)) is not valid syntax directly.
// Instead, we can use: difference(Knob, Cylinder) then union(Block) is not possible in one go.
// Correct approach: Define the D-shape as a module or use a single difference with the cylinder and the block as separate subtrahends?
// No, if we subtract the cylinder and subtract the block, we get a hole that is Cylinder + Block, which is wrong.
// We want to subtract the Cylinder, but NOT subtract the Block part.
// So we subtract the Cylinder, and then we ADD the Block back.
// Since difference() only subtracts, we can't add.
// Alternative: Model the D-shape as a polygon and extrude it.
// Or: Use a difference to create the D-shape solid, then subtract that solid from the knob.
// Let's create the D-shape solid first.

// D-shape solid: Cylinder with a flat cut on the +Y side.
// The flat is at y = flat_offset.
// The block to remove is from y = flat_offset to y = bore_radius + epsilon.
// Width of block: bore_diameter + epsilon (to cover the whole width of the cylinder at that y).
// Actually, the block should be wide enough to cut the entire chord.
// The cylinder is centered at 0,0.
// The flat is at y = flat_offset.
// We remove the part of the cylinder where y > flat_offset.
// So the block is: x from -bore_radius to bore_radius, y from flat_offset to bore_radius + epsilon, z from -epsilon to bore_depth + epsilon.

// Let's define the D-shape bore as a module for clarity, but we can't use modules in the final code block if we want it self-contained without includes?
// Modules are built-in. Yes.

module d_shaped_bore() {
    difference() {
        cylinder(h = bore_depth + 0.1, r = bore_radius, center = false);
        // Cut the flat
        translate([-bore_radius - 0.1, flat_offset, -0.05])
            cube([bore_diameter + 0.2, bore_radius - flat_offset + 0.1, bore_depth + 0.2]);
    }
}

// Now subtract the D-shaped bore from the knob
difference() {
    // Main body
    cylinder(h = knob_height, r = knob_radius, center = false);
    
    // D-shaped bore
    d_shaped_bore();
    
    // 18 evenly spaced vertical grip grooves
    for (i = [0 : num_grooves - 1]) {
        angle = i * 360 / num_grooves;
        translate([
            knob_radius * cos(angle),
            knob_radius * sin(angle),
            0
        ])
        rotate([0, 0, -angle])
        // Half-cylinder groove
        // Centered on the outer surface, so the center of the cylinder is at the surface.
        // We want the groove to cut into the knob.
        // The half-cylinder should be oriented such that the curved part is inside the knob.
        // So we take a cylinder and cut away the half that is outside.
        difference() {
            cylinder(h = knob_height + 0.1, r = groove_radius, center = false);
            // Cut away the half that is outside (positive X direction in local coords)
            translate([0, -0.05, -0.05])
                cube([groove_radius + 0.1, groove_diameter + 0.1, knob_height + 0.2]);
        }
    }
    
    // Pointer groove on top face
    // 1.5 mm wide, 1 mm deep, from center to outer edge
    // On the same side as the flat of the D (+Y direction)
    translate([0, knob_radius / 2, knob_height - pointer_depth])
        cube([pointer_width, knob_radius, pointer_depth + 0.1], center = true);
}