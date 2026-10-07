// Adapter Sleeve for PCR Tube (fits into 1.5mL rack hole)
// Print Orientation: Upside down on bed
// Collar lies flat on Z=0 to Z=1.5mm
// Body rises from collar top to total height of 21.5mm

$fn = 64 // Ensure smooth curves for holes and cylinders

// --- Dimensions (User Measured) ---
$d_collar_outer   = 13;    // Collar outer diameter at bottom
$t_collar         = 1.5;   // Collar thickness (height from bed)
$d_body_outer     = 10.8;  // Sleeve body outer diameter
$h_total          = 21.5;  // Total height of the part

// --- Derived Dimensions ---
$z_collars_top    = $t_collar; // Z coordinate where collar ends and body begins
$h_body          = $h_total - $z_collars_top;    // Height of the cylindrical body section above collar
$d_bore_inner     = 6.2;   // Straight bore diameter (User specified)

// Build the part using difference to subtract the hole from the outer shape
difference() {
    
    // 1. The Main Outer Shape (Collar + Body)
    union() {
        // Collar: Cylinder at Z=0 to Z=t_collar
        cylinder(
            h = $t_collars_top, 
            d = $d_collar_outer, 
            center = true
        );

        // Body: Cylinder rising from collar top (Z=$z_collars_top) to total height
        translate([0, 0, $z_collars_top]) {
            cylinder(
                h = $h_body, 
                d = $d_body_outer, 
                center = true
            );
        }
    }

    // 2. The Bore Hole (Straight through the full height)
    translate([0, 0, -($t_collars_top / 2)]) {
        cylinder(
            h = ($h_total * 2), 
            d = $d_bore_inner, 
            center = true
        );
        
        // Extend slightly past top and bottom faces to ensure clean cut in difference()
        translate([0, 0, -1]) {
             cylinder(h=($t_collars_top + 5), d=$d_bore_inner);
        }
    }

}