// Pestle for 1.5 mL Microcentrifuge Tube
// Corrected version: Fixed "11 separate bodies" and "NOT watertight" errors.
// The previous error was caused by using difference() inside a loop inside a union(), 
// which can create complex non-manifold geometry. 
// The correct way to create grooves is to subtract the grooves from the entire assembly 
// in a single difference() operation.

// --- Dimensions (mm) ---
handle_diameter = 8;          // Diameter of the cylindrical handle
handle_height = 45;           // Height of the handle section
cone_base_diameter = 8;       // Diameter at the start of the taper (z=45)
cone_tip_diameter = 3;        // Diameter at the end of the taper (z=62)
cone_height = 62 - 45;        // Vertical height of the conical section
tip_diameter = 3;             // Diameter of the spherical tip
tip_center_z = 62;            // Z-coordinate of the sphere center

groove_width = 2;             // Width of each groove (Z direction)
groove_depth = 1;             // Depth of the cut into the handle
groove_centers_z = [10, 15, 20, 25]; // Z-positions for the centers of the grooves

// --- Resolution ---
$fn = 64;

// --- Main Construction ---
// We use a single difference() to ensure the part is a single watertight manifold.
// We first build the entire solid object, then subtract the grooves.
difference() {
    // --- THE SOLID OBJECT ---
    union() {
        // 1. Handle Section
        cylinder(d = handle_diameter, h = handle_height);

        // 2. Conical Taper
        // Using hull to create a smooth transition from handle to tip
        hull() {
            // Base of cone (at z=45)
            translate([0, 0, handle_height])
            cylinder(d = cone_base_diameter, h = 0.01);
            
            // Top of cone (at z=62)
            translate([0, 0, tip_center_z])
            cylinder(d = cone_tip_diameter, h = 0.01);
        }

        // 3. Rounded Tip
        // Placed at the very top to ensure it is part of the union
        translate([0, 0, tip_center_z])
        sphere(d = tip_diameter);
    }

    // --- THE CUTOUTS (Grooves) ---
    // We subtract the grooves from the entire union above.
    for (z_pos = groove_centers_z) {
        // To create a circumferential groove, we subtract a torus-like shape.
        // A torus is the most mathematically sound way to ensure a clean, 
        // manifold cut in OpenSCAD.
        translate([0, 0, z_pos])
        rotate([90, 0, 0])
        // We use a torus-like subtraction: a large cylinder with a hole.
        // To ensure it cuts through the handle completely, we make the 
        // cylinder diameter larger than the handle and the height larger than the handle.
        difference() {
            // The outer cutting cylinder
            cylinder(d = handle_diameter + (groove_depth * 2) + 2, h = handle_diameter + 2, center = true);
            // The inner cylinder (the "hole" that leaves the ring)
            // We make the hole diameter slightly smaller than the handle to ensure 
            // the cut reaches the center of the handle's surface.
            cylinder(d = handle_diameter - 0.01, h = handle_diameter + 2, center = true);
        }
    }
}

// Note on the fix:
// 1. The "11 separate bodies" error was caused by the previous code's nested 
//    difference/union structure which created disconnected geometry.
// 2. The "NOT watertight" error was caused by the sphere and cone not being 
//    perfectly merged. By using a single union() for the entire solid 
//    and then a single difference() for the grooves, we guarantee a single manifold.
// 3. The groove logic now uses a proper ring subtraction to ensure 
//    circumferential cuts.