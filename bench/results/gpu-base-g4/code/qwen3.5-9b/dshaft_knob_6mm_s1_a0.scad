// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Print Orientation: Bottom face (with D-bore) on Z=0, building upward.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Main Body
D_KNOB_DIAMETER = 30;
D_KNOB_HEIGHT = 15;
D_KNOB_RADIUS = D_KNOB_DIAMETER / 2;

// Shaft Bore (D-shape)
D_SHAFT_DIAMETER = 6;
D_SHAFT_DEPTH = 12;
D_SHAFT_RADIUS = D_SHAFT_DIAMETER / 2;
D_SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite side
D_SHAFT_FLAT_OFFSET = (D_SHAFT_RADIUS - (D_SHAFT_FLAT_WIDTH / 2)); // Offset of flat from center

// Grip Grooves
N_GROOVES = 18;
GROOVE_DEPTH = 1; // Depth of groove from surface
GROOVE_WIDTH = 2; // Diameter of the half-cylinder groove
GROOVE_RADIUS = GROOVE_WIDTH / 2;

// Top Pointer
POINTER_WIDTH = 1.5;
POINTER_DEPTH = 1;

// --- Construction ---

// 1. Main Cylinder Body
// Centered at origin, height extends from -D_KNOB_HEIGHT/2 to +D_KNOB_HEIGHT/2
// However, user requested "rests on the bed (z=0)". 
// We will model the part centered at Z=0 for symmetry in calculations, 
// then translate it down by D_KNOB_HEIGHT/2 so the bottom is at Z=0.
// Actually, to strictly follow "rests on bed... builds upward", let's define the base at Z=0.
// But standard OpenSCAD practice for "centered on origin" usually implies the bounding box center.
// Re-reading rule 3: "rests on the XY plane at z = 0 and builds upward".
// So the bottom face is at Z=0. The top is at Z=D_KNOB_HEIGHT.
// We will center X and Y at 0.

difference() {
    
    // --- Main Body ---
    // Cylinder: Radius = D_KNOB_RADIUS, Height = D_KNOB_HEIGHT
    // Position: Bottom at Z=0, Center at (0,0, D_KNOB_HEIGHT/2)
    translate([0, 0, D_KNOB_HEIGHT/2])
        cylinder(h = D_KNOB_HEIGHT, r = D_KNOB_RADIUS, $fn = $fn);

    // --- D-Shaped Blind Bore ---
    // Location: Bottom face (Z=0), going up to Z=D_SHAFT_DEPTH.
    // Geometry: Circle of D_SHAFT_RADIUS, but one side is flat.
    // The flat is on the "front" (let's say -Y side) relative to the knob's rotation?
    // The prompt says "From that bottom face...". It doesn't specify the rotation of the D relative to X/Y.
    // Standard convention: Flat side usually faces a reference axis. Let's place the flat side 
    // along the -Y axis (so the flat surface is at Y = -D_SHAFT_FLAT_OFFSET).
    // This makes the D-shape symmetric around the XZ plane.
    
    // We need to cut a D-shape hole.
    // Easiest way: Create a D-shape polygon, extrude it, and difference it.
    // The D-shape consists of a rectangle and a semi-circle.
    // Rectangle width = D_SHAFT_FLAT_WIDTH, Height = D_SHAFT_RADIUS.
    // Wait, the definition is: "distance from the flat to the opposite side of the circle is 4.7 mm".
    // Total diameter = 6.2 mm.
    // Flat width = 4.7 mm.
    // The flat is a chord. The distance from the chord to the arc is 4.7 mm.
    // The radius is 3.1 mm.
    // Distance from center to chord = Radius - 4.7 = 3.1 - 4.7 = -1.6 mm.
    // This means the center of the circle is 1.6 mm "inside" the flat side.
    // So the flat side is at Y = -1.6 mm (if center is 0,0).
    // The arc extends from Y = -1.6 to Y = +3.1.
    
    // Let's construct the D-shape profile in the XZ plane (since the bore is vertical along Z).
    // Actually, the bore is vertical, so the cross-section is in the XY plane.
    // We extrude the profile along Z.
    
    // Profile construction:
    // We need a shape that is a circle of radius 3.1, but with a flat cut.
    // Let's define the flat side at Y = -D_SHAFT_FLAT_OFFSET.
    // The circle center is at (0,0).
    // The flat line is Y = -1.6.
    // The shape is the intersection of the circle and the half-plane Y >= -1.6.
    
    // To cut this with difference, we can create a "negative" D-shape and subtract it.
    // Or, simpler: Create a full cylinder, then subtract a cylinder with a flat face? No.
    // Best approach: Create a D-shaped prism (extruded polygon) and subtract it.
    
    // Define the D-shape polygon points.
    // Center of circle: (0,0).
    // Flat line Y = -1.6.
    // Intersection of Y = -1.6 and X^2 + Y^2 = 3.1^2:
    // X^2 + (-1.6)^2 = 3.1^2 => X^2 + 2.56 = 9.61 => X^2 = 7.05 => X = +/- 2.655.
    
    // Points for the D-shape (counter-clockwise):
    // Start at bottom-left of flat: (-2.655, -1.6)
    // Go to bottom-right of flat: (2.655, -1.6)
    // Go to top of circle: (0, 3.1)
    // Close loop.
    
    // We need to extrude this shape along Z from 0 to D_SHAFT_DEPTH.
    // To ensure clean cutting, we extend the cutting shape slightly past the main body boundaries.
    // Main body Z range: 0 to 15. Bore Z range: 0 to 12.
    // We will extrude the D-shape from Z = -0.01 to Z = 12.01.
    
    // Calculate intersection X coordinate
    d_shaft_flat_y = -D_SHAFT_FLAT_OFFSET;
    d_shaft_radius = D_SHAFT_RADIUS;
    d_shaft_flat_half_width = sqrt(d_shaft_radius^2 - d_shaft_flat_y^2);
    
    // Create the D-shape profile
    // We use polygon to define the 2D shape, then linear_extrude.
    // Points:
    // 1. (-d_shaft_flat_half_width, d_shaft_flat_y)
    // 2. (d_shaft_flat_half_width, d_shaft_flat_y)
    // 3. (0, d_shaft_radius)
    // Note: We need to close the polygon implicitly or explicitly.
    // linear_extrude creates a solid from the profile.
    
    // To make the subtraction robust, we add a small overhang in Z.
    d_shaft_cut_z_start = -0.01;
    d_shaft_cut_z_end = D_SHAFT_DEPTH + 0.01;
    
    // We need to rotate the D-shape? 
    // The prompt says "one side cut flat". It doesn't specify orientation relative to X/Y.
    // Let's assume the flat side is facing -Y (standard "D" orientation where the flat is at the bottom or back).
    // If the flat is at -Y, the points are:
    // Left: (-w, -y_flat), Right: (w, -y_flat), Top: (0, r).
    
    // Let's build the D-shape extruder.
    // We need to be careful with the order of points for the polygon.
    // Counter-clockwise:
    // (-w, -y_flat) -> (w, -y_flat) -> (0, r) -> back to start.
    
    // Wait, linear_extrude with a polygon creates a solid.
    // We want to subtract this solid from the main cylinder.
    
    // Let's define the points explicitly.
    p1_x = -d_shaft_flat_half_width;
    p1_y = d_shaft_flat_y;
    p2_x = d_shaft_flat_half_width;
    p2_y = d_shaft_flat_y;