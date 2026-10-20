// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack hole
// Dimensions in mm

// --- Collar dimensions (base on print bed) ---
collar_diameter = 13;       // Outer diameter of the collar
collar_height = 1.5;        // Height of the collar (z=0 to z=1.5)

// --- Sleeve body dimensions ---
sleeve_outer_diameter = 10.8; // Outer diameter of the sleeve body
sleeve_top_z = 21.5;          // Total height of the part (z=0 to z=21.5)
sleeve_body_height = sleeve_top_z - collar_height; // Height of the cylindrical body above collar

// --- Bore dimensions ---
bore_diameter = 6.2;          // Inner diameter of the through-hole

// --- Print orientation ---
// The part rests on the XY plane at z=0.
// Collar is at the bottom (z=0 to z=1.5).
// Sleeve body rises from z=1.5 to z=21.5.
// Centered on origin in X and Y.

// Calculate radii
collar_radius = collar_diameter / 2;
sleeve_outer_radius = sleeve_outer_diameter / 2;
bore_radius = bore_diameter / 2;

// Safety margin for boolean operations to avoid coplanar faces
cut_margin = 0.02;

// --- Build the part ---
module adapter_sleeve() {
    union() {
        // 1. The Collar (Base)
        // Cylinder centered at origin, radius collar_radius, height collar_height
        cylinder(r = collar_radius, h = collar_height, center = false, $fn = 64);

        // 2. The Sleeve Body
        // Cylinder sitting on top of the collar, from z=1.5 to z=21.5
        // Height is sleeve_body_height
        // Radius is sleeve_outer_radius
        translate([0, 0, collar_height]) {
            cylinder(r = sleeve_outer_radius, h = sleeve_body_height, center = false, $fn = 64);
        }

        // 3. The Bore (Hole)
        // A cylinder subtracted from the union.
        // It must run through the full height (0 to 21.5).
        // To ensure clean cutting without coplanar issues, we extend it slightly.
        // We use a single cylinder for the hole, extending past both ends.
        hole_height = sleeve_top_z + cut_margin * 2;
        hole_center_z = sleeve_top_z / 2;
        
        // Subtract the bore
        // Note: In OpenSCAD, we perform the difference outside the union or use a separate module.
        // Here, we build the solid first, then subtract.
    }
}

// Final assembly with boolean difference
difference() {
    // Solid part
    adapter_sleeve();

    // Cutting tool for the bore
    // Extends from z = -cut_margin to z = sleeve_top_z + cut_margin
    cylinder(
        r = bore_radius, 
        h = sleeve_top_z + cut_margin * 2, 
        center = false, 
        $fn = 64
    );
}