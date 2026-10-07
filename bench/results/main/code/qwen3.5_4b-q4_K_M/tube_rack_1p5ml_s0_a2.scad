// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions measured with calipers (mm)

// Block dimensions
block_length = 106; // X dimension in mm
block_width = 72;   // Y dimension in mm
block_height = 30;  // Z dimension in mm

// Hole grid parameters
hole_rows_y = 4;    // Number of rows along Y axis (columns)
holes_per_row_x = 6;// Number of columns along X axis (rows)
centre_to_centre_spacing = 16; // Spacing between hole centers (mm)
hole_diameter = 11.2;     // Hole diameter in mm
tube_insertion_depth = 25; // Depth of holes from top surface (mm)

// Floor thickness parameters
floor_thickness = block_height - tube_insertion_depth; 
// Calculated: 30 - 25 = 5 mm solid floor at the bottom

// Difference extension for clean cuts (Rule #5)
cut_extension = 1.0; // Extend cut shapes by 1mm past faces to avoid coplanar issues

// Main block geometry centered on origin
main_block = cube([block_length, block_width, block_height]);

// Function to calculate X coordinates for a row of holes
function get_x_coords(count) {
    step = centre_to_centre_spacing;
    // Calculate the range needed: (count - 1) * spacing
    span = (count - 1) * step;
    
    // To center on origin, we need to shift so that sum(x_i) == 0.
    // For even count N=6 and odd number of intervals M=5 with fixed step S:
    // We cannot have perfect symmetry around X=0 if all adjacent gaps are equal (sum would be non-zero).
    // However, we can distribute them such that the bounding box is centered relative to the block's center? 
    // Or simply place them symmetrically by accepting a slightly larger gap in one direction or shifting.
    // Let's use the logic: Start from -span/2 + step/2 and increment. This centers the first hole at -(N-1)/2 * S / 2 ? No.
    // Standard approach for "centered": 
    // x_i = (i - count/2) * spacing; -> results in [-3*8, ...] which is not integer steps of 16?
    // Let's try: offsets from center such that they are as close to symmetric as possible.
    // Indices relative to a start point S_start. 
    // We want the set {x} to be centered at 0. Sum(x) = 0.
    // Try sequence: -48, -32, -16, +16, +32, +48? (Sum=0). Gaps are 16, 16, 32, 16, 16. 
    // This creates a large gap in the middle but satisfies "centered" and fixed spacing where possible.
    // Alternative: Shift slightly to close the gap? e.g., -40, -28... No, that breaks C-C=16 rule for some pairs.
    // Let's stick to the symmetric set with a central void if strictly required by math, 
    // OR use the "evenly distributed within bounds" logic which is more common in CAD unless specified otherwise.
    // Given "grid centred on the block", let's assume we want the holes evenly spaced across the available width minus margins?
    // But C-C=16 is strict. 
    // Let's try to fit them into [-40, 40] roughly. 
    // If we use: -32, -16, +8 (skip), +24... No.
    // Okay, let's generate the list explicitly for N=6 and S=16 centered at origin by using a loop that adjusts the last point?
    // Actually, the most robust way to get "centered" with even count is:
    // x_i = (i - 3) * step; -> indices 0..5. Center index is 2.5. 
    // i=0 -> -48. i=1 -> -32. i=2 -> -16. i=3 -> +16? No, (3-3)*16 = 0.
    // Let's try: x_i = (i - count/2) * step; 
    // i=0..5. center=3.
    // 0-> -48. 1-> -32. 2-> -16. 3-> +0? No, we want symmetry around 0.
    // If we use x_i = (i - count/2) * step, then for i=3, x=0. For i=5, x=48. 
    // This is not symmetric because there are more points on the negative side? No, indices are symmetric around 2.5.
    // Wait, if center index is 2.5 (between 2 and 3).
    // Let's try: offsets = [ -7*4 + i*8 ] ? No step is 16.
    // Okay, let's just calculate the coordinates that sum to zero with minimal max deviation from symmetry? 
    // Actually, for N=6, S=16 centered at origin, the only integer solution where adjacent diffs are <= S and symmetric around 0 involves a gap of 2*S in the middle.
    // Set: {-48, -32, -16, +16, +32, +48}. Sum = 0. Max diff is 32 (between -16 and 16). All others are 16. 
    // This seems the most mathematically correct interpretation of "centered" with fixed spacing constraints for even N.
    
    coords = [];
    step_val = centre_to_centre_spacing;
    start_idx = -(count / 2); // -3
    
    for (i = count) {
        x_pos = ((start_idx + i) * step_val); 
        if (!(x_pos in coords)) {
            coords.push(x_pos);
        }
    }
    
    return coords;
}

// Calculate X coordinates for 6 columns
x_coords_list = get_x_coords(holes_per_row_x);

// Function to calculate Y coordinates for a column of holes (4 rows)
function get_y_coords(count) {
    step = centre_to_centre_spacing;
    span = (count - 1) * step;
    
    // For N=4, M=3. Odd intervals. Perfect symmetry is possible with integer steps around 0?
    // Indices: -2*step/2 ... ? 
    // Try sequence centered at 0: {-24, -8, +8, +24}? Gaps: 16, 16, 32 (between -8 and 8). Sum = 0.
    // Or {-16, 0, 16} ? No count is 4.
    // Let's try offsets from center such that they are symmetric. 
    // If we use the same logic as X: start_idx = -(count/2) -> -2.
    // i=0..3. Start=-2.
    // x_0 = (-2)*16 = -32? No, let's recalculate based on symmetry of points around 0.
    // Points: p1, p2, p3, p4. Sum(p) = 0. 
    // Try {-2*8=-16, ...} No step is 16.
    // Let's try to fit them in [-25, +25] roughly? Span needed for C-C=16 with N=4 is 3*16=48mm.
    // Center of span = -24 and +24? 
    // If we place centers at: -24, -8, +8, +24. Sum = 0. Gaps: 16, 16, 32 (between -8 and 8).
    // This works perfectly for symmetry around origin with a central gap of one spacing unit? 
    // Wait, is there another way? {-16, 0, +16}? No count=4.
    // How about shifting the whole set so it fits better in Y (72mm)? 
    // Range [-32, -8] to [8, 24]? Sum = (-32-8+8+24) = -8? Not zero.
    // Let's stick to the symmetric sum=0 solution: {-32, -16, +16, +32}? 
    // Gaps: |-32 - (-16)| = 16. |(-16)-(+16)| = 32. |(16)-(32)| = 16.
    // This creates a gap between the middle two holes? No, indices are adjacent in list but physically separated by 32mm if we follow this set.
    // Is there a way to have NO gaps > S and sum=0 for N even? 
    // Only if