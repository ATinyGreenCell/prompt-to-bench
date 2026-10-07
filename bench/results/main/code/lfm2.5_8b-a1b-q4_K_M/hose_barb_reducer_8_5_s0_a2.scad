// dimensions in mm
ID_8 = 8;
OD_8_bottom = 7.5;
OD_8_top = 9.5;
COLLAR_DIAM = 12;
BARB_8_HEIGHT = 10;
BARB_5_HEIGHT = 8;

// inner bore radius (ID/2)
inner_radius = ID_8 / 2;

// outer collar radius
collar_radius = COLLAR_DIAM / 2;

// create inner cylinder (bore)
cylinder(radius=inner_radius, height=41, $fn=64);

// cylindrical collar
cylinder(radius=collar_radius, height=16, $fn=64);

// function to create a barb shape given start radius, end radius, height, and number of steps
function make_barb(start_r, end_r, h, n) {
    var r0 = start_r;
    var rh = end_r;
    var step = (rh - r0) / (n - 1);
    var radii = [];
    for(i=0; i<=n; i++) {
        var r = r0 + i*step;
        radii.push(r);
    }
    // extrude a shape that has these radii at each height? Not directly.
    // Instead we create two cylinders: one with radius r0 and another with radius rh, stacked.
    cylinder(radius=r0, height=h, $fn=64);
    cylinder(radius=rh, height=h, $fn=64);
}

// lower section: two barbs for 8 mm tubing
make_barb(inner_radius, inner_radius + (BARB_8_height/2)*( (OD_8_top