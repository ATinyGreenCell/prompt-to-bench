// --- Dimensions ---
handle_diam = 8;        // Handle diameter (mm)
handle_len = 45;        // Handle length from z=0 to z=45 (mm)
cone_bottom_diam = 8;   // Cone bottom diameter at z=45 (mm)
cone_top_diam = 3;      // Cone top diameter at z=62 (mm)
cone_len = 17;          // Cone length (62 - 45) (mm)
tip_diam = 3;           // Tip sphere diameter (mm)
tip_center_z = 62;      // Tip sphere center Z position (mm)

// Groove dimensions
groove_width = 2;       // Groove width in Z (mm)
groove_depth = 1;       // Groove depth (mm)
num_grooves = 4;        // Number of grooves

// Groove center positions
groove_centers = [10, 15, 20, 25]; // Z positions for groove centers (mm)

// --- Calculated Values ---
handle_r = handle_diam / 2;
cone_bottom_r = cone_bottom_diam / 2;
cone_top_r = cone_top_diam / 2;
tip_r = tip_diam / 2;

// Groove cutting parameters
// The groove reduces the radius by 'groove_depth'.
// We cut using a cylinder with radius slightly larger than the resulting groove radius
// to ensure the cut is clean and extends past the intended surface.
groove_inner_r = handle_r - groove_depth;
// Add a small extension to the cutter radius to ensure it cuts through the full depth
// and avoids coplanar faces.
groove_cut_r = groove_inner_r + 0.05;

// --- Main Body ---
module pestle_body() {
    // 1. Handle: Cylinder from z=0 to z=45
    cylinder(h=handle_len, d=handle_diam, center=false, $fn=64);
    
    // 2. Cone: Tapers from 8mm at z=45 to 3mm at z=62
    // The cylinder function in OpenSCAD builds from z=0 upwards.
    // We place the bottom of the cone at z=45.
    cylinder(h=cone_len, d1=cone_bottom_diam, d2=cone_top_diam, center=false, $fn=64);
    
    // 3. Tip: Sphere centered at z=62
    // The sphere is centered at (0,0,62).
    // We need to ensure it connects smoothly. The cone ends at diameter 3mm at z=62.
    // The sphere has diameter 3mm, so it touches the cone base perfectly.
    // Since we are using union(), exact contact is fine.
    translate([0, 0, tip_center_z]) {
        sphere(d=tip_diam, $fn=64);
    }
}

// --- Groove Cutting Module ---
module groove_cut(z_center) {
    // Cut a groove of width 'groove_width' and depth 'groove_depth'
    // The cut must extend past the surface of the handle to ensure clean boolean subtraction.
    // We use a cylinder with radius slightly larger than the inner radius of the groove.
    // The cylinder height must cover the groove width plus a small extension to avoid coplanar faces.
    
    z_min = z_center - (groove_width / 2) - 0.01;
    z_max = z_center + (groove_width / 2) + 0.01;
    cutter_h = z_max - z_min;
    
    // The cutter cylinder is centered at z_center, with height covering the groove.
    // Radius is set to cut slightly into the handle to ensure the full depth is achieved.
    translate([0, 0, z_center]) {
        cylinder(h=cutter_h, d=2*groove_cut_r, center=true, $fn=64);
    }
}

// --- Final Assembly ---
// Start with the main body
difference() {
    pestle_body();
    
    // Subtract the grooves
    for (z_pos = groove_centers) {
        groove_cut(z_pos);
    }
}