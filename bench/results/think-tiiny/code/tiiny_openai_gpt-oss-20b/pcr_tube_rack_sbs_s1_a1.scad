$fn = 64;

// Block dimensions (mm)
X = 127.76;   // Length (X)
Y = 85.48;    // Width  (Y)
Z = 20;       // Height (Z)

// Hole parameters
hole_d = 6.2;          // Diameter of PCR tube holes
spacing = 9.0;         // Centre‑to‑centre spacing

// Position of the first hole (A1) relative to block edges
x0 = 14.38;            // 14.38 mm from left edge
y0 = 11.24;            // 11.24 mm from back edge

// Chamfer leg length (mm)
chamfer_leg = 5.0;

// Base block centred on the origin in X and Y
block = translate([-X/2, -Y/2, 0]) cube([X, Y, Z]);

// 96 vertical through‑holes
holes = union() {
    for (i = [0:11]) for (j = [0:7]) {
        translate([x0 - X/2 + i*spacing, y0 - Y/2 + j*spacing, -0.01])
            cylinder(d = hole_d, h = Z + 0.01, center = false);
    }
}

// 45‑degree chamfer at the A1 corner (left‑back)
chamfer = linear_extrude(Z + 0.01, center = false)
    polygon(points = [[0, 0], [chamfer_leg, 0], [0, chamfer_leg]]);

// Final part: block minus holes and chamfer
difference() {
    block;
    holes;
    chamfer;
}