// 10-well agarose gel comb
// Designed for FDM printing, lying flat on the XY plane.

// --- Dimensions ---
spine_l     = 70.0;    // Length of the spine (X)
spine_w     = 12.0;    // Width of the spine (Y)
plate_t     = 1.5;     // Thickness of the plate (Z)
tooth_w     = 5.0;     // Width of each tooth (X)
tooth_l     = 12.0;    // Length of each tooth (Y)
gap         = 1.5;     // Gap between teeth
num_teeth   = 10;      // Number of teeth

$fn = 64;

// --- Calculations ---
// Total width of the teeth array (from start of first tooth to end of last)
// Total X = (num_teeth * tooth_w) + ((num_teeth - 1) * gap)
total_teeth_x = (num_teeth * tooth_w) + ((num_teeth - 1) * gap);

// Offset to center the teeth array along the X axis of the spine
x_offset = (spine_l - total_teeth_x) / 2;

// The teeth hang from one long edge in the -Y direction.
// The spine is centered on Y, so its edges are at +/- spine_w / 2.
// The teeth extend from the edge (spine_w/2) to (spine_w/2 + tooth_l).
// However, the prompt says "hang from one long edge... in the -Y direction".
// To keep the part centered on the origin in X and Y:
// Spine Y range: [-spine_w/2, spine_w/2]
// Teeth Y range: [-spine_w/2 - tooth_l, -spine_w/2]

module comb() {
    difference() {
        // Main Body: The spine and the teeth combined
        union() {
            // The Spine
            translate([-spine_l/2, -spine_w/2, 0])
                cube([spine_l, spine_w, plate_t]);
            
            // The Teeth
            for (i = [0 : num_teeth - 1]) {
                // Calculate X position for this tooth
                tx = x_offset + (i * (tooth_w + gap));
                
                // Translate to position: 
                // X is centered, Y is attached to the edge of the spine
                translate([tx - tooth_w/2, -spine_w/2 - tooth_l, 0])
                    cube([tooth_w, tooth_l, plate_t]);
            }
        }

        // The Wells (the holes cut into the teeth)
        // To create a "comb", we subtract rectangular volumes from the teeth.
        // The prompt implies the teeth ARE the wells. 
        // In gel casting, the "teeth" are the protrusions that create the wells.
        // Therefore, the "teeth" are the solid parts, and the space between them 
        // is where the gel forms. 
        // However, a "comb" usually refers to the tool that creates the wells.
        // If the teeth are the solid parts, the wells are the gaps.
        // To make a functional comb, we need to subtract the "well" volume 
        // from the teeth so that the gel can be poured into the gaps.
        // Wait, the prompt says "10 rectangular teeth that hang from one long edge".
        // This describes the physical shape of the plastic.
        // To make it a "comb", the teeth are the dividers.
        // To make the wells, we need to subtract the volume of the wells from the teeth.
        // But the prompt doesn't specify well dimensions, only tooth dimensions.
        // In standard terminology, the "teeth" are the solid parts.
        // I will model the teeth as solid volumes as described.
        
        // If the user meant the teeth are the wells, they would have specified well depth.
        // I will assume the teeth are the solid dividers.
    }
}

// Final Assembly
// We use a union of the spine and teeth. 
// To ensure it's a single solid, we use union.
union() {
    // Spine
    translate([-spine_l/2, -spine_w/2, 0])
        cube([spine_l, spine_w, plate_t]);
    
    // Teeth
    for (i = [0 : num_teeth - 1]) {
        tx = x_offset + (i * (tooth_w + gap));
        translate([tx - tooth_w/2, -spine_w/2 - tooth_l, 0])
            cube([tooth_w, tooth_l, plate_t]);
    }
}