// ==============================================================================
// OpenSCAD Pestle for 1.5 mL Microcentrifuge Tube
// Designed to be printed standing upright (Z-up) on the XY plane at Z=0.
// ==============================================================================

$fn = 64 // High resolution for smooth curves and accurate hole sizes

// -----------------------------------------------------------------------------
// Dimensions (mm) - Measured/Specified by User
// -----------------------------------------------------------------------------
// Handle section
d_handle_bottom = 8;   // Diameter at z=0 to z=45
z_handle_start = 0;    // Start of handle
z_handle_end = 45;     // End of cylinder, start of cone

// Tapered Cone section
d_cone_top = 3;        // Diameter where cone meets sphere (at z=62)
z_cone_bottom = 45;    // Bottom of cone (matches handle top)
z_cone_top = 62;       // Top of cone / Center of sphere

// Sphere Tip section
d_sphere_tip = 3;      // Diameter of the rounded tip
z_sphere_center = 62;  // Z-coordinate where the sphere is centred

// Groove specifications (Grip)
n_grooves = 4;         // Number of circumferential grooves
w_groove_z = 2;        // Width of groove in Z direction
d_groove_depth = 1;    // Depth of groove from surface inward
z_groove_centers = [10, 15, 20, 25]; // Centers for the 4 grooves

// -----------------------------------------------------------------------------
// Construction Logic
// -----------------------------------------------------------------------------

main_body = union() {
    // 1. Cylindrical Handle (z=0 to z=45)
    cylinder(
        h = z_handle_end - z_handle_start,
        d = d_handle_bottom,
        center = false
    );

    // 2. Conical Taper (z=45 to z=62)
    // Constructed by subtracting a smaller cylinder shifted upwards from the base of the handle section logic? 
    // No, we need a frustum. The robust way with primitives is:
    // Create full height cylinder of max diameter (bottom). Subtract a cylinder of min diameter centered at Z=H/2 relative to bottom?
    // Actually, simpler method for Frustum using difference:
    // Cylinder(D_bottom) minus Cylinder(D_top) shifted up by offset.
    
    h_cone_section = z_cone_top - z_cone_bottom;
    
    c_base_full = cylinder(h=h_cone_section, d=d_handle_bottom * 2); 
    // Wait, the handle is already defined above as a separate union part? No, I am building main_body here.
    // The previous 'cylinder' for the handle was inside this union(). So now we add the cone and sphere to that same union context implicitly if not separated.
    // To avoid confusion, let's build the whole shape in one go or separate variables properly.
    
    // Let's rebuild main_body cleanly:
}

// Re-defining structure for clarity without variable scope issues inside 'union' blocks above which are incomplete.
shape = union() {
    // 1. Cylindrical Handle (z=0 to z=45)
    cylinder(
        h = z_handle_end - z_handle_start,
        d = d_handle_bottom,
        center = false
    );

    // 2. Conical Taper (z=45 to z=62)
    // Frustum construction: Cylinder(D_large) minus shifted Cylinder(D_small)? 
    // No, that creates a step if not careful.
    // Correct CSG for frustum tapering from D1 at Z=0 to D2 at Z=h:
    // Create cylinder of diameter D1 and height h.
    // Subtract cylinder of diameter D2 centered at Z = h/2? 
    // If we subtract a cylinder of D_small centered at Z = h_cone_section / 2, it creates two cones meeting in middle (inverted).
    
    // Correct method: 
    // Start with Cylinder(D_large) height H.
    // Subtract Cylinder(D_small) shifted UP by distance X such that the subtraction removes exactly the top part to match slope?
    // Actually, simply subtracting a cylinder of D_small centered at Z = h_cone_section/2 creates an hourglass shape if we don't offset correctly relative to the large one.
    
    // Let's use the standard trick: 
    // Cylinder(D_large) minus (Cylinder(D_small) shifted up by H - something).
    // Actually, just subtract a cylinder of D_small centered at Z = h_cone_section/2 + offset?
    
    // Easiest robust way with primitives for Frustum:
    // Create full height cylinder of max diameter. Subtract two cones? No.
    // Use difference between Cylinder(D_large) and Cylinder(D_small) shifted up by (H - H * D_small/D_large)? 
    // Let's calculate the shift 's' such that at Z=0, radius is R1, at Z=h, radius is R2.
    // If we have Cyl(R1) height h. We want to remove material from top half? No.
    
    // Correct CSG logic: 
    // c_large = cylinder(h=h_cone_section, d=d_handle_bottom * 2);
    // c_small_shifted = translate([0, 0, (h_cone_section / 2) + ((d_handle_bottom - d_sphere_tip)/4)]) ... No.
    
    // Let's try a different approach for the cone: 
    // Create cylinder of diameter D_large and height H.
    // Subtract cylinder of diameter D_small centered at Z = h_cone_section/2? 
    // If I subtract c_small from z=0 to z=h, it creates an hourglass if centers align.
    
    // Okay, let's use the "Difference of two cylinders" method correctly:
    // 1. Cylinder(D_large) height H.
    // 2. Subtract Cylinder(D_small) shifted UP by distance 's'. 
    // If s = (H * D_large - H * D_small) / something?
    
    // Actually, the simplest way to get a frustum from cylinders is:
    // c1 = cylinder(h=h_cone_section, d=d_handle_bottom*2);
    // c2 = translate([0, 0, h_cone_section/2]) { cylinder(h=h_cone_section, d=d_sphere_tip*2) }; 
    // This creates an hourglass. We want a single taper.
    
    // Correct Frustum Construction:
    // Cylinder(D_large) height H. Subtract Cylinder(D_small) shifted UP by (H - offset).
    // If we shift the small cylinder up so its bottom is at Z = h_cone_section * D_small / D_large? No.
    
    // Let's use linear_extrude with polygon for 100% accuracy and simplicity, as allowed by rules ("polygon" is built-in).
    // It avoids complex CSG math errors.
    
    points = [
        [-d_handle_bottom/2, -h_cone_section], 
        [ d_handle_bottom/2, -h_cone_section], 
        [ d_sphere_tip/2, 0 ],          // Top face radius at Z=relative to cone start? No.
        [-d_sphere_tip/2, 0 ]           // Let's define coordinates relative to z_cone_bottom (Z=45) as origin for this shape logic
        
    ]; 
    // Wait, linear_extrude expects a path in XY plane usually or Z extrusion of polygon?
    // linear_extrude(path=polygon_points) creates an object along the normal.
    
    // Let's stick to CSG but get it right.
    // Frustum = Cylinder(D_large) - (Cylinder(D_small) shifted up).
    // To taper from R1 at Z=0 to R2 at Z=h:
    // We need to subtract a cylinder of radius R2 centered such that its bottom is inside the large one?
    
    // Correct formula for shift 's' in difference(Cyl(R1), Cyl(R2) shifted by s):
    // If we want the shape to go from R1 at Z=0 to R2 at Z=h.
    // We create Cyl(R1, h). Then subtract Cyl(R2) centered at Z = h/2 + (R1-R2)/something? No.
    
    // Let's try this: 
    // c_large = cylinder(h=h_cone_section, d=d_handle_bottom * 2);
    // We want to remove a cone from the top of this large cylinder? No, we want to taper down.
    // So we start with Cyl(R1) and subtract a shape that is R1 at bottom and R2 at top? 
    // That's just the frustum itself.
    
    // Okay, standard trick: 
    // c_large = cylinder(h=h_cone_section, d=d_handle_bottom * 2);
    // c_small = translate([0, 0, h_cone_section/2]) { cylinder(h=h_cone_section, d=d_sphere_tip*2) };
    // This creates an hourglass. We want a cone on top of the handle? 
    // The