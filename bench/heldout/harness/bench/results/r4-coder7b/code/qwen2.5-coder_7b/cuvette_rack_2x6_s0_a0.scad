// Dimensions
base_width = 112;
base_height = 44;
base_thickness = 3;

deck_width = base_width;
deck_height = base_height;
deck_thickness = 3;

wall_depth = base_thickness;
end_wall_thickness = 3;
rib_thickness = 2.5;

cuvette_side_length = 12.5;

hole_diameter = 13;
hole_spacing_x = 18;
hole_spacing_y = 18;

// Base plate
base_plate = cube([base_width, base_height, base_thickness]);

// Deck plate
deck_plate = translate([0, 0, deck_thickness]) (cube([deck_width, deck_height, deck_thickness]));

// Upright walls
end_walls = union() {
    for (x = [-base_width/2 + end_wall_thickness/2 : end_wall_thickness : base_width/2 - end_wall_thickness/2])
        translate([x, 0, 0]) (cube([end_wall_thickness, deck_height, wall_depth]));
};

rib_walls = union() {
    for (x = [-base_width/2 + rib_thickness/2 : rib_thickness : base_width/2 - rib_thickness/2])
        translate([x, 0, 0]) (cube([rib_thickness, deck_height, wall_depth]));
};

upright_walls = end_walls + rib_walls;

// Holes in the deck
holes = union() {
    for (i = [0 : 5], j = [0 : 5])
        translate([(i+1)*hole_spacing_x - base_width/2 + cuvette_side_length/2, 
                   (j+1)*hole_spacing_y - base_height/2 + cuvette_side_length/2, 
                   deck_thickness]) 
            cylinder(h = hole_diameter, r = hole_diameter/2, $fn=64);
};

// Final model
model = base_plate + deck_plate + upright_walls + holes;

// Render the model
render() {
    difference() {
        model;
        for (i = [0 : 5], j = [0 : 5])
            translate([(i+1)*hole_spacing_x - base_width/2 + cuvette_side_length/2, 
                       (j+1)*hole_spacing_y - base_height/2 + cuvette_side_length/2, 
                       deck_thickness]) 
                cylinder(h = hole_diameter + 0.1, r = hole_diameter/2 + 0.05, $fn=64);
    }
}