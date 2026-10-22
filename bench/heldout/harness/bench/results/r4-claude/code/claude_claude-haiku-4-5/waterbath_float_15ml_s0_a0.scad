// Dimensions for hexagonal float holding seven 15 mL conical tubes
// Measured with calipers

// Hexagonal plate
plate_width = 90; // mm, across the flats
plate_thickness = 3; // mm
R_plate = plate_width / sqrt(3); // circumradius for flat-top hexagon

// Holes and sleeves
hole_diameter = 17.5; // mm, through-holes in plate
sleeve_outer_diameter = 21.5; // mm, outer diameter of sleeves
sleeve_height = 20; // mm, height of sleeves above plate

// Positions for holes
hole_circle_radius = 27; // mm, radius for 6 outer holes (54 mm diameter circle)

// Hexagonal skirt
skirt_outer_width = 84; // mm, across the flats (outside)
R_skirt_outer = skirt_outer_width / sqrt(3); // circumradius
skirt_inner_width = 80; // mm, 2 mm wall thickness
R_skirt_inner = skirt_inner_width / sqrt(3);
skirt_height = 20; // mm, height above plate

// Resolution for curved surfaces
$fn = 64;

// Module to create a flat-top regular hexagon
module flat_top_hexagon(R) {
    polygon(points = [
        [R, 0],
        [R/2, R*sqrt(3)/2],
        [-R/2, R*sqrt(3)/2],
        [-R, 0],
        [-R/2, -R*sqrt(3)/2],
        [R/2, -R*sqrt(3)/2]
    ]);
}

// Hexagonal plate with 7 through-holes
module plate() {
    difference() {
        // Solid hexagonal plate
        linear_extrude(height = plate_thickness) {
            flat_top_hexagon(R_plate);
        }
        
        // Center hole
        translate([0, 0, -0.5]) {
            cylinder(d = hole_diameter, h = plate_thickness + 1, $fn = 64);
        }
        
        // Six outer holes arranged in circle, 60 degrees apart, first at +X
        for (i = [0:5]) {
            angle = i * 60;
            x = hole_circle_radius * cos(angle);
            y = hole_circle_radius * sin(angle);
            translate([x, y, -0.5]) {
                cylinder(d = hole_diameter, h = plate_thickness + 1, $fn = 64);
            }
        }
    }
}

// Hollow cylindrical sleeves around each hole
module sleeves() {
    // Center sleeve
    difference() {
        cylinder(d = sleeve_outer_diameter, h = sleeve_height, $fn = 64);
        translate([0, 0, -0.5]) {
            cylinder(d = hole_diameter, h = sleeve_height + 1, $fn = 64);
        }
    }
    
    // Six outer sleeves
    for (i = [0:5]) {
        angle = i * 60;
        x = hole_circle_radius * cos(angle);
        y = hole_circle_radius * sin(angle);
        translate([x, y, 0]) {
            difference() {
                cylinder(d = sleeve_outer_diameter, h = sleeve_height, $fn = 64);
                translate([0, 0, -0.5]) {
                    cylinder(d = hole_diameter, h = sleeve_height + 1, $fn = 64);
                }
            }
        }
    }
}

// Hexagonal skirt (hollow hexagonal wall)
module skirt() {
    difference() {
        // Outer hexagon
        linear_extrude(height = skirt_height) {
            flat_top_hexagon(R_skirt_outer);
        }
        // Inner hexagon (subtract to create hollow)
        translate([0, 0, -0.5]) {
            linear_extrude(height = skirt_height + 1) {
                flat_top_hexagon(R_skirt_inner);
            }
        }
    }
}

// Assemble all components
union() {
    plate();
    sleeves();
    skirt();
}