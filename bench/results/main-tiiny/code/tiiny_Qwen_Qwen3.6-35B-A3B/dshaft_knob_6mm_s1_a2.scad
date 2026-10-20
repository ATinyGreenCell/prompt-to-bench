// Replacement knob for hotplate stirrer
// D-shaft: 6mm nominal, bore is 6.2mm diameter with flat cut
// Flat-to-opposite-side distance: 4.7mm
// Knob OD: 30mm, Height: 15mm
// Bore depth: 12mm
// Grip grooves: 18, 2mm diameter half-cylinders on outer surface
// Pointer groove: 1.5mm wide, 1mm deep, on the flat side

// --- Dimensions ---
knob_od = 30;          // Outer diameter of knob
knob_h = 15;           // Total height of knob
bore_od = 6.2;         // Diameter of D-bore
bore_flat_dist = 4.7;  // Distance from flat to opposite side of bore
bore_depth = 12;       // Depth of D-bore from bottom face

grip_count = 18;         // Number of grip grooves
grip_d = 2;              // Diameter of grip groove cutter
grip_depth = 1;          // Depth of grip groove into knob (half of diameter for half-cylinder on surface)

pointer_width = 1.5;     // Width of pointer groove
pointer_depth = 1;       // Depth of pointer groove

// --- Calculated Values ---
// Center of the D-bore circle
// The flat is on the right side (positive X) based on "same side as the flat" for the pointer.
// Let's define the flat at angle 0 (positive X).
// The circle center is offset from the knob center (0,0) towards the flat.
// Distance from center of circle to flat edge = bore_od/2 = 3.1
// Distance from flat edge to opposite side = 4.7
// Total width = 3.1 + 4.7 = 7.8. But bore_od is 6.2, so radius is 3.1.
// Wait, if the bore is a circle of 6.2, the radius is 3.1.
// The distance from the flat to the opposite side is 4.7.
// This implies the flat is not a tangent to the circle, or the "flat" cuts into the circle.
// Let's re-read: "a 6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
// If it were a full circle, the diameter would be the max width.
// If we cut a flat side, the width from flat to opposite arc is 4.7.
// The original circle diameter is 6.2.
// So the flat cuts off a segment of the circle.
// Distance from circle center to flat = (Diameter - Width_from_flat_to_opposite) / 2 ? No.
// Let's place the circle center at (0,0) for calculation first.
// Opposite side is at x = -3.1.
// Flat is at x = 4.7 - 3.1 = 1.6? No.
// Let's assume the knob center is (0,0).
// The D-bore is centered on the knob axis? Usually yes.
// If the bore is centered on the knob axis, the circle is at (0,0).
// The flat is cut into this circle.
// The distance from the flat to the opposite side of the circle is 4.7.
// The opposite side of the circle is at x = -3.1 (if flat is on +X side).
// So the flat is at x = 4.7 - 3.1 = 1.6? No, the distance is measured along the axis.
// If the flat is at x = f, and the opposite side is at x = -3.1.
// Distance = f - (-3.1) = f + 3.1 = 4.7 => f = 1.6.
// So the flat is at x = 1.6.
// The circle radius is 3.1.
// The flat cuts the circle at x = 1.6.
// This creates a D-shape.

// Let's verify the shaft fit.
// A 6mm D-shaft typically has a flat width of 6mm? Or diameter 6mm?
// "6 mm D-shaft" usually means the shaft has a diameter of 6mm and a flat.
// If the shaft is 6mm diameter, the flat is usually tangent to the 6mm circle?
// Or is the shaft 6mm across the flats?
// Standard hotplate stirrers often use a 6mm shaft where the "6mm" refers to the diameter of the round part, and the flat is cut into it.
// If the shaft is 6mm diameter, its flat is often at a specific distance.
// However, the user specified the bore dimensions explicitly: 6.2mm circle, flat cut, 4.7mm width.
// We will follow the user's bore dimensions exactly.

// Bore center is at (0,0) in XY.
// Flat is at x = 1.6.
// The pointer groove is on the same side as the flat.
// So the pointer is on the +X side.

// Grip grooves:
// 18 evenly spaced vertical grooves on the outside.
// They are half-cylinders centered on the outer surface.
// This means the cutter is a cylinder of diameter 2mm, and we only keep the part inside the knob?
// "cut 18 evenly spaced vertical grip grooves... each groove is a 2 mm diameter half-cylinder centred on the outer surface."
// This implies the groove profile is a semi-circle of radius 1mm.
// We can model this by subtracting a cylinder of diameter 2mm from the outside, but only the part that protrudes?
// Actually, "half-cylinder centred on the outer surface" suggests the groove is a semi-circular notch.
// To cut this, we can use a cylinder of diameter 2mm, but we need to ensure it doesn't cut into the bore or other features excessively.
// Since it's a "half-cylinder", it implies the groove depth is 1mm (radius).
// We can subtract a cylinder of diameter 2mm, centered at the outer surface, and it will remove the inside half (the groove) and the outside half (which is already empty space).
// So, subtracting a cylinder of diameter 2mm, centered at the outer surface, works perfectly.

// Coordinates for grip grooves:
// Radius of knob = 15.
// Grooves are at angles theta_i.
// We need to decide the starting angle. Let's start at angle 0 (positive X).

// Pointer groove:
// 1.5mm wide, 1mm deep.
// Runs from center to outer edge.
// On the same side as the flat.
// The flat is at x = 1.6. The pointer is on the +X side.
// So the pointer is along the +X axis.
// We can model this as a rectangular slot from x=0 to x=15, width 1.5, depth 1.
// But it must be "cut" from the top face.
// The top face is at z = 15.
// The groove goes down 1mm, so to z = 14.
// Width 1.5mm, so x from -0.75 to 0.75.
// Length from center (0) to edge (15).

// --- Construction ---

// 1. Main Knob Body
// Cylinder, OD 30, Height 15, centered at (0,0,0) to (0,0,15)
knob_body = cylinder(r = knob_od/2, h = knob_h, center = false);

// 2. D-Bore
// We need to cut a D-shape from the bottom (z=0) up to z=12.
// The D-shape is a circle of diameter 6.2, with a flat at x=1.6.
// To cut this, we can subtract a cylinder of diameter 6.2, but we need to cut off the part x > 1.6.
// Actually, it's easier to subtract a cylinder of diameter 6.2, and then subtract a box to create the flat?
// No, the "flat" is the cut. The remaining material is the D-shape.
// So we subtract the D-shape volume.
// The D-shape volume is the intersection of the cylinder (r=3.1) and the half-space x <= 1.6.
// Wait, if the flat is at x=1.6, and the circle is centered at 0, the part x > 1.6 is removed.
// So the bore is the part of the cylinder where x <= 1.6.
// To cut this out of the knob, we subtract this shape.
// Shape: Cylinder(r=3.1, h=12.01, center=false) intersected with box(x_min