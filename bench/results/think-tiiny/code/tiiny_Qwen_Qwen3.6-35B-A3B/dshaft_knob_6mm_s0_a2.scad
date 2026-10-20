$fn = 64;

// --- Dimensions ---
R_KNOB      = 15;       // Knob radius (30 mm diameter)
H_KNOB      = 15;       // Knob height
R_BORE      = 3.1;      // Bore radius (6.2 mm diameter)
H_BORE      = 12;       // Bore depth
X_FLAT      = -1.6;     // X position of D-shaft flat (3.1 - 4.7)
NUM_GROOVES = 18;       // Number of grip grooves
R_GROOVE    = 1;        // Groove radius (2 mm diameter)
W_POINTER   = 1.5;      // Pointer groove width
D_POINTER    = 1;        // Pointer groove depth

// --- Main Model ---
difference() {
    // Solid cylinder body
    cylinder(r=R_KNOB, h=H_KNOB, center=false);
    
    // D-shaped blind bore
    // Cuts the left side of the bore circle to create the flat face
    translate([X_FLAT - 0.01, -4, 0]) 
        cube([10, 8, H_BORE + 0.01]);
        
    // 18 evenly spaced grip grooves
    for (i = [0 : NUM_GROOVES - 1]) {
        theta = i * (360 / NUM_GROOVES);
        translate([R_KNOB * cos(theta), R_KNOB * sin(theta), 0]) {
            rotate([0, 0, 90]) {
                // Half-cylinder groove: flat face on +X, cuts inward
                difference() {
                    cylinder(r=R_GROOVE, h=H_KNOB + 0.01, center=false);
                    translate([0.01, -1, 0]) cube([10, 2, H_KNOB + 0.01]);
                }
            }
        }
    }
    
    // Pointer groove on top face
    // Spans from centre (x=0) to outer edge (x=-15), centered at x=-7.5
    translate([-7.5, 0, H_KNOB - D_POINTER + 0.505]) 
        cube([15.1, W_POINTER, D_POINTER + 0.01]);
}