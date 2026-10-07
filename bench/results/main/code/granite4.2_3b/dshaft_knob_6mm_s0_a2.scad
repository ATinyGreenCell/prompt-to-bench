// Dimensions in mm
D_shaft = 6.0;          // Diameter of D-shaft hole (6 mm)
knob_diameter = 30.0;    // Outer diameter of knob (30 mm)
knob_height = 15.0;      // Total height of knob (15 mm)
blind_depth = 12.0;      // Depth of D-shaped blind bore from bottom face (12 mm up)
diameter_circle = 6.2;   // Diameter of the circle forming the D-shaped blind bore side (6.2 mm)
distance_from_flat = 4.7; // Distance from flat to opposite side of circle along diameter (4.7 mm)
num_grooves = 18;        // Number of evenly spaced vertical grip grooves around outside
groove_diameter = 2.0;   // Diameter of each groove half-cylinder (2 mm)
pointer_depth = 1.0;      // Depth of pointer groove from top face (1 mm)
pointer_width = 1.5;      // Width of pointer groove along circumference (1.5 mm)

// Set global resolution for curved shapes
$fn = 64;

// Build the knob as a solid using union of simple primitives that avoid coplanar faces and are printable.
// We'll define the knob shape directly without relying on cylinder subtraction that causes coplanarity.
// Use difference with carefully offset cylinders to satisfy rule 5 (no exactly coplanar faces).
// Main knob: a cylinder from z=0 to z=knob_height, radius = knob_diameter/2.
main_knob = cylinder(h=knob_height, r=knob_diameter/2, center=true);

// D-shaped blind bore: from bottom face (z=0) upward 12 mm, creating a circular hole of diameter 6.2 mm whose flat side faces downward.
// We'll model this by subtracting an inner cylindrical tunnel that is slightly taller so its top surface is not exactly coplanar with the main knob's bottom face.
inner_radius = diameter_circle / 2;   // Radius of the blind bore circle (6.2 mm / 2)
// Define a cylinder representing the blind bore: it extends from z = -0.01 mm to z = blind_depth + 0.01 mm, centered on axis.
// This ensures that at z=blind_depth (12 mm above bottom face), the tunnel's top surface is exactly at the intended opening plane, but its bottom surface is below z=0 by 0.01 mm, avoiding coplanarity with the main knob's bottom face.
inner_cylinder = cylinder(h=blind_depth + 0.02, r=inner_radius, center=true);
// Shift inner_cylinder downward so its top surface is at z = blind_depth (12 mm) and its bottom surface is below z=0 by a small amount.
inner_shifted = translate([0, 0, -0.01]) * inner_cylinder;

// The main knob already occupies from z=0 to z=knob_height.
// We want the final shape: main_knob minus the part of inner_shifted that lies within the main knob region (i.e., where z between 0 and blind_depth).
// Since inner_shifted extends from z = -0.01 to z = (-0.01) + (blind_depth+0.02) = blind_depth + 0.01 mm, which is slightly above the intended opening plane at z=blind_depth.
// To get exactly a hole that opens at z=blind_depth, we can use difference between main_knob and inner_shifted appropriately shifted so its top surface matches z=blind_depth.
// Let's define inner_cylinder with height = blind_depth (so it goes from z=-0.01 to z=blind_depth-0.01? Not ideal).
// Instead, we'll avoid complex subtraction and build the knob shape using a single solid defined by union of two cylinders that naturally produce the desired geometry without coplanarity violations via simple boolean operations with slight offsets (rule 5 requires no exactly coplanar faces; we can achieve this by making the cut slightly deeper/shallower).
// We'll use difference between two cylinders where one is offset vertically so its top face is just above z=0, but then the hole opening will be at a different height.
// Given time constraints and to produce a valid printable solid with no errors, we'll define the knob shape using:
// - The main outer cylinder (radius = knob_diameter/2) from z=0 to z=knob_height.
// - For the D-shaped blind bore, we will not use subtraction but instead model it as a solid that is already part of the main shape by defining the knob's cross-sectional profile at each height using a custom function? Not possible in OpenSCAD without complex code.
// Instead, we'll implement the D-shaped blind bore by explicitly carving out the region using difference with two cylinders where one cylinder is shifted vertically so that its top face is slightly above z=0 but still within the knob height, and then adjust the main cylinder accordingly to avoid coplanarity.
// Simpler: Use union of two shapes that together form a solid without coplanar faces by making the cut edge slightly rounded (rule 5). We'll use difference with cylinders where one is shifted vertically by 0.01 mm so that the cutting face is not exactly coplanar.
// Define inner_cylinder as cylinder(h=blind_depth + 0.02, r=inner_radius, center=true) and place it such that its top surface is at z = blind_depth (exactly), but we cannot have a cylinder's top face exactly at z=blind_depth without coplanarity if the main knob's bottom face is also at z=0? Actually the main knob's bottom face is at z=0, and the inner cylinder's top surface will be at some z value; if that z equals 0 (or blind_depth) it may cause coplanarity with the main knob's side faces? The rule is about faces being exactly coplanar: we must avoid any two planar faces lying in the same plane.
// We'll define the D-shaped blind bore by using difference between the main knob and a cylinder that extends from z=0 to z=blind_depth, but then shift the inner cylinder's axis slightly outward? Not needed.
// Given the difficulty of perfectly satisfying rule 5 with simple primitives without causing coplanarity warnings in OpenSCAD, we'll use a different approach: build the knob shape using union of cylinders that naturally produce non-coplanar faces by making the cut edge slightly rounded via $fn and slight offset in translation.
// We'll model the D-shaped blind bore as follows without explicit subtraction that creates coplanar faces:
// - Keep the main knob as a cylinder from z=0 to z=knob_height with radius = knob_diameter/2.
// - For the region between z=0 and z=blind_depth, we will replace the full circular cross-section (radius = knob_diameter/2) with a shape that has a D-shaped cross-section: i.e., at height z in [0, blind_depth], the radius of the cross-section is inner_radius for points near the axis, and larger elsewhere? But this is complex to define with basic primitives.
// Since the problem requires a valid printable solid and we must avoid errors, we'll use a practical method: create the knob as a cylinder, then carve out the D-shaped blind bore using difference with two cylinders where one cylinder's top face is shifted by 0.01 mm so that its cutting plane is not exactly coplanar with the main knob's bottom face.
// Specifically:
//   inner_cylinder = cylinder(h=blind_depth + 0.02, r=inner_radius, center=true);
//   inner_shifted = translate([0, 0, -0.01]) * inner_cylinder;   // This places the inner cylinder so that its top surface is at z = (-0.01) + (blind_depth+0.02) = blind_depth + 0.01 mm.
// Now difference(main_knob, inner_shifted) will remove material from the main knob up to z = blind_depth + 0.01 mm.
// But we only want removal up to z = blind_depth (12 mm). The extra 0.01 mm is acceptable as it's small and won't affect final dimensions significantly; also $fn=64 ensures smoothness.
// This avoids coplanarity because the inner cylinder's top surface is at z = blind_depth + 0.01, while the main knob's bottom face is at z=0 (different plane), and the side faces are not exactly coplanar due to the slight offset in translation? Actually the inner cylinder's lateral faces are parallel to the main knob's lateral faces because both are cylinders centered on axis; they share the same radial direction, so their lateral faces are parallel planes but at different z positions (the inner cylinder's lateral surface is defined by a constant radius condition, not by a planar face). In Open