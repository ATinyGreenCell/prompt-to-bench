// Dimensions (mm)
$fn = 256;
inner_bore_diameter = 3;          // Inner bore diameter
outer_barb_8mm_top = 9.5;         // Max barb outer diameter for 8mm tubing
outer_barb_8mm_bottom = 7.5;      // Min barb outer diameter for 8mm tubing
barb_height_8mm = 10;             // Height of each 8mm barb section
collar_length = 5;                // Collar length

outer_barb_5mm_top = 6.5;         // Max barb outer diameter for 5mm tubing
outer_barb_5mm_bottom = 5.0;      // Min barb outer diameter for 5mm tubing
barb_height_5mm = 8;               // Height of each 5mm barb section
total_height = 41;                // Total height

// Main inner bore cylinder
inner_bore = cylinder(d=inner_bore_diameter, h=total_height);

// 8mm tubing barbs (stacked twice)
for (i in [0,1]) {
    translate([0, 0, i * barb_height_8mm])
        rotate(45, [0, 0, 1])
            difference(
                cylinder(d=inner_bore_diameter + 0.25, h=barb_height_8mm),
                [
                    // Sawtooth outer profile
                    translate([0, 0, barb_height_8mm - (outer_barb_8mm_top - inner_bore_diameter)/2])
                        rotate(45, [0, 0, 1])
                            polygon(points=[
                                [-inner_bore_diameter/2, 0],
                                [-(outer_barb_8mm_bottom + inner_bore_diameter)/2, -(outer_barb_8mm_bottom - inner_bore_diameter)/2],
                                [(outer_barb_8mm_top - inner_bore_diameter)/2, (outer_barb_8mm_top - inner_bore_diameter)/2],
                                [inner_bore_diameter/2, 0]
                            ], center=true),
                    // Step cut
                    translate([0, 0, barb_height_8mm - (outer_barb_8mm_bottom - inner_bore_diameter)/2])
                        rotate(45, [0, 0, 1])
                            polygon(points=[
                                [-inner_bore_diameter/2, 0],
                                [-(inner_bore_diameter + inner_bore_diameter)/2, -(outer_barb_8mm_bottom - inner_bore_diameter)/2],
                                [(inner_bore_diameter + inner_bore_diameter)/2, (outer_barb_8mm_top - inner_bore_diameter)/2],
                                [inner_bore_diameter/2, 0]
                            ], center=true)
                ]
            );
}

// Cylindrical collar
collar = translate([0, 0, barb_height_8mm * 2])
    cylinder(d=outer_barb_8mm_top + 1.5, h=collar_length);

// 5mm tubing barbs (stacked twice)
for (i in [0,1]) {
    translate([0, 0, i * barb_height_5mm + collar_length])
        rotate(45, [0, 0, 1])
            difference(
                cylinder(d=inner_bore_diameter + 0.25, h=barb_height_5mm),
                [
                    // Tapered cut
                    translate([0, 0, barb_height_5mm - (outer_barb_5mm_top - inner_bore_diameter)/2])
                        rotate(45, [0, 0, 1])
                            polygon(points=[
                                [-inner_b