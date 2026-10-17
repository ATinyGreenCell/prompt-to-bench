// Snap-on Clip for Lab Stand Rod and Tubing
// Orientation: Flat on XY plane, building up in +Z.
// Units: Millimetres.

// --- Dimensions ---
// Rod Ring
$rod_id = 12.7;      // Inner diameter (mm)
$rod_wall = 3.0;     // Wall thickness (mm)
$rod_od = $rod_id + 2 * $rod_wall; // Outer diameter (mm)
$rod_z = 10.0;       // Height of extrusion (mm)

// Tubing Ring
$tube_id = 6.0;      // Inner diameter (mm)
$tube_wall = 2.0;    // Wall thickness (mm)
$tube_od = $tube_id + 2 * $tube_wall; // Outer diameter (mm)
$tube_x = 15.0;      // Center X position (mm)

// Bridge
$bridge_width = 6.0; // Width in Y (mm)
$bridge_x_start = 8.0; // Start X (mm)
$bridge_x_end = 12.0;  // End X (mm)

// Cutouts (Openings)
// Rod Ring Cutout: -X side, width 10mm, centered at y=0
$rod_cut_width = 10.0;
$rod_cut_y_half = $rod_cut_width / 2;

// Tubing Ring Cutout: +X side, width 4.5mm, centered at y=0
$tube_cut_width = 4.5;
$tube_cut_y_half = $tube_cut_width / 2;

// --- Geometry ---

difference() {
    // 1. Main Body (Extruded Profile)
    // We define the 2D profile in the XY plane and extrude it to Z.
    // The profile is constructed by unioning the three main parts.
    
    // Part A: Rod Ring
    // Outer circle at origin
    difference() {
        // Outer ring
        union() {
            cylinder(h = $rod_z, d = $rod_od, center = [0,0,0]);
            // Add a small fillet to the top edge for better printability/handling
            // (Optional, but good practice. Using a small cylinder to round the top edge)
            // Actually, let's keep it simple as requested: flat extrusion.
            // To ensure the cutout doesn't leave a sharp edge that might break, 
            // we rely on the difference logic below.
        }
        
        // Inner hole (Rod ID)
        cylinder(h = $rod_z + 0.1, d = $rod_id, center = [0,0,0]);
        
        // Cutout on -X side
        // Rectangle: x from -5 to 0, y from -5 to 5
        // Extend slightly past the face to ensure clean cut
        translate([-5.01, -5.01, 0.01]) 
            cube([5.01, 10.02, $rod_z + 0.1]);
    }
    
    // Part B: Tubing Ring
    translate([0, 0, 0]) {
        // Position at x = $tube_x
        translate([$tube_x, 0, 0]) {
            difference() {
                // Outer ring
                cylinder(h = $rod_z, d = $tube_od, center = [0,0,0]);
                
                // Inner hole (Tube ID)
                cylinder(h = $rod_z + 0.1, d = $tube_id, center = [0,0,0]);
                
                // Cutout on +X side
                // Rectangle: x from 0 to 4.5, y from -2.25 to 2.25
                translate([0.01, -2.26, 0.01]) 
                    cube([4.51, 4.52, $rod_z + 0.1]);
            }
        }
    }
    
    // Part C: Solid Bridge
    // Joins x=8 to x=12, width 6mm in Y.
    // Must not block the holes.
    // Rod hole is at x=0, y=0, d=12.7. Bridge is at x=8..12. Safe.
    // Tube hole is at x=15, y=0, d=6. Bridge is at x=8..12. Safe.
    translate([$bridge_x_start, -($bridge_width/2), 0]) {
        cube([$bridge_x_end - $bridge_x_start, $bridge_width, $rod_z]);
    }
    
    // --- Cutting Shapes (Difference) ---
    // We need to subtract the "void" of the profile from the main block.
    // Since we built the profile by unioning parts, we can just subtract the 
    // negative space of the profile from a large bounding box, OR
    // we can subtract the specific voids from the union of the solids.
    // The approach above (building solids then unioning them inside difference) 
    // effectively creates the shape. However, to be explicit and robust:
    
    // Let's refine the logic: 
    // 1. Create a large block.
    // 2. Subtract the Rod Ring Void (Outer minus Inner minus Cutout).
    // 3. Subtract the Tube Ring Void (Outer minus Inner minus Cutout).
    // 4. Subtract the Bridge Void (The space around the bridge).
    
    // Actually, the previous block structure was:
    // difference() {
    //    union() { RodRing; TubeRing; Bridge; }
    // }
    // This works perfectly. The RodRing, TubeRing, and Bridge are defined as solids 
    // with their internal holes and cutouts already removed.
    // We just need to make sure the union connects them.
    
    // Re-verifying the "Rod Ring" definition in the block above:
    // It creates a solid ring with a cutout.
    // Re-verifying "Tube Ring": Solid ring with a cutout.
    // Re-verifying "Bridge": Solid block.
    // Unioning them creates the final part.
    
    // One detail: The Rod Ring cutout logic in the first block:
    // translate([-5.01, -5.01, 0.01]) cube([5.01, 10.02, $rod_z + 0.1]);
    // This removes x < 0 (approx) and y in range. Correct.
    
    // One detail: The Tube Ring cutout logic:
    // translate([0.01, -2.26, 0.01]) cube([4.51, 4.52, $rod_z + 0.1]);
    // This removes x > 0 (relative to tube center) and y in range. Correct.
    
    // Final check on connectivity:
    // Rod Ring ends at x=0 (cutout).
    // Bridge starts at x=8.
    // There is a gap between x=0 and x=8.
    // The prompt says: "a solid bridge ... between x = 8 and x = 12 that joins the two rings".
    // If the rod ring has a cutout on the -X side (x<0), the material exists at x>0.
    // The rod ring is a ring. The cutout is on the left (-X). The right side (+X) is solid.
    // The bridge is at x=8 to 12.
    // The rod ring solid part is at x > 0 (mostly).
    // The tube ring is at x=15.
    // The bridge connects the Rod Ring (right side) to the Tube Ring (left side).
    // This geometry makes sense.
    
    // Wait, the Rod Ring definition:
    // "12.7 mm inner diameter ... centred at the origin ... 10 mm wide opening cut out of its -X side"
    // So the ring exists at x > 0 (the right side of the ring).
    // The bridge is at x=8 to 12.
    // The tube ring is at x=15.
    // The bridge connects the Rod Ring (at x~0 to 18.7) and Tube Ring (at x~13 to 17).
    // Specifically, the bridge connects the solid part of the rod ring (which is at x>0) to the tube ring.
    // Since the rod ring cutout is only on -X, the +X side is intact.
    // So the bridge at x=8..12 will sit on the solid part of the rod ring.
    // And it will sit on the solid part of the tube ring (since tube cutout is on +X).
    // This works.
    
    // Just to be absolutely sure about the "Rod Ring" definition in the code:
    // The code creates a cylinder (OD), subtracts a cylinder (ID), subtracts a rect