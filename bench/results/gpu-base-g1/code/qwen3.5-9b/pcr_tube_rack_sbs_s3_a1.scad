// 96-Well PCR Tube Rack (0.2 mL)
// Designed for FDM 3D printing.
// Orientation: Rests on XY plane at Z=0, builds upward (+Z).
// Centred on origin in X and Y.

// --- Dimensions (mm) ---
// Block Dimensions
$block_length = 127.76; // X
$block_width  = 85.48;  // Y
$block_height = 20;     // Z

// Hole Specifications
$hole_count_x = 12;     // Columns along X
$hole_count_y = 8;      // Rows along Y
$hole_diameter = 6.2;   // mm
$hole_spacing = 9.0;    // Centre-to-centre spacing

// Grid Positioning (from edges)
$offset_x = 14.38;      // Distance from left edge to first hole (A1)
$offset_y = 11.24;      // Distance from back edge to first hole (A1)

// Chamfer Specifications
$chamfer_leg = 5;       // mm

// --- Configuration ---
$fn = 128; // High resolution for smooth holes and chamfers

// --- Main Block ---
difference() {
    // 1. Create the main block
    cube([
        $block_length,
        $block_width,
        $block_height
    ], center = false);

    // 2. Cut the 96 holes
    // We iterate through columns (x) and rows (y)
    for (col = [0 : $hole_count_x - 1]) {
        for (row = [0 : $hole_count_y - 1]) {
            // Calculate position of current hole
            $pos_x = $offset_x + col * $hole_spacing;
            $pos_y = $offset_y + row * $hole_spacing;

            translate([
                $pos_x,
                $pos_y,
                0
            ]) {
                cylinder(
                    h = $block_height + 1, // Extend slightly past top/bottom for clean cut
                    r = $hole_diameter / 2,
                    $fn = $fn
                );
            }
        }
    }

    // 3. Cut the Chamfer at the A1 corner
    // A1 is at ($offset_x, $offset_y).
    // We need to cut a 45-degree chamfer with $chamfer_leg mm legs on the vertical edge at this corner.
    // The cut removes the corner volume defined by the triangle with vertices:
    // ($offset_x, $offset_y), ($offset_x + $chamfer_leg, $offset_y), ($offset_x, $offset_y + $chamfer_leg).
    
    // To cut this, we create a large "wedge" shape that covers this corner region and subtract it.
    // The wedge is defined by the intersection of:
    // 1. A half-space X >= $offset_x
    // 2. A half-space Y >= $offset_y
    // 3. A half-space (X + Y) <= ($offset_x + $offset_y + $chamfer_leg)
    
    // We construct this wedge by intersecting three large boxes/planes.
    // Since we are in a difference(), we create the cutter shape and subtract it.
    
    // Cutter Shape 1: X >= $offset_x (Large box to the right)
    $cutter_x_min = $offset_x;
    $cutter_x_max = 1000;
    $cutter_y_min = -1000;
    $cutter_y_max = 1000;
    $cutter_z_min = -1000;
    $cutter_z_max = 1000;
    
    // Cutter Shape 2: Y >= $offset_y (Large box above)
    // We will combine these using intersection logic inside the subtraction.
    
    // Instead of complex intersection logic which can be tricky in a single difference block without variables,
    // we can create a large box that represents the "corner" and then use a plane to slice it?
    // No, the cleanest way in OpenSCAD for a chamfer is to create a large wedge.
    
    // Let's define the wedge as the intersection of three large volumes.
    // Volume A: X >= $offset_x
    // Volume B: Y >= $offset_y
    // Volume C: X + Y <= ($offset_x + $offset_y + $chamfer_leg)
    
    // We create a large box for A, B, and C, then intersect them to get the exact wedge to subtract.
    
    // Box A (X >= $offset_x)
    box_a = cube([
        $cutter_x_max - $cutter_x_min,
        $cutter_y_max - $cutter_y_min,
        $cutter_z_max - $cutter_z_min
    ], center = false);
    translate([$cutter_x_min, $cutter_y_min, $cutter_z_min]) box_a;
    
    // Box B (Y >= $offset_y)
    box_b = cube([
        $cutter_x_max - $cutter_x_min,
        $cutter_y_max - $offset_y,
        $cutter_z_max - $cutter_z_min
    ], center = false);
    translate([$cutter_x_min, $offset_y, $cutter_z_min]) box_b;
    
    // Box C (X + Y <= Limit). This is a slanted box.
    // We can approximate this or use a plane.
    // Let's use a large box and rotate it? No, simpler to define the plane equation.
    // The plane is X + Y = Limit.
    // We can create a large box and cut it with a plane? No, we need the volume to subtract.
    // The volume to subtract is the intersection of A, B, and the region "below" the plane X+Y=Limit.
    
    // Let's create a large box that covers the area of interest, then use `intersection` to refine it?
    // Actually, we can just create a large box that covers the corner, and then use a plane to cut it.
    // But `difference` doesn't support planes directly.
    
    // Alternative approach: Create a large wedge using `rotate` and `translate`.
    // A 45 degree chamfer can be seen as cutting a corner off a cube.
    // We can create a large box, rotate it 45 degrees around the Z axis, translate it so the cut face aligns,
    // and then subtract? No, that changes the shape of the rest of the block.
    
    // Correct approach for a single chamfer on a corner:
    // Create a large box that represents the "corner" (X>=ox, Y>=oy).
    // Then, create a large plane (or two intersecting planes) to cut it.
    // Since we can't easily do "intersection of planes" in a simple way without helper functions,
    // let's use the fact that a chamfer is the intersection of two half-spaces (X>=ox, Y>=oy) and one slanted half-space.
    
    // Let's create a large box that covers the whole potential cut area.
    $limit = $offset_x + $offset_y + $chamfer_leg;
    
    // We will create a large box that is X >= $offset_x and Y >= $offset_y.
    // Then we will subtract the part where X + Y > limit.
    // To do this, we can create a large box and then use a plane cut.
    // Since we can't use planes directly in difference, we create a large "wedge" shape.
    
    // Let's create a large box that covers the area X in [ox, ox+L], Y in [oy, oy+L].
    // Then we cut it with a plane.
    // Wait, the easiest way to model a chamfer in OpenSCAD for subtraction is:
    // Create a large box.
    // Create a large plane (using a very thin box or a polygon extrusion) that acts as the cut surface.
    // But the cut surface is infinite.
    
    // Let's try a different strategy:
    // Create a large box that covers the corner.
    // Create a large box that covers the "cut" region (the wedge).
    // The wedge is defined by X >= ox, Y >= oy, and X + Y <= limit.
    // We can create this wedge by intersecting three large boxes?
    // Box 1: X >= ox
    // Box 2: Y >= oy
    // Box 3: X + Y <= limit.
    
    // Box 3 is tricky. Let's approximate it or use a large box rotated?
    // No, let's use a large box and a plane.
    // We can create a large box [0, 200, 200, 200] and then use `difference` to cut it with a plane?
    // No, we are already in a