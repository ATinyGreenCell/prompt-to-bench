// Dimensions
COLLAR_OD = 13;       // Outer diameter of the base collar
COLLAR_THICK = 1.5;   // Thickness of the base collar
SLEEVE_OD = 10.8;     // Outer diameter of the sleeve body
SLEEVE_TOP_Z = 21.5;  // Total height of the sleeve (from z=0)
BORE_D = 6.2;         // Inner bore diameter

// Calculated dimensions
COLLAR_R = COLLAR_OD / 2;
SLEEVE_R = SLEEVE_OD / 2;
BORE_R = BORE_D / 2;
SLEEVE_BODY_H = SLEEVE_TOP_Z - COLLAR_THICK;

// Print orientation: Collar on bed (z=0 to 1.5), sleeve rises to z=21.5
// Centered on XY origin.

module adapter_sleeve() {
    // Define the solid body as a union of the collar and the sleeve body
    solid_body = union() {
        // 1. The base collar (rests on the bed)
        cylinder(r = COLLAR_R, h = COLLAR_THICK, center = false);
        
        // 2. The sleeve body
        // Rises from the top of the collar (z = 1.5) to z = 21.5
        translate([0, 0, COLLAR_THICK]) {
            cylinder(r = SLEEVE_R, h = SLEEVE_BODY_H, center = false);
        }
    };

    // 3. Cut the bore
    // Runs through the full height (z=0 to z=21.5).
    // Extend the cutting cylinder slightly past the faces to ensure clean holes.
    $fn = 64;
    difference() {
        solid_body;
        
        // The cutting bore
        // Extends from -0.05 to 21.55 (total height 21.6)
        translate([0, 0, -0.05]) {
            cylinder(r = BORE_R, h = SLEEVE_TOP_Z + 0.1, center = false);
        }
    }
}

adapter_sleeve();