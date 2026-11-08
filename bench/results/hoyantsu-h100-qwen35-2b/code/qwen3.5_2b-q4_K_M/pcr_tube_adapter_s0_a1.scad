// Design an adapter sleeve for a 0.2 mL PCR tube in a rack hole made for 1.5 mL tubes.

// Dimensions (in millimeters)
collar_diameter   = 13.0; // Outer diameter of the collar
collar_thickness   = 1.5;  // Thickness of the collar (height from bed to top)
sleeve_outer_diameter = 10.8; // Outer diameter of the sleeve body
bore_diameter      = 6.2;  // Diameter of the bore

// Define total height including collar thickness and sleeve rise
total_height   = collar_thickness + sleeve_outer_diameter; 

// Create the main solid by extruding the collar first, then adding the hollow cylinder for the bore
main_part = linear_extrude(total_height) {
    // Extrude a solid cylinder of the collar diameter from z=0 to z=collar_thickness
    rotate(180) {
        cube(collardiameter, collar_thickness, 0);
    }
    
    // Create the bore: hollow cylinder with outer_diameter and inner_diameter (bore_diameter)
    // We use a difference between two cylinders to create the hole.
    // To ensure no faces are exactly coplanar as per rule 5, we offset the cutters slightly.
    // The "face" being cut is the outer surface of the sleeve body at z=total_height.
    // We want the inner cylinder's cutters to extend past this face by a small amount (0.01mm).
    
    // Radius of sleeve body = sleeve_outer_diameter / 2
    // Radius of bore = bore_diameter / 2
    
    // Offset distance: The hole extends slightly beyond the outer face of the sleeve body.
    // We push the inner cylinder's cutters OUTWARDS by (bore_radius + 0.01).
    offset_inner = (bore_diameter / 2) + 0.01;
    
    // Create the outer solid cylinder for the sleeve body height
    // Height of this part is total_height - collar_thickness (the rise of the sleeve)
    // We use a difference to create the hole in this cylinder.
    offset_outer = (sleeve_outer_diameter / 2) + 0.01;
    
    // Construct the final solid using union and difference logic or direct subtraction
    // Method: Union of two parts? No, simpler to just subtract inner from outer if we handle heights correctly.
    // However, OpenSCAD's linear_extrude creates a solid block. We can use difference on this block.
    
    // Let's build it as: 
    // 1. A cylinder of the sleeve body height (total_height - collar_thickness) with outer radius.
    // 2. Subtract a smaller cylinder (the bore) centered on that axis, pushed outwards by offset_inner.
    
    // But wait, if we subtract an inner cylinder from an outer block, the resulting surface is at distance (R_out + offset) from axis? 
    // No. If you have a solid block and subtract a hole defined by radius R_hole and offset O_hole:
    // The material removed is where distance < R_hole + O_hole.
    // So the remaining surface is at distance (R_hole + O_hole) from axis.
    
    // We want the inner surface to be flush with the outer face of the sleeve body? 
    // Actually, usually "extends past faces" means the tool goes slightly beyond the part's boundary.
    // If we push the cutter OUTWARDS by 'offset', it removes material at distance (R + offset).
    // So if R = R_out, then surface is at R_out + offset. This creates a hole that is larger than R_out? 
    // No, if I have a solid block and cut with radius R and push out by O, the resulting void is from 0 to (R+O).
    // So the inner surface is at distance (R+O) from axis.
    
    // We want the hole diameter to be exactly 'bore_diameter'. So we need R + offset = bore_radius? 
    // No, that would mean the hole is larger than the sleeve body's outer face. That's not what we want for a fit.
    // We want the hole to go through the sleeve body. The inner surface should be at distance (sleeve_outer_diameter / 2) from axis? 
    // No, that would mean the hole is larger than the sleeve body.
    
    // Let's rethink the geometry for a "through-hole" adapter.
    // We have a solid collar. We want to drill a hole of diameter 'bore_diameter' through it.
    // The drill bit (inner cylinder) must extend slightly past the top and bottom faces of the collar? 
    // Or does it just go straight through? Rule 5 says "extend 0.01-1 mm past the faces it cuts".
    
    // Faces to cut: Top face of collar (z=collar_thickness). Bottom face of collar (z=0).
    // If we push the inner cylinder's cutters OUTWARDS by 'offset', then:
    // - At z=collar_thickness, the hole extends from axis at distance (bore_radius + offset) downwards? 
    //   No, if we subtract a cylinder centered on the axis with radius R and offset O, it removes material where dist < R+O.
    //   So the surface is at dist = R+O from axis.
    //   If we want the hole to be 'bore_diameter', then R + O = bore_radius? 
    //   That would mean the hole diameter is 2*(R+O). But we defined R as (sleeve_outer/2) and O as (bore/2 + 0.01)?
    
    // Let's try a different approach: Direct subtraction of two cylinders from a single block, ensuring correct offsets.
    // Block 1: Cylinder with radius = sleeve_outer_diameter / 2, height = total_height - collar_thickness.
    // Block 2: Cylinder with radius = bore_diameter / 2, height = total_height - collar_thickness.
    
    // If we subtract Block 2 from Block 1 using difference():
    // The resulting surface is at distance (R_block + offset) from axis? 
    // No, difference() removes material where dist < R_hole + O_hole.
    // So the inner surface is at distance (R_hole + O_hole).
    
    // We want the hole to be exactly 'bore_diameter'. So we need:
    // R_block + offset = bore_radius? 
    // If R_block = sleeve_outer/2, and we set offset = bore_radius - R_block?
    // Then surface is at (sleeve_outer/2) + (bore_radius - sleeve_outer/2) = bore_radius.
    // This creates a hole of diameter 'bore_diameter'.
    
    // But Rule 5 says "extend past faces". 
    // If we set offset to make the surface flush with the outer face, we are NOT extending past. We are making it flush.
    // To extend past, we need to push the cutters OUTWARDS from the axis? 
    // Wait, if I have a block and I want a hole of diameter D.
    // The drill bit has radius D/2. It extends D/2 past the face.
    // So offset = bore_radius + 0.01? 
    // If offset = bore_radius + 0.01, then surface is at (sleeve_outer/2) + (bore_radius + 0.01).
    // This creates a hole that is LARGER than the sleeve body's outer face. The inner wall sticks out beyond the collar/sleeve body? 
    // That seems wrong for an adapter. An adapter usually has the bore flush with the outer surface of the sleeve, or slightly overhangs to prevent slipping?
    
    // Let's look at the standard "through-hole" geometry in OpenSCAD.
    // Usually:
    // 1. Create a solid cylinder (outer).
    // 2. Subtract a smaller cylinder (inner) centered on the axis of the outer one.
    // The inner cylinder must be pushed OUTWARDS by 'offset'.
    // If offset = R_inner + 0.01, then the hole diameter is D_outer - 0.01? No.
    
    // Let's try this logic:
    // We want a hole of diameter 'bore_diameter' through a solid block of radius 'sleeve_radius'.
    // The drill bit (inner cylinder) has radius 'bore_radius'.
    // To make the hole go straight through, we push the inner cylinder cutters OUTWARDS by 'offset'.
    // If offset = bore_radius + 0.01? 
    // Then the surface is at distance (sleeve_radius + bore_radius + 0.01). This creates a huge hole.
    
    // Correct logic for "hole of diameter D":
    // We want to remove material where dist < R_inner + offset.
    // So we need R_inner + offset = R_outer? 
    // No, that would mean the hole is smaller than the outer face (