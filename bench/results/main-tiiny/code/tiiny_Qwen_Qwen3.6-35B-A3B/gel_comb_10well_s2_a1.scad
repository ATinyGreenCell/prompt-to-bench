$fn = 64;

// Dimensions
spine_len = 70;
spine_wid = 12;
plate_thk = 1.5;

tooth_w = 5.0;
tooth_l = 12;
gap_w = 1.5;
num_teeth = 10;

// Calculated
// Total width of teeth array
total_tooth_width = num_teeth * tooth_w + (num_teeth - 1) * gap_w;

// Spine center at 0,0
// Spine X: -spine_len/2 to spine_len/2
// Spine Y: -spine_wid/2 to spine_wid/2

// Teeth Y: hang from -spine_wid/2
// Tooth Y range: -spine_wid/2 - tooth_l to -spine_wid/2
// To ensure union, let's overlap by 0.01mm
overlap = 0.01;

// Start X of the first tooth's left edge
// Centered at 0
start_x = -total_tooth_width / 2;

union() {
    // Spine
    translate([0, 0, 0]) {
        cube([spine_len, spine_wid, plate_thk], center=false);
    }
    
    // Teeth
    for (i = [0 : num_teeth - 1]) {
        // X position of the left edge of the tooth
        x_pos = start_x + i * (tooth_w + gap_w);
        
        // Y position: top of tooth is at -spine_wid/2
        // Bottom of tooth is at -spine_wid/2 - tooth_l
        // Overlap into spine: extend top by overlap
        y_top = -spine_wid/2;
        y_bot = -spine_wid/2 - tooth_l;
        
        translate([x_pos + tooth_w/2, y_top, 0]) {
            // Center the cube in X, but Y is top-aligned
            // Cube size: tooth_w x tooth_l x plate_thk
            // To overlap, we shift Y down slightly? 
            // If cube is [0, tooth_l] in Y relative to translate, it goes from 0 to -tooth_l?
            // No, cube is positive.
            // Let's use translate to position the top-left corner of the tooth (in local coords)
            // Local Y: 0 to -tooth_l? No, cube is positive.
            // Let's define tooth as Y: 0 to tooth_l, then translate Y to -spine_wid/2 - tooth_l?
            // No, let's keep it simple.
            
            // Tooth local coords:
            // X: 0 to tooth_w
            // Y: 0 to tooth_l
            // Z: 0 to plate_thk
            
            // We want the top edge (Y=0) to be at spine bottom (Y = -spine_wid/2).
            // And we want it to overlap into the spine, so Y=0 should be at -spine_wid/2 - overlap?
            // No, if the spine is Y [-6, 6], and tooth is Y [-6, -18], they touch.
            // If we shift tooth Y up by overlap, it becomes [-6+overlap, -18+overlap]? No.
            // Let's shift the tooth DOWN into the spine?
            // Spine Y: [-6, 6].
            // Tooth Y: [-6, -18].
            // Overlap: Tooth Y: [-6 - overlap, -18 - overlap]? No, that moves it away.
            // Tooth Y: [-6, -18] touches spine.
            // To overlap, Tooth Y: [-6 - 0.01, -18 - 0.01] would mean top is at -6.01, which is INSIDE the spine (since spine goes to -6).
            // Yes. So Y range of