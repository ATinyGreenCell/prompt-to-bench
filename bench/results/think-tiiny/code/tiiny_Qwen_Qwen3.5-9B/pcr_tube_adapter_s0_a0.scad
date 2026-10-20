// Dimensions in millimetres
collar_od = 13;
collar_height = 1.5;
body_od = 10.8;
total_height = 21.5;
bore_diameter = 6.2;
hole_extension = 0.1;
body_height = total_height - collar_height;

// Ensure smooth curves on all cylindrical surfaces
$fn = 64;

module adapter() {
    difference() {
        union() {
            // Collar (bottom): Z = 0 to Z = collar_height
            cylinder(h = collar_height, r = collar_od / 2, center = [0, 0, collar_height / 2]);
            
            // Body (top): Z = collar_height to Z = total_height
            cylinder(h = body_height, r = body_od / 2, center = [0, 0, total_height / 2]);
        }
        
        // Bore hole: Extends past Z=0 and Z=total_height to ensure clean cuts
        cylinder(h = total_height + hole_extension, r = bore_diameter / 2, center = [0, 0, total_height / 2]);
    }
}

adapter();