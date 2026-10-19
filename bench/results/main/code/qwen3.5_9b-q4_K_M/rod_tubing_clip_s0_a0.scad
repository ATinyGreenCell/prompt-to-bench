// OpenSCAD Snap-on Clip for Lab Stand Rod & Tubing
// Units: Millimetres
// Orientation: Flat on XY plane, building up in +Z (Extrusion height = 10mm)

$fn = 64; // Ensure smooth curves and accurate hole sizes

// --- Dimensions based on user description ---

// Main Extrusion Height
H_EXTRUDE = 10; 

// Rod Ring Parameters
D_ROD_INNER = 12.7;   // Inner diameter for the lab stand rod (1/2 inch)
W_ROD_WALL = 3;       // Wall thickness of the ring
R_OD_OUTER = D_ROD_INNER + 2 * W_ROD_WALL; // Calculated outer diameter: 18.7

// Rod Ring Opening Parameters (-X side cutout)
Y_CUTOUT_HALF_WIDTH_ROD = 5;   // Half width of opening in Y direction (Total 10mm)
X_CUTOUT_START_ROD = -R_OD_OUTER + 2 * W_ROD_WALL; // Start X for the gap on the left side

// Tubing Ring Parameters
D_TUBE_INNER = 6;           // Inner diameter for tubing
W_TUBE_WALL = 2;            // Wall thickness of the ring
R_TD_OUTER = D_TUBE_INNER + 2 * W_TUBE_WALL; // Calculated outer diameter: 10mm

// Tubing Ring Position & Opening Parameters (+X side cutout)
C_X_TUBING = 15;            // Center X position for tubing ring
Y_CUTOUT_HALF_WIDTH_TUBE = D_TUBE_INNER / 2 + W_TUBE_WALL - (D_ROD_INNER/2); 
// Wait, user specified: "4.5 mm wide opening cut out of its +X side" and "-2.25 < y".
// Let's use the explicit Y bounds given in prompt to be safe with tolerances.
Y_CUTOUT_HALF_WIDTH_TUBE_EXPLICIT = 2.25; 
C_X_START_TUBING_GAP = C_X_TUBING - R_TD_OUTER + W_TUBE_WALL; // Start X for gap on right side

// Bridge Parameters (Solid connector)
X_BRIDGE_LEFT = 8;          // Left edge of bridge
X_BRIDGE_RIGHT = 12;        // Right edge of bridge
W_BRIDGE_Y = 6;             // Width in Y direction


// --- Construction Logic ---

difference() {
    
    // 1. Create the Base Extrusion Profile (Filled shape)
    union() {
        
        // Helper function to create a closed polygon for the rod ring with cutout
        // We construct this by defining vertices manually or using circle logic + difference inside loop? 
        // Since we need one solid, let's build the Rod Ring as a single complex polygon.
        
        // --- Part A: The Rod Ring (with -X opening) ---
        rod_points = [];
        R_ROD_OUTER_HALF = R_OD_OUTER / 2;
        R_ROD_INNER_HALF = D_ROD_INNER / 2;
        
        // Top arc of outer circle
        for(i=[0:15]) {
            angle = i * (360/30);
            if(angle < 90 || angle > 270) { 
                px = R_ROD_OUTER_HALF * cos(deg2rad(angle)); // Wait, OpenSCAD uses radians in trig functions usually? No, deg2rad exists. But let's stick to simple math or circle().
                // Actually, constructing a ring with a gap using polygon is tedious vertex by vertex if not careful about the cutout logic inside the loop.
                // Better approach: Create full outer circle, subtract inner hole and specific rectangular cutouts? 
                // No, difference() handles that better. Let's build the Rod Ring as a union of shapes or just use one big polygon definition.
            }
        }
        
        // Alternative Robust Method for Rod Ring with Cutout:
        // Create full outer circle, subtract inner hole (circle), then subtract rectangular cutouts? 
        // But we need to ensure the "cutout" doesn't disconnect the ring unintentionally if geometry is weird.
        // Let's use a polygon defined by vertices to have exact control over the gap shape.
        
        rod_poly = [];
        R_ROD_OUTER_HALF = 18.7 / 2;
        R_ROD_INNER_HALF = 12.7 / 2;
        
        // Start from top of outer circle, go clockwise to bottom, then inner arc back up? 
        // Actually, easiest is: Outer Circle - Inner Hole - Rectangular Cutout on Left.
        // But we must ensure the cutout doesn't touch the rod center if it's supposed to be a ring around the stand.
        
        // Let's build Rod Ring as: Full Cylinder (for profile) MINUS Inner Hole MINUS Gap Rectangle? 
        // No, in 2D profile for extrusion:
        // Shape = Union of Outer Circle AND ... wait.
        // Standard way: Create a polygon that traces the perimeter.
        
        // Trace Rod Ring Perimeter:
        // Start at top outer (0, R_ROD_OUTER_HALF) -> go right to 90 deg? No.
        // Let's define vertices for the "Rod Ring with Gap".
        // We want a ring around x=0. The gap is on the left (-X).
        
        rod_vertices = [];
        
        // Top Outer Arc (from angle -180 to 90 roughly, avoiding the cutout area)
        // Cutout is at X < 0 between Y=-5 and Y=5.
        // So we trace outer circle from top-left-ish down to bottom-right? 
        // Let's just use a polygon that goes: Top Outer -> Right Outer -> Bottom Outer -> Inner Arc (Right side) -> Gap Floor -> Inner Arc (Left side near gap?) -> Left Outer?
        
        // Simpler approach for the Rod Ring in OpenSCAD without complex vertex math errors:
        // Create a full outer circle, subtract an inner hole shifted slightly to create thickness? No.
        // Let's use `polygon()` with calculated points.
        
        R_OUT = 18.7 / 2;
        R_IN = 12.7 / 2;
        
        // Points for the solid part of the ring (avoiding the gap)
        // We will trace: Top Outer -> Right Outer Arc -> Bottom Outer -> Inner Arc (Right side, going up to Y=5?) 
        // Wait, the cutout is a rectangle removed from the ring.
        // So we need vertices for: Outer Circle MINUS Inner Hole MINUS Rect Cutout?
        // If we do Union(OuterCircle) - Difference(Hole + Gap), it works perfectly in OpenSCAD logic if done sequentially.
        
        rod_ring_part = difference() {
            union() {
                circle(r=R_OUT, center=[0,0]); 
            }
            
            // Subtract Inner Hole (The hole for the stand rod)
            circle(r=R_IN, center=[0,0], $fn=64);
            
            // Subtract The Gap on the Left Side (-X side)
            // Defined as: x < 0 AND -5 < y < 5. 
            // To make it a valid subtraction shape in OpenSCAD (must be closed), we define a rectangle or polygon.
            // Rectangle from X = -R_OUT to X = 0, Y from -5 to 5? 
            // But the ring has thickness on the left too? No, "everything with x < 0 and ... is removed".
            // This implies the entire cross-section of the rod at that location is gone.
            
            rect_gap_rod = polygon([
                [-R_OUT, -Y_CUTOUT_HALF_WIDTH_ROD], 
                [0, -Y_CUTOUT_HALF_WIDTH_ROD], 
                [0, Y_CUTOUT_HALF_WIDTH_ROD], 
                [-R_OUT, Y_CUTOUT_HALF_WIDTH_ROD]
            ]);
            
            difference() {
                 // We need to subtract this rectangle ONLY if it overlaps with the ring material.
                 // Since we are inside a 'difference' block for the rod_ring_part, any subtraction here removes from the union above.
                 rect_gap_rod; 
            }
        };

        // --- Part B: The Tubing Ring (with +X opening) ---
        // Centered at x = 15.
        // Inner dia 6mm -> R_IN_TUBE = 3. Wall 2mm -> R_OUT_TUBE = 7? 
        // Wait, prompt says "4 mm inner diameter"? No, "6 mm inner diameter".
        // Prompt: "tubing ring with 6 mm inner diameter and 2 mm wall" -> Outer = 10mm.
        
        C_X_TUBING_VAL = 15;
        R_OUT_TUBE = (D_TUBE_INNER + 2 * W_TUBE_WALL) / 2; // 7mm radius outer? 
        // Wait, D=6, Wall=2 -> Outer Diameter = 10. Radius = 5.
        
        tube_ring_part = difference() {
            union() {
                circle(r