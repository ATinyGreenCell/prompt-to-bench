// Dimensions from user input
$fn = 64; // for round holes

// Base dimensions
length = 90;
width = 45;
height = 20;

// Slide dimensions
slide_length = 75;
slide_width = 25;
slide_height = 1;

// Slot dimensions
slot_length = slide_length + 2 * (slide_width / 2);
slot_width = slide_width - 3.5; // subtract for slots to be open at top
slot_depth = 10;
slot_spacing = 3.5; // spacing between slots

// Create the base block
base_block = [
    translate([length/2, width/2, height]) [
        cube([length, width, height])
    ]
];

// Create the slots
slots = for(i in [1..10]) [
    translate([
        length / 2,
        i * slot_spacing + (i - 1) * slot_depth / 2,
        0
    ]) [
        linear_extrude(height=slot_depth, center=true) [
            cube([slide_length, slide_width, slot_depth])
        ]
    ]
];

// Combine the base block and slots into a solid
drying_rack = union() [
    base_block;
    for(i in [1..10]) [
        translate([
            length / 2,
            i * (slot_spacing + slide_width) / 2,
            slot_depth / 2
        ]) [
            linear_extrude(height=slide_height, center=true) [
                cube([slide_length, slide_width, slide_height])
            ]
        ];
    ];
];

// Print the drying rack
print(drying_rack);