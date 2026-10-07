// Define variables for dimensions
$fn = 64; // Set function to generate curved shapes

// Create a cylinder with a diameter of 10 mm
cylinder(
    center = (0, 0, 20),
    radius = 5,
    height = 20,
    color = red,
    name = "Cylinder"
);

// Create a cone with a diameter of 10 mm at z = 20 and 60 mm at the rim at z = 50
cone(
    center = (0, 0, 20),
    radius = 5,
    height = 30,
    color = blue,
    name = "Cone"
);

// Create a straight tube with a diameter of 10 mm from z = 0 to z = 20
line(
    start = (0, 0, 0),
    end = (0, 0, 20),
    color = green,
    name = "Tube"
);

// Create a square with a side length of 1.6 mm
square(
    center = (0, 0, 0),
    size = (1.6, 1.6, 1.6),
    color = yellow,
    name = "Square"
);

// Create a linear extrude to create the funnel
linear_extrude(
    start = (0, 0, 20),
    end = (0, 0, 50),
    height = 30,
    color = orange,
    name = "Funnel"
);

// Create a circle with a diameter of 10 mm at z = 50
circle(
    center = (0, 0, 50),
    radius = 5,
    color = purple,
    name = "Circle"
);

// Create a square with a side length of 1.6 mm
square(
    center = (0, 0, 50),
    size = (1.6, 1.6, 1.6),
    color = green,
    name = "Square"
);

// Create a linear extrude to create the funnel
linear_extrude(
    start = (0, 0, 50),
    end = (0, 0, 70),
    height = 30,
    color = orange,
    name = "Funnel"
);

// Create a circle with a diameter of 10 mm at z = 70
circle(
    center = (0, 0, 70),
    radius = 5,
    color = purple,
    name = "Circle"
);