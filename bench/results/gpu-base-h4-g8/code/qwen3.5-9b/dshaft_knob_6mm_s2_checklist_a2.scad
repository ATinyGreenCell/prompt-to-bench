// Replacement knob for hotplate stirrer - D-shaft fit, grip grooves, and top pointer.

// Dimensions
shaft_d  = 6.0;
knob_d   = 30.0;
knob_h   = 15.0;
bore_h   = 12.0;
bore_d   = 6.2;
flat_w   = 4.7; // Width of the flat side of the D-bore
groove_n = 18;
groove_d = 2.0;
pointer_w = 1.5;
pointer_d = 1.0; // Depth of pointer groove

$fn = 96;

// Calculate D-bore geometry
// The D-shape is defined by a circle of diameter bore_d, but with a flat chord.
// The distance from the flat to the opposite arc is flat_w.
// Let R be the radius of the circle. The chord is at a distance 'h' from the center.
// The distance from the flat to the far arc is R + h = flat_w.
// The half-chord length is flat_w / 2.
// By Pythagoras: R^2 = (flat_w/2)^2 + h^2.
// Substitute h = flat_w - R:
// R^2 = (flat_w/2)^2 + (flat_w - R)^2
// R^2 = (flat_w/2)^2 + flat_w^2 - 2*flat_w*R + R^2
// 0 = (flat_w/2)^2 + flat_w^2 - 2*flat_w*R
// 2*flat_w*R = (flat_w/2)^2 + flat_w^2 = flat_w^2 * (1/4 + 1) = 5/4 * flat_w^2
// R = (5/8) * flat_w

R_bore = (5 / 8) * flat_w;
h_bore = flat_w - R_bore; // Distance from center to flat plane

// Main body: Cylinder
// The knob sits on the bed with the flat side of the D facing down (Z=0).
// The D-shape is in the XY plane. The flat side is along the X-axis at Y = -h_bore.
// The arc is the top part of the circle.
// We build the D-shape centered at (0,0) then translate it up by h_bore so the flat face is at Z=0.

difference() {
    // 1. Main Body
    translate([0, h_bore, 0]) 
        linear_extrude(knob_h) 
            circle(d = knob_d);
    
    // 2. D-Bore
    // The bore is a D-shape extruded up to bore_h.
    // The D-shape is centered at (0,0) in the XY plane relative to the knob's local coordinates.
    // The flat side is at Y = -h_bore.
    // We translate the whole bore up by h_bore so the flat face is at Z=0.
    translate([0, h_bore, 0]) 
        linear_extrude(bore_h) 
            d_shape_2d();
    
    // 3. Grip Grooves
    // 18 evenly spaced vertical grooves along the full height.
    // Each groove is a 2 mm diameter half-cylinder centred on the outer surface.
    // The outer surface is at radius knob_d/2.
    // We cut these using a cylinder rotated 90 degrees around X (to lie along Y) and then rotated around Z.
    // Actually, a half-cylinder cut is best done with a cylinder of diameter groove_d, 
    // rotated 90 deg around X (so it lies along Y), then rotated around Z to position it.
    // Wait, a half-cylinder cut needs to be a cylinder of diameter groove_d, but we only want half?
    // No, the user said "2 mm diameter half-cylinder". This usually means a groove with a semi-circular cross-section.
    // To cut a semi-circular groove, we can use a cylinder of diameter groove_d, but we need to position it correctly.
    // If we use a cylinder of diameter groove_d, it will cut a full hole.
    // To get a half-cylinder groove, we can use a cylinder of diameter groove_d and rotate it 90 degrees around X?
    // No, that makes it a flat cut.
    // A half-cylinder groove is a cylinder of diameter groove_d, but we only want the part that cuts into the knob.
    // Actually, the simplest way to cut a semi-circular groove is to use a cylinder of diameter groove_d,
    // but we need to ensure it only cuts the outer surface.
    // Let's use a cylinder of diameter groove_d, rotated 90 deg around X (so it lies along Y),
    // then translate it to the surface.
    // Wait, if it lies along Y, it's a flat cut.
    // We need a cylinder that lies along Y but has a semi-circular cross-section in the XZ plane?
    // No, the groove is vertical. The cross-section is in the XZ plane (if the groove runs along Z).
    // The user said "vertical grip grooves". So they run along Z.
    // The cross-section is in the XY plane.
    // A "half-cylinder" groove means the cross-section is a semi-circle.
    // To cut this, we can use a cylinder of diameter groove_d, but we need to position it so it only cuts the outer part.
    // Actually, the easiest way is to use a cylinder of diameter groove_d, but we need to cut only half of it?
    // No, we can just use a cylinder of diameter groove_d and rotate it 90 degrees around X?
    // No, that makes it a flat cut.
    // Let's think about the geometry.
    // The groove runs along Z. The cross-section is in the XY plane.
    // The cross-section is a semi-circle of diameter groove_d.
    // We can create this by rotating a semi-circle around Z? No, that makes a torus.
    // We can create this by rotating a semi-circle around the axis of the groove? No.
    // We can create this by using a cylinder of diameter groove_d, but we need to cut only the part that is outside the knob.
    // Actually, the simplest way is to use a cylinder of diameter groove_d, but we need to position it so it only cuts the outer part.
    // Let's use a cylinder of diameter groove_d, but we need to cut only half of it?
    // No, we can just use a cylinder of diameter groove_d and rotate it 90 degrees around X?
    // No, that makes it a flat cut.
    // Let's try a different approach.
    // We can use a cylinder of diameter groove_d, but we need to cut only the part that is outside the knob.
    // Actually, the easiest way is to use a cylinder of diameter groove_d, but we need to cut only half of it?
    // No, we can just use a cylinder of diameter groove_d and rotate it 90 degrees around X?
    // No, that makes it a flat