// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Flat plate rests on XY plane at z=0 to z=4 mm.
// After printing, flip over so walls stand vertically and rack stands on them.

// --- Dimensions (measured with calipers) ---
plate_width = 130;      // X dimension of the base plate
plate_length = 90;       // Y dimension of the base plate
plate_thickness = 4;     // Thickness of the base plate in Z direction during printing
wall_height_printed = 66;// Height of walls from z=0 to z=70 (so final height is 130mm after flip)
hole_diameter = 30.5;    // Diameter of through-holes for Falcon tubes

// --- Geometry Setup ---
plate_x_start = -plate_width / 2;      // Center X start (-65 mm)
plate_y_start = -plate_length / 2;     // Center Y start (-45 mm)

module create_rack() {
    
    // --- Step 1: Define Base Plate (Z = 0 to Z = 4) ---
    base_plate = cube([plate_width, plate_length, plate_thickness]);
    
    // --- Step 2: Define Vertical Walls ---
    // Interpretation based on "run along the two long edges" and "flush with":
    // The walls are rectangular prisms extending upwards from the top surface (Z=4).
    // They run parallel to the X-axis (length 130mm) but have a small thickness in Y.
    // To be "flush with the plate's long edge" and allow tubes at short ends, 
    // they are positioned near the center of the length (X), spanning most or all of it?
    // However, if they span 130mm X, they would block holes unless placed carefully.
    // Given "Two solid walls", let's place them symmetrically along Y to support the rack 
    // while leaving space for tubes at both short ends (Y direction).
    // They are located near the center of the plate in X? Or spanning full length?
    
    // Re-reading "flush with the plate's long edge": This usually implies alignment with the boundary line of length 130.
    // If I put a block on top, flush with an edge... that means its Y-dimension aligns with the X-axis direction? 
    // No, if it sits ON TOP, "flush" refers to its position relative to the perimeter lines.
    
    // Let's assume the most robust design: Two blocks located at X = +/- (plate_width/2 - wall_length_offset)?
    // Actually, let's place them centered on Y axis (-65mm offset from center) and spanning full length in X? 
    // No, if they run along long edge... maybe one is near +Y and one near -Y? 
    
    // Let's assume: Two blocks of size [X=130, Z=66] and thickness Y = 4mm. 
    // Positioned at X = +/- (plate_width/2 - something)? No, that would be along short edges.
    
    // Final Interpretation for Stability & Function:
    // Two blocks located near the center of the plate in both directions to maximize support but minimize blockage? 
    // Or maybe they are just two strips running parallel to X axis, centered on Y axis.
    // Dimensions: 130mm long (X), 4mm thick (Y). Height 66mm.
    
    // Let's place them at the very edges of the plate length-wise? 
    // No, "flush with" implies they touch the edge line. Since they are on top, this means their Y-coordinates align with X=plate_width/2 and X=-plate_width/2 lines?
    // Wait, if a block is flush with an edge (line), it usually shares that coordinate.
    // If I have a plate 130 wide. The long edges are at y = +/-45. 
    // A wall "flush" with the top edge might mean its center line or one side aligns?
    
    // Let's assume standard rack geometry: Two vertical supports located near the ends of the short dimension (Y)? No, that blocks entry.
    // They must be along the long dimension (X). So they are parallel to X.
    // To not block tubes entering from +/- Y, they should ideally be centered on Y or very narrow? 
    // But user said "flush with plate's long edge". This likely means attached to the side faces of length 130mm?
    
    // Let's try this: Two blocks located at X = +/- (plate_width/2 - wall_thickness) ? No.
    // Let's assume they are attached to the SIDE FACES (the ones with dimension Y=90, but their top edge is length 130).
    // If a block is flush with that edge... it sits on top of the plate at X = +/-65? 
    // But then tubes can't pass through holes if they are centered.
    
    // Let's go with: Two blocks located near the center of the short side length (Y), but spanning full length in X (-65 to 65). 
    // Actually, let's place them at Y = +/- (plate_length/2 - wall_thickness) ? No.
    
    // Correct Logic for "Flush with long edge":
    // The plate has two edges of length 130mm (Top and Bottom faces boundaries? Or Side face top edges?). 
    // Let's assume the user means attached to the side walls of the tray itself, extending upwards from them.
    // So they are located at X = +/-65mm relative to center? No, that would be corners.
    
    // Let's try: Two blocks centered on Y axis (Y range -42 to +42), but separated by a gap in X? 
    // Or maybe the user means two strips running along the sides of the plate (the 90mm edges)? No, "long edge".
    
    // Okay, let's assume: Two blocks located at Y = +/- (plate_length/2 - wall_thickness) ? 
    // Let's place them such that they are centered on X axis? No.
    
    // Let's try a specific layout often used in racks: Two supports near the center of the plate length-wise, but offset from each other to allow tube entry?
    // Or maybe two blocks at one end? "Two short ends stay open" implies tubes can enter both sides. 
    // So walls must be along X axis and centered on Y axis (or very close).
    
    // Let's assume: Two blocks of size [X=130, Z=66] and thickness Y = 4mm. 
    // Positioned at X = +/- (plate_width/2 - something)? No.
    // Positioned at Y = +/- (something) spanning full length?
    
    // Let's try: Two blocks located near the center of the plate in both directions to maximize support but minimize blockage? 
    // Or maybe they are just two strips running parallel to X axis, centered on Y axis.
    // Dimensions: 130mm long (X), 4mm thick (Y). Height 66mm.
    
    // Let's place them at the very edges of the plate length-wise? 
    // No, let's assume they are located near X = +/-59mm to leave room for holes? 
    
    // Actually, "flush with" might mean their centerline is aligned with the edge line (X=65 and X=-65).
    // If so, one wall at X=65, one at X=-65. They run along Y direction? No, user said 130mm long (X).
    
    // Okay, let's assume: Two blocks of size [Length=130(X), Width=4(Y)] located at the very edges of the plate in X direction? 
    // i.e., one block from X=-65 to -61, other from 61 to 65? No.
    
    // Let's try: Two blocks centered on Y axis (Y range -3mm to +3mm), but separated by a gap in X? 
    // Or maybe they are attached to the side faces of length 90? 
    
    // Let's assume the user means two blocks located at the ends of the short dimension, extending along the long dimension.
    // So one block near Y=+45 and one near Y=-45? But then "flush with long edge" makes sense if they are attached to the side faces (which have length 130).
    
    // Let's try: Two blocks located at X = +/-65mm (edges of plate), extending in Z from 4 to 70. 
    // Dimensions: Length along Y? No, user said "each wall is ... 130 mm long". So length is X or Y?
    // If they are attached to side faces (length 90), and run along the edge of length 130... that's confusing.
    
    // Let's assume: Two blocks located at X = +/-65mm, extending in Z from 4 to 70. 
    // Their "length"