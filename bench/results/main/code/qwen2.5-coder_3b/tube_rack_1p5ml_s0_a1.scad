// Define dimensions
$fn = 64; // Number of facets for curved surfaces

// Block dimensions
length = 106;
width = 72;
height = 30;

// Hole grid dimensions
numHolesX = 6;
numHolesY = 4;
holeCentreToCentre = 16;
holeDiameter = 11.2;
holeDepth = 25;
floorThickness = 5;

// Calculate hole positions
holePositionX = (width - numHolesX * holeCentreToCentre) / 2;
holePositionY = (length - numHolesY * holeCentreToCentre) / 2;

// Create the bench rack block
benchRack = translate([0, 0, floorThickness]) cube([length, width, height]);

// Create the holes in the bench rack
for (i = [0: numHolesX-1], j = [0: numHolesY-1]) {
    holePosition = [
        holePositionX + i * holeCentreToCentre,
        holePositionY + j * holeCentreToCentre,
        floorThickness
    ];
    benchRack -= translate(holePosition) cylinder(d=holeDiameter, h=holeDepth);
}

// Render the final model
render() {
    benchRack;
}