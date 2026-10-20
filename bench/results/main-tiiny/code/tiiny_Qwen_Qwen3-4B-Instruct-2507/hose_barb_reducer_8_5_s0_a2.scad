// Dimensions in millimeters
$fn = 64;

// Lengths and diameters
total_length = 41;
z_start_8mm_barbs = 0;
z_end_8mm_barbs = 20;
z_collar = 20;
z_start_5mm_barbs = 25;
z_end_5mm_barbs = 41;

// Barb dimensions
barb_height_8mm = 10;
barb_height_5mm = 8;
barb_outer_diam_8mm_bottom = 7.5;
barb_outer_diam_8mm_top = 9.5;
barb_outer_diam_8mm_bottom_end = 7.5; // after step back

barb_outer_diam_5mm_bottom = 6.5;
barb_outer_diam_5mm_top = 5.0;
barb_outer_diam_5mm_bottom_end = 6.5; // after step back

// Bore diameter (constant through entire part)
bore_diameter = 3.0;
bore_radius = bore_diameter / 2;

// Create the main body: a hollow cylinder of 12mm diameter, 41mm long, with 3mm bore
// This forms the outer shell with the central bore

outer_cylinder = cube([12, 12, 41], center=true);
bore_cylinder = cube([3, 3, 41], center=true);
main_body = difference() {
    outer_cylinder;
    bore_cylinder;
};

// Function to create a tapered barb with linear growth and step back
function create_tapered_barb(z_start, z_end, barb_height, start_diam, peak_diam, end_diam) =
    difference() {
        // Full barb cylinder with peak diameter
        cylinder(h=barb_height, r=peak_diam/2, center=true);
        
        // Subtract a small cylinder at the top to create the step back
        translate([0, 0, z_end - 0.01])
            cylinder(h=0.01, r=end_diam/2, center=true);
    };

// Create the 8mm barbs from z=0 to z=20
// Two barbs stacked, each 10mm tall
for (i = [0:1]) {
    z_pos = z_start_8mm_barbs + i * barb_height_8mm;
    create_tapered_barb(z_pos, z_pos + barb_height_8mm, barb_height_8mm, barb_outer_diam_8mm_bottom, barb_outer_diam_8mm_top, barb_outer_diam_8mm_bottom_end);
}

// Create the collar from z=20 to z=25 (5mm long, 12mm diameter)
cylinder(h=5, r=6, center=true);

// Create the 5mm barbs from z=25 to z=41
// Two barbs stacked, each 8mm tall
for (i = [0:1]) {
    z_pos = z_start_5mm_barbs + i * barb_height_5mm;
    create_tapered_barb(z_pos, z_pos + barb_height_5mm, barb_height_5mm, barb_outer_diam_5mm_bottom, barb_outer_diam_5mm_top, barb_outer_diam_5mm_bottom_end);
}

// Final part: union of the main body and the barbs and collar
// But the barbs and collar are already defined as differences — we need to place them correctly

// We must place the barbs and collar as solid features inside the main body

// Correct approach: build the part as a union of:
// 1. The main hollow cylinder (12mm diameter, 41mm long, 3mm bore)
// 2. The 8mm barbs (from z=0 to 20)
// 3. The collar (from z=20 to 25)
// 4. The 5mm barbs (from z=25 to 41)

// But the barbs and collar are defined as differences — we need to place them as separate solids

// We will now define the barbs and collar as solid features that are added to the main body

// First, define the barbs and collar as separate solids

// 8mm barbs: two barbs, stacked from z=0 to 20
barbs_8mm = union() {
    for (i = [0:1]) {
        translate([0, 0, i * barb_height_8mm])
            create_tapered_barb(i * barb_height_8mm, i * barb_height_8mm + barb_height_8mm, barb_height_8mm, barb_outer_diam_8mm_bottom, barb_outer_diam_8mm_top, barb_outer_diam_8mm_bottom_end);
    }
};

// 5mm barbs: two barbs, stacked from z=25 to 41
barbs_5mm = union() {
    for (i = [0:1]) {
        translate([0, 0, 25 + i * barb_height_5mm])
            create_tapered_barb(25 + i * barb_height_5mm, 25 + i * barb_height_5mm + barb_height_5mm, barb_height_5mm, barb_outer_diam_5mm_bottom, barb_outer_diam_5mm_top, barb_outer_diam_5mm_bottom_end);
    }
};

// Collar: from z=20 to 25
collar = cylinder(h=5, r=6, center=true);

// Final part: union of the main body, barbs, and collar
union() {
    main_body;
    barbs_8mm;
    barbs_5mm;
    collar;
}