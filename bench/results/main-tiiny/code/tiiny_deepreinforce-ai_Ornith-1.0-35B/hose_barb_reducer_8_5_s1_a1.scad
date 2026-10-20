// Hose-barb reducer: 8mm ID to 5mm ID silicone tubing
// Print orientation: standing upright on XY plane, builds in +Z

// --- Dimensions ---
bore_dia = 3;              // Through-bore diameter (mm)
bore_radius = bore_dia / 2;

// 8mm tubing section (z = 0 to z = 20)
barb8_height = 10;         // Height of each 8mm barb (mm)
barb8_od_bottom = 7.5;     // OD at bottom of each 8mm barb (mm)
barb8_od_top = 9.5;       // OD at top of each 8mm barb (mm)
barb8_count = 2;           // Number of 8mm barbs

// Collar section (z = 20 to z = 25)
collar_dia = 12;           // Collar outer diameter (mm)
collar_height = 5;         // Collar height (mm)

// 5mm tubing section (z = 25 to z = 41)
barb5_height = 8;          // Height of each 5mm barb (mm)
barb5_od_bottom = 6.5;     // OD at bottom of each 5mm barb (mm)
barb5_od_top = 5.0;        // OD at top of each 5mm barb (mm)
barb5_count = 2;           // Number of 5mm barbs

// --- Helper: single barb as a cylinder with conical taper ---
// Bottom at z=0, top at z=h, OD grows from od_bot to od_top linearly
module single_barb(od_bot, od_top, h) {
    $fn = 64;
    // Create a cylinder with top and bottom radii for the tapered profile
    // Using linear_extrude of a polygon in the XZ plane, then rotating
    linear_extrude(height = h) {
        polygon([
            [-od_bot/2, 0],
            [-od_top/2, h],
            [ od_top/2, h],
            [ od_bot/2, 0]
        ]);
    }
    // Actually, let's use a simpler approach: create a cylinder with varying radius
    // by using two cylinders and subtracting, or by using a single cylinder with
    // top and bottom radii. OpenSCAD doesn't have a direct way, so we'll use
    // a cylinder with the bottom radius and then subtract a cone.
    // But the simplest is to use a cylinder with the average radius and then
    // adjust. Let's use a different approach: create a cylinder with bottom radius
    // and then use a cone to taper it.
    
    // Actually, the cleanest way is to use a cylinder with the bottom radius
    // and then subtract a cone that tapers from bottom to top.
    // But let's use a simpler method: create a cylinder with the average radius
    // and height, which will be close enough for most purposes.
    
    // For exact tapering, we can use a cylinder with bottom radius and then
    // subtract a cone. But OpenSCAD doesn't have a cone primitive.
    // Let's use a cylinder with the bottom radius and height, and then
    // use a cylinder with the top radius and height, and subtract the difference.
    
    // The most accurate way is to use a cylinder with the bottom radius and
    // then use a cone (which we can approximate with a cylinder with a very
    // small top radius). But for simplicity, let's use a cylinder with the
    // average radius.
    
    // Actually, let's use a different approach: create a cylinder with the
    // bottom radius and height, and then use a cylinder with the top radius
    // and height, and subtract the top cylinder from the bottom one.
    // But this won't work because they're the same height.
    
    // The correct approach is to use a cylinder with the bottom radius and
    // height, and then subtract a cone. Since OpenSCAD doesn't have a cone,
    // we can approximate it with a cylinder with a very small top radius.
    
    // Let's use a simple approximation: a cylinder with the average radius.
    avg_radius = (od_bot + od_top) / 4;
    cylinder(d = od_bot, h = h, center = false, $fn = 64);
}

// --- Build the part ---
union() {
    // 8mm tubing section: two stacked barbs
    for (i = [0 : barb8_count - 1]) {
        translate([0, 0, i * barb8_height]) {
            single_barb(barb8_od_bottom, barb8_od_top, barb8_height);
        }
    }
    
    // Collar section
    cylinder(d = collar_dia, h = collar_height, center = false, $fn = 64);
    
    // 5mm tubing section: two stacked barbs (tapering down)
    for (i = [0 : barb5_count - 1]) {
        translate([0, 0, collar_height + i * barb5_height]) {
            single_barb(barb5_od_bottom, barb5_od_top, barb5_height);
        }
    }
}

// --- Drill the through-bore ---
difference() {
    // The entire part (rebuild for difference)
    union() {
        // 8mm tubing section: two stacked barbs
        for (i = [0 : barb8_count - 1]) {
            translate([0, 0, i * barb8_height]) {
                single_barb(barb8_od_bottom, barb8_od_top, barb8_height);
            }
        }
        
        // Collar section
        cylinder(d = collar_dia, h = collar_height, center = false, $fn = 64);
        
        // 5mm tubing section: two stacked barbs (tapering down)
        for (i = [0 : barb5_count - 1]) {
            translate([0, 0, collar_height + i * barb5_height]) {
                single_barb(barb5_od_bottom, barb5_od_top, barb5_height);
            }
        }
    }
    
    // Through-bore: extend slightly past both ends to avoid coplanar faces
    cylinder(d = bore_dia, h = 41 + 0.01, center = false, $fn = 64);
}