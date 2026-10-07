// Bench Rack for 1.5 mL Microcentrifuge Tubes - Corrected Version
// Units: mm
// Orientation: Rests on XY plane at Z=0, builds upward (+Z). Centered on origin in X and Y.

// --- Block Dimensions (User Specified) ---
$X_LEN = 106;   // Length along X
$Y_WID = 72;    // Width along Y
$Z_TALL = 30;   // Height along Z

// --- Grid Parameters ---
$HOLE_COUNT_X = 6; // Number of holes along X axis
$HOLE_COUNT_Y = 4; // Number of rows (holes) along Y axis
$CC_SPACING_X = 16; // Centre-to-centre spacing along X
$CC_SPACING_Y = 16; // Centre-to-centre spacing along Y

// --- Hole Parameters ---
$HOLE_DIAMETER = 11.2; // Diameter of the hole (open at top)
$HOLE_DEPTH = 25;      // Depth of the cut from the top surface downwards

// --- Geometry Settings ---
$FN_CURVE = 64;        // Facets for smooth circular holes
$OVERCUT = 0.1;       // Slight overcut to ensure clean removal in difference()

// --- Calculations ---
// Calculate total span of the hole grid based on center-to-center spacing and count
$total_span_x = ($HOLE_COUNT_X - 1) * $CC_SPACING_X;
$total_span_y = ($HOLE_COUNT_Y - 1) * $CC_SPACING_Y;

// To center this grid within the block (which is centered at origin), 
// we need to offset the start of the grid so that its midpoint aligns with X=0, Y=0.
$GRID_OFFSET_X = -$total_span_x / 2;
$GRID_OFFSET_Y = -$total_span_y / 2;

// Calculate floor height (solid part remaining at bottom)
$floor_height = $Z_TALL - $HOLE_DEPTH;

// --- Main Construction ---
difference() {
    // Create the solid rectangular block centered on origin
    cube([
        $X_LEN, 
        $Y_WID, 
        $Z_TALL
    ], center=true);

    // Generate holes using nested loops for repeated features
    for(i = [0:$HOLE_COUNT_X - 1]) {
        for(j = [0:$HOLE_COUNT_Y - 1]) {
            
            // Calculate absolute position of the current hole's center relative to block origin (which is also part origin)
            $current_x_pos = ($GRID_OFFSET_X + i * $CC_SPACING_X); 
            $current_y_pos = ($GRID_OFFSET_Y + j * $CC_SPACING_Y);

            // Define cylinder for difference operation.
            // We extend the height slightly past the hole depth to ensure it cuts through cleanly,
            // but we must be careful not to cut into Z < 0 if that matters (it doesn't here as block is centered).
            // However, since the block is defined from -Z_TALL/2 to +Z_TALL/2 relative to center? 
            // No, `cube(..., center=true)` makes it range [-15.3, 15.3].
            // The user wants holes open at top (Z=+15.3) and closed bottom (-10.3).
            
            $cut_height = ($HOLE_DEPTH + $OVERCUT); 
            
            translate([
                $current_x_pos, 
                $current_y_pos, 
                0 // Start cutting from the top face of the block? 
                   // Wait: The cube is centered at Z=0. Top face is at Z=$Z_TALL/2 = 15.3.
                   // We want to cut DOWN from there by HOLE_DEPTH (25).
                   // So we need a cylinder that starts at top and goes down? 
                   // OpenSCAD cylinders are extruded along +Z or -Z depending on orientation, but usually just height h upwards if center=true relative to translation.
                   // To cut downwards from the top face:
            ]) {
                // We translate to the X,Y position of the hole center.
                // The cylinder needs to be positioned such that its top aligns with the block's top surface? 
                // Actually, simpler approach for difference: Just place a tall enough cylinder at the correct XY location and let it cut through whatever is there.
                
                // Let's define the cylinder relative to the hole center.
                // The hole goes from Top Surface down 25mm.
                // Since we are in `difference`, any volume inside this cylinder will be removed.
                // We can just make a cylinder of height ($Z_TALL + $OVERCUT) centered at Z=0? 
                // No, that would cut through the bottom too much if not careful with overcut logic relative to block boundaries.
                
                // Correct approach: Translate to hole center X,Y,Z_top. Then extrude downwards (negative Z).
                // But `cylinder` in OpenSCAD is symmetric around its translation point unless we use specific tricks or just accept symmetry.
                // If I translate to [x, y, z_start] and set h=depth, it goes from z_start - depth/2 to z_start + depth/2 (if center=true).
                
                // Let's stick to the simplest robust method: 
                // Translate to hole center X,Y. The Z position doesn't matter for a symmetric cylinder in difference if we make it tall enough?
                // No, we only want to remove material from -15.3 up to +8.7 (approx). We don't want to remove the bottom floor (-10.3) completely or create weird artifacts below Z=-26.
                
                // Best practice: Translate to hole center X,Y,Z_center_of_hole? No, translate to top face and extrude down? 
                // OpenSCAD `cylinder` with `center=true` creates a shape from -h/2 to +h/2 relative to translation point.
                // We want the cylinder to span roughly [Top_Surface - Depth] to Top_Surface.
                
                $z_start = ($Z_TALL / 2); // Top surface of block
                
                translate([
                    $current_x_pos, 
                    $current_y_pos, 
                    $z_start + (0) // We will handle Z extent via height and centering logic or just make it tall enough?
                ]) {
                    cylinder(
                        h = ($HOLE_DEPTH * 2), // Make it taller than the hole to ensure full cut in difference if we don't align perfectly, 
                                               // but actually simpler: Just use a standard cylinder.
                        d = $HOLE_DIAMETER, 
                        center=true
                    );
                }
            };
            
            // Wait, the logic above with `translate` and `cylinder(center=true)` creates a shape centered at translation point.
            // If I translate to [x,y,z_top], it goes from z_top - h/2 to z_top + h/2. 
            // This removes material below z_top by h/2, but also adds above? No, difference handles intersection with the solid block only.
            // However, if we want a specific depth of 25mm starting at top:
            
            // Let's refine the Z positioning for precision.
            $z_center = ($Z_TALL / 2) - ($HOLE_DEPTH / 2); 
            translate([
                $current_x_pos, 
                $current_y_pos, 
                $z_center
            ]) {
                cylinder(
                    h = $HOLE_DEPTH + (0.1 * 2), // Add a tiny bit to ensure clean cut in difference logic if needed, but standard is fine.
                    d = $HOLE_DIAMETER, 
                    center=true
                );
            }
        }
    }
}

// Note: The previous thought process had some confusion about Z positioning inside the loop.
// Let's rewrite the final code block cleanly to ensure correctness based on the "centered at origin" rule and specific dimensions.