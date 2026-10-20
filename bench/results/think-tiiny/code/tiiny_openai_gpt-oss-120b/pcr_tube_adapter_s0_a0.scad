// Parameters (mm)
collar_diameter = 13;          // Outer diameter of the bottom collar
collar_thickness = 1.5;         // Thickness of the collar (z = 0 → 1.5)
sleeve_outer_diameter = 10.8;  // Outer diameter of the sleeve body
sleeve_height = 20.0;           // Height of the sleeve body (above collar)
total_height = collar_thickness + sleeve_height; // Full part height = 21.5 mm
bore_diameter = 6.2;           // Diameter of the straight bore
cut_extra = 0.5;                // How much the cutting cylinder extends beyond each face

$fn = 64; // smooth circles

// Main solid (collar + sleeve) minus bore
difference() {
    // ---- Union of collar and sleeve body ----
    union() {
        // Collar (lies on the bed)
        cylinder(d = collar_diameter, h = collar_thickness, center = false);
        
        // Sleeve body (starts on top of collar)
        translate([0, 0, collar_thickness])
            cylinder(d = sleeve_outer_diameter, h = sleeve_height, center = false);
    }
    
    // ---- Bore (cutting shape) ----
    // Extends cut_extra beyond the bottom (z = -cut_extra) and top (z = total_height + cut_extra)
    translate([0, 0, -cut_extra])
        cylinder(d = bore_diameter,
                 h = total_height + 2*cut_extra,
                 center = false);
}