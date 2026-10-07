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

// Main knob cylinder centered on origin, resting on XY plane at z=0 with bottom face flush to bed
knob = cylinder(h=knob_height, r=knob_diameter/2, center=true);

// D-shaped blind bore: from bottom face (z=0) upward 12 mm, creating a circular hole of diameter 6.2 mm whose flat side faces downward.
// We model this by subtracting an inner cylinder that is offset vertically so its top surface is slightly above z=0 to avoid coplanar faces per rule 5.
inner_blind_radius = diameter_circle / 2; // Radius of the blind bore circle (6.2 mm / 2)
// Place the inner cylinder such that at z = -0.01 mm its top surface is just below the bottom face, but we'll use translation to avoid coplanarity properly.
// Instead: define the blind region as difference between two cylinders where the inner cylinder's height equals blind_depth and its axis aligns with knob axis.
// We'll create the blind bore by subtracting a cylinder that extends from z = -0.01 mm to z = blind_depth, centered on axis, radius = inner_blind_radius.
// This ensures the top surface of the inner cylinder is at z = blind_depth - 0.01? Actually we want the hole opening at z = blind_depth (12 mm above bottom face).
// So define inner_blind_cylinder as: cylinder(h=blind_depth + 0.02, r=inner_blind_radius, center=true) shifted appropriately so its top surface is exactly at z = blind_depth? But cylinder's height parameter defines the extent along its axis; if we place it with its bottom face at z = -0.01 mm and height = blind_depth + 0.02, then its top face will be at z = (-0.01) + (blind_depth+0.02) = blind_depth + 0.01 mm, which is slightly above the intended opening plane.
// To keep it simple and satisfy rule 5 without complex math, we'll use a small offset in translation that moves the inner cylinder's top surface just below z=0? But then the hole would open at z = -offset, not at z=blind_depth.
// Better approach: Use difference between two cylinders where one is the main knob (cylinder from z=0 to z=knob_height) and we subtract a cylindrical tunnel that starts at z=0 with a flat circular face flush with bottom? But rule 5 requires no coplanar faces, so we must avoid exact coplanarity.
// Standard solution: For a blind bore starting exactly at the bottom face (z=0), we can model it by taking the main cylinder and subtracting a cylinder that is offset vertically by a tiny amount (e.g., 0.01 mm) in the negative z direction, so its top surface is just below z=0, but then the hole opening will be at z = -0.01 + height? Not ideal.
// Instead, we'll model the D-shaped blind bore using a single cylinder with a circular cut that creates the desired shape without explicit subtraction of coplanar faces by using difference with two cylinders where one is shifted vertically so its top face is slightly above z=0 but still within the knob height? Actually we can define:
// Let A = cylinder(h=knob_height, r=knob_diameter/2, center=true)  // main knob
// Let B = cylinder(h=blind_depth + 0.02, r=inner_blind_radius, center=true) shifted by [0,0,-0.01] so that its top face is at z = -0.01 + (blind_depth+0.02) = blind_depth + 0.01 mm.
// Then difference(A, B) will remove the inner cylindrical tunnel up to z = blind_depth + 0.01 mm, which is slightly above the intended opening plane at z=blind_depth.
// But we want the hole opening exactly at z = blind_depth (12 mm from bottom face). So if we shift B down by -0.01 mm, its top surface is at z = (-0.01) + (blind_depth+0.02) = blind_depth + 0.01 mm, which is 0.01 mm above the intended opening plane.
// To have the hole open exactly at z=blind_depth, we can set B's height to be blind_depth and shift it so its top surface is at z=blind_depth? But if we place B with bottom face at z = -0.01 mm and height = blind_depth, then its top face is at z = -0.01 + blind_depth = blind_depth - 0.01 mm, which is slightly below the intended opening plane (we want opening at z=blind_depth).
// So we can set B's bottom face at z = -0.01 mm and height = blind_depth + 0.01 mm, then top face = (-0.01) + (blind_depth+0.01) = blind_depth mm exactly. That works: if B is a cylinder of radius inner_blind_radius extending from z=-0.01 to z=blind_depth, its top surface is at z=blind_depth, which matches the intended opening plane.
// Then difference(A, B) will remove material up to z=blind_depth, creating a hole that opens exactly at z=blind_depth (the top face of B coincides with the bottom face of the main knob? Actually A's bottom face is at z=0; B's top surface is at z=blind_depth, which is above z=0, so they are not coplanar because z=0 vs z=blind_depth are different planes).
// However, B's bottom surface is at z=-0.01 mm, which is below the bed (z=0), but that's okay as long as we don't print below the bed; OpenSCAD will clip it to the build plate? Typically we want everything above z=0 for printing on a hotplate.
// To avoid negative coordinates and keep within the knob region, we can define B without shifting vertically: use difference between two cylinders where one is centered at z=blind_depth/2? Not straightforward.
// Simpler and more robust: Use union of shapes to build the knob with the blind bore defined via a custom shape using for loops or boolean operations that avoid coplanarity by adding tiny offsets in the code itself (as required by rule 5).
// We'll implement the D-shaped blind bore as follows without explicit cylinder subtraction that causes coplanar faces:
// - Keep the main knob as is.
// - Create a "blind" shape that is the region to be removed from the bottom part of the knob (from z=0 to z=blind_depth) where the cross-section is circular with diameter 6.2 mm, and at z=blind_depth the circle closes off exactly at radius = inner_blind_radius.
// - This can be done by using difference between two cylinders: one representing the full knob (cylinder from z=0 to z=knob_height), and another representing a cylindrical tunnel that goes from z=0 to z=blind_depth with radius = inner_blind_radius, but we'll shift the inner cylinder's axis slightly in the radial direction? Not needed.
// - Actually, if we take A = cylinder(h=knob_height, r=knob_diameter/2, center=true) and B = cylinder(h=blind_depth, r=inner_blind_radius, center=true), then difference(A, B) will remove a cylindrical tunnel that goes from z=0 to z=blind_depth with radius inner_blind_radius, but the removed region's top surface is at z=blind_depth and its bottom surface is flush with z=0 (coplanar faces). This violates rule 5.
// - To avoid coplanarity, we'll make B slightly taller so that its top face is above z=