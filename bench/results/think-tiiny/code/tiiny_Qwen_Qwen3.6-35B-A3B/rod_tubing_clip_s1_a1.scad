$fn = 64;

// Dimensions
rod_od = 18.7;
rod_id = 12.7;
tube_od = 10;
tube_id = 6;
bridge_x1 = 8;
bridge_x2 = 12;
bridge_y = 6;
height = 10;

// Rod ring with -X opening
rod_ring = difference() {
    cylinder(h=height, r=rod_od/2);
    cylinder(h=height+0.1, r=rod_id/2);
    translate([-50, -5, -0.5]) cube([100, 10, height+1]);
};

// Tubing ring with +X opening
tube_ring = difference() {
    translate([15, 0, 0]) cylinder(h=height, r=tube_od/2);
    translate([15, 0, 0]) cylinder(h=height+0.1, r=tube_id/2);
    translate([15, -2.25, -0.5]) cube([100, 4.5, height+1]);
};

// Bridge
bridge = translate([10, 0, 0]) cube([bridge_x2-bridge_x1, bridge_y, height]);

union() {
    rod_ring;
    tube_ring;
    bridge;
}