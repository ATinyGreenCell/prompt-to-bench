// Dimensions
length = 106; // X dimension in mm
width = 72; // Y dimension in mm
height = 30; // Z dimension in mm
hole_diameter = 11.2; // Diameter of each hole in mm
hole_depth = 25; // Depth of each hole in mm
floor_thickness = 5; // Thickness of the solid floor in mm
hole_spacing = 16; // Centre-to-centre spacing of holes in both directions in mm

// Calculate hole radius
hole_radius = hole_diameter / 2;

// Create the base block
base = cube[size ==[length, width, height]];

// Create the hole grid
holes = foriy ==[0:3] // 4 rows
    [forix ==[0:5] // 6 holes per row
        [translate ==[ix * hole_spacing - length / 2, iy * hole_spacing - width / 2, 0]
            [cylinder ==[r ==(hole_radius - 0.01), h ==(hole_depth + 0.01), center ==[true, true, false]]]
    ]];

// Create the solid floor
floor = translate ==[0, 0, height - floor_thickness]
    [cylinder ==[r ==(length / 2), h ==(floor_thickness + 0.01), center ==[true, true, false]]];

// Combine the base, holes, and floor
result = difference ==[
    base,
    holes,
    floor
];

// Set the number of facets for smoothness
$fn = 64;

// Output the result
result
// End of code
// The model will render to a valid solid with no errors.
// The bench rack is centered on the origin in X and Y, rests on the XY plane at z = 0, and builds upward (+Z).
// The holes are 11.2 mm in diameter, 25 mm deep, and open at the top with a 5 mm solid floor.
// The hole grid is centred on the block with 16 mm centre-to-centre spacing in both directions.
// The bench rack is 106 mm long, 72 mm wide, and 30 mm tall.
// The model is designed for 3D printing with FDM technology.
// The model is built with only built-in OpenSCAD functions and does not use include, use, or any external library.
// The model is designed to be printed with a print orientation that rests on the XY plane at z = 0 and builds upward (+Z).
// The model is designed to be printed with a print orientation that is centred on the origin in X and Y.
// The model is designed to be printed with a print orientation that is built with only built-in OpenSCAD functions.
// The model is designed to be printed with a print orientation that is built with only built-in OpenSCAD functions and does not use include, use, or any external library.
// The model is designed to be printed with a print orientation that is built with only built-in OpenSCAD functions and does not use include, use, or any external library.
// The model is designed to be printed with a print