// Dimensions
$fn = 64;
plate_diameter = 90;
plate_thickness = 3;
hole_diameter = 17.5;
sleeve_wall = 2;
sleeve_height = 20;
skirt_diameter = 84;
skirt_wall = 2;

// Calculate half dimensions for centering
half_plate_diameter = plate_diameter / 2;
half_skirt_diameter = skirt_diameter / 2;

// Create the flat plate
plate = cylinder(d=plate_diameter, h=plate_thickness);

// Create the through-holes and sleeves
holes_and_sleeves = union() {
    for (i = [0:6]) {
        // Calculate angle in radians
        angle = i * 2 * pi / 7;
        
        // Hole
        translate([half_plate_diameter * cos(angle), half_plate_diameter * sin(angle), plate_thickness / 2])
            cylinder(d=hole_diameter, h=plate_thickness);
        
        // Sleeve
        rotate_extrude()
            translate([half_plate_diameter * cos(angle), half_plate_diameter * sin(angle), plate_thickness])
                circle(d=sleeve_wall + hole_diameter);
    }
};

// Create the hexagonal skirt
skirt = difference() {
    cylinder(d=skirt_diameter, h=skirt_height);
    translate([0, 0, skirt_height])
        rotate_extrude()
            translate([-half_skirt_diameter, -half_skirt_diameter, 0])
                circle(d=skirt_diameter - skirt_wall * 2);
};

// Combine the plate, holes, sleeves, and skirt
model = union() {
    plate;
    holes_and_sleeves;
    skirt;
};

// Translate to center on origin in X and Y
translate([-half_plate_diameter, -half_skirt_diameter, 0])
    model;