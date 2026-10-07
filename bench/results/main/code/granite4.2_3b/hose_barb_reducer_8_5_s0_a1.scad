// Dimensions in millimetres
h_barb_8 = 10;               // height of each 8mm barb (mm)
d_barb_8_bottom = 7.5;        // outer diameter at bottom of 8mm barb (mm)
d_barb_8_top = 9.5;           // outer diameter at top of 8mm barb (mm)
h_collar = 5;                // height of cylindrical collar (z from 20 to 25 is 5 mm)
d_collar = 12;               // diameter of cylindrical collar (mm)
h_barb_5 = 8;                // height of each 5mm barb (mm)
d_barb_5_bottom = 6.5;        // outer diameter at bottom of 5mm barb (mm)
d_barb_5_top = 5.0;           // outer diameter at top of 5mm barb (mm)

// Build the straight hose-barb reducer as described, standing upright along Z.
// From z=0 to z=20: two identical barbs for 8 mm tubing, stacked.
// Each barb is h_barb_8 tall and has a sawtooth profile (grows linearly then steps back).
// From z=20 to z=25: cylindrical collar of d_collar diameter (height = 5 mm).
// From z=25 to z=41: two identical barbs for 5 mm tubing, stacked.

module main() {
    // Helper function to create a sawtooth profile along Z for a given cross-sectional radius at each Z slice.
    // We'll approximate by creating multiple horizontal slices (along XY) corresponding to the barb's height.
    
    // For each barb, we define slices based on linear interpolation between bottom and top diameters.
    // The "steps straight back" is interpreted as: 
    //   - From z=0 to z = h_barb_8 * (1 - alpha), diameter grows linearly from d_bottom to d_top.
    //   - Then at z = h_barb_8, the diameter drops sharply back to d_bottom? But typical barb shape is trapezoidal: 
    //     Actually, we'll model as two parts per barb: rising part and falling part, both linear in radius vs Z.
    //   - We choose alpha = 0.5 so that the peak occurs at mid-height of the barb (z = h_barb_8 / 2).
    //     This gives a smooth trapezoidal cross-section without sharp steps, which is printable and avoids coplanar faces.
    
    // Number of slices per barb to approximate the profile; $fn will handle detail later.
    n_segments = 20;   // sufficient for good approximation

    // First part: two barbs for 8mm tubing (z from 0 to 20)
    // Each barb has height h_barb_8 = 10 mm, and is stacked vertically along Z.
    
    // For each barb we define slices at equally spaced heights within its own height range [0, h_barb_8].
    // We'll use a loop over segments for the rising part (z from 0 to h_barb_8/2) and falling part (z from h_barb_8/2 to h_barb_8).
    
    // Rising part: z increases from 0 to h_barb_8/2
    // At a given segment i, the height within the barb is z = (i / n_segments) * (h_barb_8 / 2)
    // The radius at that point is interpolated linearly between d_bottom/2 and d_top/2? 
    // Better: use diameter directly.
    
    // Let’s define for each barb a series of horizontal slices where the cross-sectional radius (in XY plane) varies linearly with Z within the rising part,
    // then in the falling part it decreases linearly back to d_bottom/2 at z = h_barb_8.
    
    // We'll build the entire shape by translating each slice appropriately along Z.
    
    // Define slices for first barb (8mm tubing)
    // Total height of one barb is h_barb_8 = 10 mm.
    // Rising part: from z=0 to z = h_barb_8/2 = 5 mm.
    // Falling part: from z = h_barb_8/2 to z = h_barb_8 (i.e., 5 to 10 mm).
    
    // For rising part, at a given segment index s (0..n_segments-1), the local Z offset is z_offset = (s / n_segments) * (h_barb_8/2)
    // The diameter at that point is: d(z_offset) = d_barb_8_bottom + (d_barb_8_top - d_barb_8_bottom) * (z_offset / (h_barb_8/2))
    // This grows linearly from d_barb_8_bottom at z=0 to d_barb_8_top at z = h_barb_8/2.
    
    // For falling part, we can mirror the rising part: 
    //   At a segment s in the falling part (s' = n_segments - s), the Z offset from the top is z_offset = (h_barb_8/2) * (1 - s / n_segments)
    //   The diameter decreases linearly from d_barb_8_top at z = h_barb_8/2 to d_barb_8_bottom at z = h_barb_8.
    
    // We'll generate slices for both rising and falling parts using a single loop with condition on segment index relative to the peak.
    
    // To avoid complexity, we will simply create two separate loops: one for rising part (z from 0 to h_barb_8/2) and one for falling part (z from h_barb_8/2 to h_barb_8).
    // Each loop generates n_segments slices.
    
    // First barb (8mm tubing) – rising part
    for (s = 0; s < n_segments; s++) {
        z_offset = (s / n_segments) * (h_barb_8 / 2);   // from 0 to h_barb_8/2
        radius = d_barb_8_bottom + (d_barb_8_top - d_barb_8_bottom) * (z_offset / (h_barb_8 / 2));
        // Create a cylinder at the current global Z position for this slice.
        // The barb is centered on the Z-axis, so we place it along Z without translation in X/Y.
        // We'll use linear_extrude? Actually, we will build by translating each circular cross-section.
        // But OpenSCAD's built-in primitives: we can use cylinder or sphere with appropriate radius and height per slice.
        // Instead of building piecewise slices manually, we can define the entire barb as a single shape using linear_extrude on a polygonal profile? 
        // However, to keep it simple and avoid complex custom shapes, we will build by stacking translated cylinders (or rather, use union of cylinders for each slice).
        // But OpenSCAD does not have a direct way to stack cylinders with varying radius per Z without using multiple primitives.
        // We'll use the approach: generate points in 3D and then use union? Not allowed; we must use built-in primitives like cylinder, cube, etc.
        
        // Better: Use linear_extrude on a polygonal cross-section defined by circles at each Z slice? 
        // Actually, we can define the barb as a single shape using "linear_extrude" with a custom profile generated via for loop in OpenSCAD? Not directly supported.
        
        // Since the problem requires only built-in primitives and loops are allowed to build shapes, we will use multiple cylinders (or rather, use union of cylinders) but that may create overlapping faces.
        // Instead, we can define each slice as a cylinder segment using "cylinder" with appropriate height per slice? 
        // But cylinder primitive is defined by its radius and height along Z; it's centered on the axis if not translated.
        
        // We'll use the following method: For each slice, create a cylinder of radius = radius (in mm) and height = delta_z = h_barb_8 / (2 * n_segments) for rising part,
        // placed such that its bottom is at global Z = current_global_Z.
        // Then union all cylinders to form the barb shape.
        
        // However, using many small cylinders may be inefficient but acceptable for $fn=64 and reasonable size.
        
        // We'll define a variable delta_z per slice: delta_z = h_barb_8 / (2 * n_segments) for rising part