// Dimensions for 0.2 mL PCR Tube Adapter
// Units: mm

// Outer dimensions
sleeve_od = 10.8;      // Outer diameter of the main body
collar_od = 13.0;      // Outer diameter of the base collar
collar_h = 1.5;        // Height of the base collar
sleeve_h = 21.5;       // Total height of the sleeve body

// Bore dimensions
bore_d = 6.2;          // Diameter of the bore (hole)
bore_h = 22.0;         // Height of the bore (slightly taller than sleeve to ensure clearance)

// Tolerances and printing settings
$fn = 64;              // Resolution for curved surfaces
wall_thick = 1.0;      // Wall thickness of the sleeve
tolerance = 0.1;       // Small tolerance for cutting shapes

// Derived dimensions
sleeve_id = sleeve_od - (2 * wall_thick);
collar_id = collar_od - (2 * wall_thick);

module main() {
    union() {
        // 1. Base Collar (Rests on bed)
        // We use a cylinder for the collar, but we need to cut the bore through it
        // and the main body.
        
        // Construct the collar with the bore
        cylinder(d = collar_od, h = collar_h, center = false);
        
        // Construct the main body with the bore
        // The body starts at z = collar_h
        translate([0, 0, collar_h]) {
            cylinder(d = sleeve_od, h = sleeve_h, center = false);
        }
    }
}

module cutouts() {
    // We need to cut the bore through the entire object.
    // We extend the cutting shape slightly past the top and bottom
    // to ensure clean separation (Rule 5).
    
    // Bottom cut (through collar)
    cylinder(d = bore_d, h = collar_h + tolerance, center = false);
    
    // Top cut (through body)
    translate([0, 0, collar_h + sleeve_h - tolerance]) {
        cylinder(d = bore_d, h = tolerance, center = false);
    }
}

// Render the part
difference() {
    main();
    cutouts();
}