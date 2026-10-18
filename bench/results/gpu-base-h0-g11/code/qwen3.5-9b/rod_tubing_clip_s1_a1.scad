// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building upward (+Z)
// Units: Millimetres

// --- Dimensions ---
// Rod Ring
$rod_inner_d = 12.7;   // Inner diameter for 1/2" rod
$rod_wall = 3;         // Wall thickness
$rod_outer_d = $rod_inner_d + 2 * $rod_wall; // 18.7 mm
$rod_height = 10;      // Extrusion height (Z)
$rod_cut_width = 10;   // Width of opening on -X side

// Tubing Ring
$tube_inner_d = 6;     // Inner diameter
$tube_wall = 2;        // Wall thickness
$tube_outer_d = $tube_inner_d + 2 * $tube_wall; // 10 mm
$tube_x_pos = 15;      // Center X position
$tube_cut_width = 4.5; // Width of opening on +X side

// Bridge
$bridge_width_x = 4;   // Width in X (from 8 to 12)
$bridge_height_y = 6;  // Height in Y
$bridge_z = $rod_height; // Same height as extrusion

// --- Configuration ---
$fn = 128;             // High resolution for smooth curves

// --- Main Body Construction ---
// We build the solid profile first, then subtract the holes and cutouts.
// This ensures a single watertight body.

difference() {
    union() {
        // 1. Rod Ring (Outer Shell)
        // Centered at (0,0). Outer diameter 18.7.
        // Cutout on -X side: x < 0 and -5 < y < 5.
        // The cutout width is 10mm. Since the ring is symmetric, the cutout spans from x=-5 to x=5?
        // Wait, spec says: "x < 0 and -5 < y < 5 is removed".
        // This implies the cutout is a rectangle defined by x < 0, y > -5, y < 5.
        // However, to make a "snap on" clip, the cutout must be a hole through the material.
        // If the ring is 18.7mm OD, the material exists from radius 9.35 to 12.7.
        // A cutout of width 10mm on the -X side likely means removing material from x = -9.35 to x = 0.75?
        // Or simply removing the rectangle defined by the spec.
        // Let's interpret "10 mm wide opening" as the dimension of the gap.
        // If the gap is 10mm wide and centered on the Y-axis? No, it's on the -X side.
        // Let's assume the gap is from x = -10 to x = 0? Or x = -5 to x = 5?
        // "x < 0 and -5 < y < 5 is removed". This defines a semi-infinite region in X.
        // But we are cutting a ring. The ring material is only where radius > 9.35.
        // So the cutout is the intersection of the ring and the region (x<0, -5<y<5).
        // This creates a gap on the left side.
        
        translate([0, 0, 0]) {
            // Outer Cylinder
            cylinder(h = $rod_height, d = $rod_outer_d, center = [0, 0, $rod_height/2]);
            
            // Inner Hole (Rod passes through)
            cylinder(h = $rod_height, d = $rod_inner_d, center = [0, 0, $rod_height/2]);
            
            // Cutout Logic:
            // We need to subtract the volume where (x < 0) AND (-5 < y < 5).
            // Since we are in a difference(), we add a cutting shape.
            // The cutting shape must cover the entire height and the specific X/Y region.
            // To ensure it cuts through the ring, it must extend beyond the ring's outer diameter in X and Y.
            // X range: -infinity to 0. We'll use -20 to 0.
            // Y range: -5 to 5. We'll use -6 to 6.
            // Z range: 0 to 10.
            translate([-20, -6, 0]) {
                cube([20, 12, $rod_height + 0.1]);
            }
        }
        
        // 2. Tubing Ring (Outer Shell)
        // Centered at (15, 0). Outer diameter 10.
        // Cutout on +X side: x > 15 and -2.25 < y < 2.25.
        translate([$tube_x_pos, 0, 0]) {
            // Outer Cylinder
            cylinder(h = $rod_height, d = $tube_outer_d, center = [0, 0, $rod_height/2]);
            
            // Inner Hole (Tubing passes through)
            cylinder(h = $rod_height, d = $tube_inner_d, center = [0, 0, $rod_height/2]);
            
            // Cutout Logic:
            // Region: x > 15, -2.25 < y < 2.25.
            // Translate to local coords: x > 0, -2.25 < y < 2.25.
            // Cutting shape: x from 0 to 20, y from -3 to 3.
            translate([0, -3, 0]) {
                cube([20, 6, $rod_height + 0.1]);
            }
        }
        
        // 3. Solid Bridge
        // Joins the two rings.
        // Spec: "6 mm wide (Y) between x = 8 and x = 12".
        // This implies the bridge spans X from 8 to 12 (width 4) and Y from -3 to 3 (width 6).
        // It must not block the holes.
        // Rod hole is at (0,0) with d=12.7. Bridge is at x=8..12. Safe.
        // Tube hole is at (15,0) with d=6. Bridge is at x=8..12. Safe.
        translate([8, -3, 0]) {
            cube([4, 6, $rod_height]);
        }
    }
    
    // --- Subtraction of Holes and Cutouts (Redundant but safe for clarity) ---
    // The logic above uses difference() inside the union, which is correct.
    // However, to ensure the "cutout" is exactly as described and clean:
    
    // Rod Cutout (Left side)
    // Defined by x < 0, -5 < y < 5.
    // We subtract a block that covers this area.
    translate([-20, -6, 0]) {
        cube([20, 12, $rod_height + 0.1]);
    }
    
    // Tube Cutout (Right side)
    // Defined by x > 15, -2.25 < y < 2.25.
    // In global coords: x > 15.
    translate([$tube_x_pos, -3, 0]) {
        cube([20, 6, $rod_height + 0.1]);
    }
    
    // Rod Inner Hole
    translate([0, 0, 0]) {
        cylinder(h = $rod_height + 0.1, d = $rod_inner_d + 0.1, center = [0, 0, $rod_height/2]);
    }
    
    // Tube Inner Hole
    translate([$tube_x_pos, 0, 0]) {
        cylinder(h = $rod_height + 0.1, d = $tube_inner_d + 0.1, center = [0, 0, $rod_height/2]);
    }
}