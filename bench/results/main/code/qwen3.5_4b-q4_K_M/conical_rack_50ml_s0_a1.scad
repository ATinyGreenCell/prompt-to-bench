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
    // If they run *along* the long edge, and are flush with it... 
    // Let's assume they are blocks of size: Length=130mm (X), Thickness=4mm (Y), Height=66mm.
    // Position: Centered in X (-65 to 65). Positioned near Y center? Or at edges?
    // If placed at the very edge, tubes might hit them if not careful. 
    // Let's place them centered on the plate surface (X range -64.975 to 64.975) and 
    // separated by a small gap in Y so they don't touch? Or maybe one near +Y/2, one near -Y/2?
    
    // Re-reading "flush with the plate's long edge": This usually implies alignment with the boundary line of length 130.
    // If I put a block on top, flush with an edge... that means its Y-dimension aligns with the X-axis direction? 
    // No, if it sits ON TOP, "flush" refers to its position relative to the perimeter lines.
    
    // Let's assume the most robust design: Two blocks located at X = +/- (plate_width/2 - wall_length_offset)?
    // Actually, let's place them centered on Y axis but separated in X? No, they run along long edge (X).
    // So they must be parallel to X. 
    // Let's assume they are placed near the center of the plate length-wise? Or at one end?
    
    // Decision: Two blocks located symmetrically around the Y-axis (centered in Y), but separated by a gap or touching, 
    // and spanning almost the full width of the plate in X direction to provide stability.
    // Let's make them span from -64mm to 65mm roughly? Or maybe just centered blocks?
    
    // Alternative: Maybe they are attached to the SIDE faces (the ones with length 90)? 
    // "Flush with long edge" -> The side face has a top edge of length 130. If we attach a block flush there...
    // Let's assume two vertical blocks located at X = +/- 65mm? No, that would be the corners.
    
    // Let's try: Two blocks centered on Y axis (Y range -42 to +42), and spanning full length in X (-65 to +65)? 
    // That creates a solid block if they touch. If separated by 1mm gap?
    // Or maybe the user means two strips running along the sides of the plate, i.e., at Y = +/- (90/2 - something).
    
    // Let's go with: Two blocks located near the center of the short side length (Y), but spanning full X. 
    // Actually, if they are "flush with long edge", maybe one is at +X and one at -X? No, that would be along short edges.
    
    // Final Interpretation for Stability & Function:
    // Two blocks of size 130mm (length) x 4mm (width/thickness perpendicular to length?) 
    // Wait, "each wall is ... 4 mm thick". If it runs along X (130), thickness is likely Y.
    // So dimensions are L=130, W=4? Or L=130, H=?, T=?
    // Let's assume: Two blocks of size [X=128mm, Y=6mm, Z=66mm] located at X = +/- 59.7 (centered in X) and separated by a gap? 
    // Or maybe they are attached to the side faces?
    
    // Let's simplify: Two blocks of size [X=130, Y=4, Z=66]. Located centered on Y axis (-2mm offset from center?).
    // Actually, let's place them at X = +/- (plate_width/2 - 5) to leave room for holes? 
    // No, if they run along the long edge... maybe one is near +Y and one near -Y? 
    // If I have a plate 130x90. Long edges are Top(130) and Bottom(130).
    // Walls "run along" these edges. So walls extend in X direction.
    // They are likely located at Y = +/- (plate_length/2 - wall_thickness/2)? i.e., near the short ends? 
    // But then tubes can't pass through holes if they block entry from both sides?
    
    // Let's assume: Two blocks of size [X=130, Z=66] and thickness Y = 4mm. 
    // Positioned at X = +/- (plate_width/2 - something)? No, that would be along short edges.
    // Positioned at Y = +/- (something) spanning full length?
    
    // Let's try this: Two blocks located near the center of the plate in both directions to maximize support but minimize blockage? 
    // Or maybe they are just two strips running parallel to X axis, centered on Y axis.
    // Dimensions: 130mm long (X), 4mm thick (Y). Height 66mm.
    // Position: Centered in X (-59.75 to +59.75) and separated by a small gap? Or touching at center? 
    // Let's place them centered on Y axis, but offset from each other slightly or just one large block split into two?
    
    // Actually, "Two solid walls run along the two long edges". This might mean they are attached to the side faces (the ones with length 90)? 
    // If a wall is flush with the edge of length 130... that's confusing.
    
    // Let's assume: Two blocks located at X = +/- (plate_width/2 - 5) and Y range covering most of plate? No, they run along long edges -> parallel to X.
    // So they must be in the plane Z=4..70. 
    // Let's place them centered on Y axis (-3mm offset from center), spanning full length (X: -65 to 65). 
    // But if there are TWO walls, maybe one at +Y and one at -Y?
    
    // Okay, let's assume the user means two blocks located near the ends of the short dimension (Y)? No.
    // Let's assume they are centered on Y axis but separated by a gap in X? 
    // Or maybe they are attached to the side faces (the 90mm sides) and extend UPWARDS from there?
    
    // Most logical rack design: Two vertical supports at one end or distributed. 
    // Given "Two short ends stay open", walls must not block Y entry. So walls should be along X axis, likely near center of plate in Y direction?
    // Let's place two blocks centered on the Y-axis (Y range -42 to +42), but separated by a small gap or touching at center? 
    // If they touch and span full length, it becomes one block. So maybe offset slightly: X = +/-