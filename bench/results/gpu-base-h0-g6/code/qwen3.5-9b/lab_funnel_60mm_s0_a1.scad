// Lab Funnel Design (Corrected)
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel)
$cone_bottom_diameter = 10;  // Matches spout outer diameter
$cone_top_diameter = 60;     // Rim diameter
$cone_height = 30;           // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for curved surfaces
$fn = 128;

// --- Helper Functions ---

// Function to create a hollow cylinder (tube)
// Arguments: outer_d, inner_d, height, center_z
module hollow_cylinder(outer_d, inner_d, height, center_z) {
    translate([0, 0, center_z - height/2]) {
        difference() {
            cylinder(h = height, d = outer_d, $fn = $fn);
            cylinder(h = height, d = inner_d, $fn = $fn);
        }
    }
}

// Function to create a hollow cone using rotate_extrude
// Arguments: bottom_d, top_d, height, center_z
// The cone tapers from bottom_d at center_z - height/2 to top_d at center_z + height/2
module hollow_cone(bottom_d, top_d, height, center_z) {
    translate([0, 0, center_z - height/2]) {
        difference() {
            // Outer Cone
            // Profile: Triangle from -bottom_d/2 to +bottom_d/2 at z=0, 
            // tapering to -top_d/2 to +top_d/2 at z=height.
            rotate_extrude(angle = 360, $fn = $fn) {
                // We need to define the profile in the XZ plane.
                // Since we rotate around Z, the profile is drawn in XZ.
                // However, rotate_extrude expects the profile to be in the XY plane of the current context.
                // We will use a polygon in the XZ plane and rotate it 90 deg around X before extruding?
                // No, standard practice: Draw profile in XY, rotate around Z.
                // Let's define the profile in the XZ plane relative to the object, then rotate the whole thing 90 deg around X to stand up.
                
                // Actually, simpler approach for rotate_extrude:
                // 1. Create a 2D profile in the XZ plane (using polygon).
                // 2. Rotate that profile 90 degrees around the X axis so it lies in the XY plane.
                // 3. Extrude around Z.
                
                // Wait, rotate_extrude rotates around Z.
                // If we want a cone standing on its base (Z axis), the profile must be in the XY plane.
                // The profile of a cone is a triangle.
                // Let's define the triangle in the XZ plane first, then rotate it 90 deg around X to put it in XY.
                
                // Correct sequence:
                // 1. Define polygon in XZ plane: points [(-bottom_d/2, 0), (-top_d/2, height), (top_d/2, height), (bottom_d/2, 0)]
                // 2. Rotate this polygon 90 deg around X axis. Now it is in the XY plane.
                // 3. linear_extrude(height=height) around Z? No, rotate_extrude does the rotation.
                
                // Let's try the standard "rotate_extrude" method directly:
                // We need a profile in the XY plane that, when rotated 360 around Z, creates the cone.
                // The profile is a triangle with vertices:
                // (-bottom_d/2, 0), (0, height), (bottom_d/2, 0) -> This creates a cone pointing UP.
                // But our cone widens from bottom to top.
                // So at z=0 (local), width = bottom_d. At z=height, width = top_d.
                // Profile points: (-bottom_d/2, 0), (0, height), (bottom_d/2, 0).
                // Wait, if we rotate around Z, the Y coordinate becomes the height (Z in world).
                // So:
                // Point 1: (-bottom_d/2, 0) -> Radius = bottom_d/2, Height = 0.
                // Point 2: (0, height) -> Radius = 0, Height = height. (This makes a cone pointing UP from the base).
                // Point 3: (bottom_d/2, 0) -> Radius = bottom_d/2, Height = 0.
                // This creates a cone with the wide part at the bottom (z=0) and narrow at top.
                // We want wide at top (z=height) and narrow at bottom (z=0).
                // So we need:
                // Point 1: (-bottom_d/2, 0) -> Radius = bottom_d/2, Height = 0.
                // Point 2: (0, height) -> Radius = 0, Height = height. (Narrow top)
                // Point 3: (bottom_d/2, 0) -> Radius = bottom_d/2, Height = 0.
                // This is still narrow at top.
                
                // Let's re-evaluate coordinates for rotate_extrude (XY plane, rotate around Z):
                // X = Radius, Y = Height.
                // We want Radius = bottom_d/2 at Y=0.
                // We want Radius = top_d/2 at Y=height.
                // Profile: Line from (-bottom_d/2, 0) to (0, height) to (bottom_d/2, 0)? No.
                // Line from (-bottom_d/2, 0) to (0, height) -> Radius decreases as height increases.
                // Line from (0, height) to (bottom_d/2, 0) -> Radius increases as height decreases.
                // This creates a cone with the point at the top (Y=height).
                // We want the point at the bottom (Y=0) if bottom_d < top_d?
                // No, we want the wide part at the top (Y=height).
                // So at Y=0, Radius = bottom_d/2.
                // At Y=height, Radius = top_d/2.
                // Since bottom_d (10)