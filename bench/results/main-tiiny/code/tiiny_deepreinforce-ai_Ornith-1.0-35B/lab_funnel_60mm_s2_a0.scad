// Lab funnel - printed upright (spout down, wide opening up)
// Dimensions measured with calipers

// Overall height
H_FUNNEL = 50;

// Spout dimensions
H_SPOUT = 20;
OD_SPOUT = 10;

// Cone (funnel body) dimensions
OD_RIM = 60;
H_CONE = H_FUNNEL - H_SPOUT; // 30 mm

// Wall thickness
T_WALL = 1.6;

// Derived dimensions
ID_SPOUT = OD_SPOUT - 2 * T_WALL; // 6.8 mm bore
ID_RIM = OD_RIM - 2 * T_WALL;     // 56.8 mm inner rim diameter

// Print orientation: rests on XY plane at z=0, builds upward

// Outer shape: spout cylinder + cone
difference() {
    // Outer solid (spout + cone)
    union() {
        // Spout cylinder
        cylinder(h = H_SPOUT, d = OD_SPOUT, center = false);
        
        // Cone: bottom at z=H_SPOUT, top at z=H_FUNNEL
        // Use linear_extrude of a triangle, or two stacked cylinders approximation
        // Better: use a single cone via cylinder with different top/bottom radii
        cylinder(h = H_CONE, d1 = OD_SPOUT, d2 = OD_RIM, center = false, 
                 translate = [0, 0, H_SPOUT]);
    }
    
    // Inner bore (spout + cone) - extend slightly past faces
    union() {
        // Spout bore
        cylinder(h = H_SPOUT + 0.01, d = ID_SPOUT, center = false);
        
        // Cone bore: extends from z=H_SPOUT to z=H_FUNNEL+0.01
        cylinder(h = H_CONE + 0.01, d1 = ID_SPOUT, d2 = ID_RIM, center = false,
                 translate = [0, 0, H_SPOUT - 0.01]);
    }
}