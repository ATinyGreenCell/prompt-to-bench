// --- Dimensions ---
// Bore diameter (through the entire length)
BORE_DIA = 3.0;

// Section 1: 8mm tubing interface (z = 0 to z = 20)
// Total height of this section
S1_HEIGHT = 20;
// Number of barbs in this section
S1_BARBS = 2;
// Height of each individual barb
S1_BARB_H = 10;
// Bottom outer diameter of each barb (at the base of the barb)
S1_OD_BOTTOM = 7.5;
// Top outer diameter of each barb (at the tip of the barb)
S1_OD_TOP = 9.5;

// Section 2: Collar (z = 20 to z = 25)
// Height of the collar
COLLAR_H = 5;
// Diameter of the collar
COLLAR_DIA = 12;

// Section 3: 5mm tubing interface (z = 25 to z = 41)
// Total height of this section
S3_HEIGHT = 16;
// Number of barbs in this section
S3_BARBS = 2;
// Height of each individual barb
S3_BARB_H = 8;
// Bottom outer diameter of each barb (at the base of the barb)
S3_OD_BOTTOM = 6.5;
// Top outer diameter of each barb (at the tip of the barb)
S3_OD_TOP = 5.0;

// --- Parameters ---
// Ensure holes are round
$fn = 64;

// Helper module to create a single barb segment (frustum)
// z_offset: Z position of the bottom of this barb segment relative to origin
// d_bottom: Outer diameter at the bottom of this segment
// d_top: Outer diameter at the top of this segment
// h: Height of this segment
module barb_segment(z_offset, d_bottom, d_top, h) {
    r_bottom = d_bottom / 2;
    r_top = d_top / 2;
    
    // Create a cylinder with different top and bottom radii
    // center=false means it sits on z=0 in local coordinates
    translate([0, 0, z_offset]) {
        cylinder(h=h, r1=r_bottom, r2=r_top, center=false);
    }
}

// Build the outer shell
outer_shell = union() {
    // Section 1: 8mm tubing (z=0 to 20)
    // Two barbs, each 10mm high.
    // Barb 1: z=0 to 10. D: 7.5 -> 9.5
    // Barb 2: z=10 to 20. D: 7.5 -> 9.5
    
    // Barb 1
    barb_segment(0, S1_OD_BOTTOM, S1_OD_TOP, S1_BARB_H);
    
    // Barb 2
    barb_segment(S1_BARB_H, S1_OD_BOTTOM, S1_OD_TOP, S1_BARB_H);
    
    // Collar (z=20 to 25)
    // Diameter 12
    translate([0, 0, S1_HEIGHT]) {
        cylinder(h=COLLAR_H, r=COLLAR_DIA/2, center=false);
    }
    
    // Section 3: 5mm tubing (z=25 to 41)
    // Two barbs, each 8mm high.
    // Barb 1: z=25 to 33. D: 6.5 -> 5.0
    // Barb 2: z=33 to 41. D: 6.5 -> 5.0
    
    // Barb 3 (First in section 3)
    barb_segment(S1_HEIGHT + COLLAR_H, S3_OD_BOTTOM, S3_OD_TOP, S3_BARB_H);
    
    // Barb 4 (Second in section 3)
    barb_segment(S1_HEIGHT + COLLAR_H + S3_BARB_H, S3_OD_BOTTOM, S3_OD_TOP, S3_BARB_H);
};

// Final Part: Subtract the bore
// The bore runs through the full length (z=0 to z=41)
// We extend it slightly past the faces to ensure clean cuts
// Total height = 20 + 5 + 16 = 41
TOTAL_H = S1_HEIGHT + COLLAR_H + (S3_BARBS * S3_BARB_H);

difference() {
    outer_shell;
    
    // Bore
    // Extend 0.1mm past bottom and top
    cylinder(h=TOTAL_H + 0.2, r=BORE_DIA/2, center=false);
}