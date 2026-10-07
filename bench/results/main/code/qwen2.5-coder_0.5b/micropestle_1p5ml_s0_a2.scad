// Define variables for dimensions
$size = 1.5; // Size of the microcentrifuge tube in millimeters

// Create cylindrical handle
cylinder(
    center = (0, 0, 0),
    radius = $size / 2,
    height = $size / 4,
    color = red
);

// Create cone that tapers from 8 mm diameter at z = 45 to 3 mm diameter at z = 62
cone(
    center = (0, 0, 0),
    radius1 = $size / 2,
    radius2 = $size / 3,
    height = $size / 4,
    color = blue
);

// Create rounded tip
sphere(
    center = (0, 0, 0),
    radius = $size / 6,
    color = green
);

// Define grooves for grip
for (i = 1; i <= 4; i++) {
    // Create a circular groove
    cylinder(
        center = (0, 0, 0),
        radius = $size / 2 + (i - 1) * 2,
        height = $size / 4,
        color = yellow
    );

    // Create a rectangular groove
    rectangle(
        x1 = 0,
        y1 = 0,
        x2 = $size / 2 + (i - 1) * 2,
        y2 = $size / 4,
        color = orange
    );
}

// Print the part
print();