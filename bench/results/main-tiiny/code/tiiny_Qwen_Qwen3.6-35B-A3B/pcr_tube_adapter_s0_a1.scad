// 1. The base collar
    cylinder(r = COLLAR_R, h = COLLAR_THICK, center = false);

    // 2. The sleeve body
    translate([0, 0, COLLAR_THICK]) {
        cylinder(r = SLEEVE_R, h = SLEEVE_BODY_H, center = false);
    }

    // 3. The bore
    $fn = 64;
    difference() {
        // ... union ...
    }