// Define dimensions
$fn = 64; // Number of facets for smooth surfaces

// Collar dimensions
collar_diameter = 13;
collar_thickness = 1.5;

// Sleeve body dimensions
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5 - collar_thickness;

// Bore dimensions
bore_diameter = 6.2;
bore_length = sleeve_height;

// Main function to build the adapter sleeve
module adapter_sleeve() {
    // Collar
    translate([collar_diameter / 2, collar_diameter / 2, 0]) {
        linear_extrude(height=collar_thickness) {
            circle(d=collar_diameter);
        }
    }

    // Sleeve body
    translate([sleeve_outer_diameter / 2, sleeve_outer_diameter / 2, collar_thickness]) {
        linear_extrude(height=sleeve_height) {
            circle(d=sleeve_outer_diameter);
        }
    }

    // Bore
    translate([sleeve_outer_diameter / 2, sleeve_outer_diameter / 2, collar_thickness + bore_length / 2]) {
        rotate_extrude(angle=360) {
            cylinder(h=bore_length, r=bore_diameter / 2);
        }
    }
}

// Render the adapter sleeve
adapter_sleeve();