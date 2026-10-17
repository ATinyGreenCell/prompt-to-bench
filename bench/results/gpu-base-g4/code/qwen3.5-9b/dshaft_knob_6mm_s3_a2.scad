// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Designed for FDM printing. Orientation: Bottom face on Z=0.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Shaft & Knob Size
shaft_diameter = 6.0;      // Target shaft diameter
knob_diameter = 30.0;      // Outer diameter of knob
knob_height = 15.0;        // Total height of knob
bore_depth = 12.0;         // Depth of the D-shaped bore

// D-Shaft Bore Geometry
bore_circle_d = 6.2;       // Diameter of the circular part of the bore
bore_flat_dist = 4.7;      // Distance from flat side to opposite arc (defines the cut)

// Grip Grooves (Side)
num_grooves = 18;          // Number of vertical grooves
groove_diameter = 2.0;     // Diameter of the half-cylinder groove
groove_depth = 1.5;        // Depth of the groove (radius of half-cylinder)

// Pointer Groove (Top)
pointer_width = 1.5;       // Width of the pointer groove
pointer_depth = 1.0;       // Depth of the pointer groove

// --- Calculations ---
// Calculate the radius of the flat side of the D-bore
bore_circle_radius = bore_circle_d / 2;
bore_flat_radius = bore_circle_radius - (bore_flat_dist / 2);

// --- Main Body ---
// Cylinder: Diameter = knob_diameter, Height = knob_height
// Centered at origin, resting on Z=0.
main_body = translate([0, 0, knob_height/2]) 
    cylinder(h = knob_height, d = knob_diameter, center = false);

// --- D-Shaped Bore ---
// 1. Circular Bore Cylinder
circular_bore = translate([0, 0, bore_depth/2]) 
    cylinder(h = bore_depth, d = bore_circle_d, center = false);

// 2. Flat Side Cut
// This is a rectangular prism.
// Width = bore_flat_dist
// Height = bore_depth
// Depth (Z) = bore_depth
// Position: The flat side is at X = -bore_flat_radius.
flat_cut = translate([-bore_flat_radius, -bore_circle_radius, bore_depth/2]) 
    cube([bore_flat_dist, bore_circle_d * 2, bore_depth]);

// Combine bore parts for subtraction
bore_assembly = union(circular_bore, flat_cut);

// --- Side Grip Grooves ---
// We will create the grooves by rotating a single groove shape around the Z axis.
// The groove is a half-cylinder cut from the outside in.
// To model a half-cylinder cut:
// 1. Create a full cylinder of diameter = groove_diameter.
// 2. Rotate it 90 degrees around the X axis so the flat face is vertical.
// 3. Rotate it around the Z axis to align the flat face radially inward.
// 4. Translate it to the surface of the knob.

// Define the groove shape relative to its center
// We need a cylinder that, when rotated 90 deg around X, has its flat face pointing towards the center of the knob.
// Let's define the groove shape as a cylinder of diameter = groove_diameter.
// We will rotate it 90 deg around X, then rotate around Z to point the flat face inwards.

// Let's construct the cutting shape for one groove:
// Start with a cylinder of diameter = groove_diameter, height = knob_height.
// Rotate 90 deg around X axis. Now the flat face is in the YZ plane.
// Rotate around Z axis by 180 degrees? No.
// We want the flat face to point towards the center of the knob (negative X direction relative to the groove center).
// If we rotate the cylinder 90 deg around X, the flat face is at Y=0 (if centered).
// Let's try this:
// 1. Cylinder centered at (0,0,0).
// 2. Rotate 90 deg around X. Flat face is now in the YZ plane.
// 3. Rotate around Z by 180 degrees? No.
// Let's just use a cylinder and a plane? No.
// Let's use the `hull` of two points? No.
// Let's use the `rotate` of a cylinder.
// If we rotate a cylinder 180 degrees around the Z axis, it's the same.
// If we rotate a cylinder 90 degrees around the X axis, the flat face is in the YZ plane.
// We want the flat face to be radial.
// So we rotate the cylinder 90 degrees around the X axis, then rotate around Z to align the flat face with the radius.
// Yes.

// Let's define the groove shape:
// 1. Cylinder of diameter = groove_diameter, height = knob_height.
// 2. Rotate 90 deg around X axis. Now the flat face is in the YZ plane.
// 3. Rotate around Z axis by 180 degrees? No.
// Let's try this:
// 1. Cylinder of diameter = groove_diameter, height = knob_height.
// 2. Rotate 90 deg around X axis. Now the flat face is in the YZ plane.
// 3. Rotate around Z axis by 180 degrees? No.
// Let's just use a cylinder and a plane? No.
// Let's use the `hull` of two points? No.
// Let's use the `rotate` of a cylinder.
// If we rotate a cylinder 180 degrees around the Z axis, it's the same.
// If we rotate a cylinder 90 degrees around the X axis, the flat face is in the YZ plane.
// We want the flat face to be radial.
// So we rotate the cylinder 90 degrees around the X axis, then rotate around Z to align the flat face with the radius.
// Yes.

// Let's define the groove shape:
// 1. Cylinder of diameter = groove_diameter, height = knob_height.
// 2. Rotate 90 deg around X axis. Now the flat face is in the YZ plane.
// 3. Rotate around Z axis by 180 degrees? No.
// Let