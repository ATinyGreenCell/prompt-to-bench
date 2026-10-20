// Dimensions
COLLAR_OD = 13;            // Outer diameter of the bottom collar
COLLAR_THICK = 1.5;        // Thickness of the bottom collar
SLEEVE_OD = 10.8;          // Outer diameter of the sleeve body
SLEEVE_HEIGHT = 21.5;      // Total height of the sleeve from the bed
BORE_DIA = 6.2;            // Inner bore diameter for the 0.2 mL tube
BORE_EXTEND = 0.1;         // Extra length for the cutting cylinder to ensure open ends

$fn = 64;

difference() {
    // Main solid body
    union() {
        cylinder(d = COLLAR_OD, h = COLLAR_THICK, center = false);
        cylinder(d = SLEEVE_OD, h = SLEEVE_HEIGHT, center = false);
    }
    // Through bore
    cylinder(d = BORE_DIA, h = SLEEVE_HEIGHT + BORE_EXTEND, center = false);
}