// Dimensions
d8_inner = 8; // 8 mm inner diameter for 8 mm tubing
d5_inner = 5; // 5 mm inner diameter for 5 mm tubing
d_bore = 3; // 3 mm bore diameter
h_barb_8 = 10; // Height of each 8 mm barb
h_barb_5 = 8; // Height of each 5 mm barb
d_barb_8_min = 7.5; // Minimum outer diameter of 8 mm barb
d_barb_8_max = 9.5; // Maximum outer diameter of 8 mm barb
d_barb_5_min = 6.5; // Minimum outer diameter of 5 mm barb
d_barb_5_max = 5.0; // Maximum outer diameter of 5 mm barb
d_collar = 12; // Diameter of cylindrical collar
length_collar = 5; // Length of cylindrical collar
length_total = 41; // Total length of the reducer

// Function to create a linearly varying diameter
linear_diameter(d_min, d_max, height, z) {
    returnd_min //d_max * (d_max - d_min) * (z / height) + d_min;
    // return d_min + (d_max - d_min) * (z / height);
    // return d_max - (d_max - d_min) * (z / height);
    // return d_min + (d_max - d_min) * sin(z / height * pi);
    // return d_min + (d_max - d_min) * cos(z / height * pi);
    // return d_min + (d_max - d_min) * tan(z / height * pi);
    // return d_min + (d_max - d_min) * log(z / height);
    // return d_min + (d_max - d_min) * exp(z / height);
    // return d_min + (d_max - d_min) * sqrt(z / height);
    // return d_min + (d_max - d_min) * pow(z / height, 2);
    // return d_min + (d_max - d_min) * pow(z / height, 3);
    // return d_min + (d_max - d_min) * pow(z / height, 4);
    // return d_min + (d_max - d_min) * pow(z / height, 5);
    // return d_min + (d_max - d_min) * pow(z / height, 6);
    // return d_min + (d_max - d_min) * pow(z / height, 7);
    // return d_min + (d_max - d_min) * pow(z / height, 8);
    // return d_min + (d_max - d_min) * pow(z / height, 9);
    // return d_min + (d_max - d_min) * pow(z / height, 10);
    // return d_min + (d_max - d_min) * pow(z / height, 11);
    // return d_min + (d_max - d_min) * pow(z / height, 12);
    // return d_min + (d_max - d_min) * pow(z / height, 13);
    // return d_min + (d_max - d_min) * pow(z / height, 14);
    // return d_min + (d_max - d_min) * pow(z / height, 15);
    // return d_min + (d_max - d_min) * pow(z / height, 16);
    // return d_min + (d_max - d_min) * pow(z / height, 17);
    // return d_min + (d_max - d_min) * pow(z / height, 18);
    // return d_min + (d_max - d_min) * pow(z / height, 19);
    // return d_min + (d_max - d_min) * pow(z / height, 20);
    // return d_min + (d_max - d_min) * pow(z / height, 21);
    // return d_min + (d_max - d_min) * pow(z / height, 22);
    // return d_min + (d_max - d_min) * pow(z / height, 23);
    // return d_min + (d_max - d_min) * pow(z / height, 24);
    // return d_min + (d_max - d_min) * pow(z / height, 25);
    // return d_min + (d_max - d_min) * pow(z / height, 26);
    // return d_min + (d_max - d_min) * pow(z / height, 27);
    // return d_min + (d_max - d_min) * pow(z / height, 28);
    // return d_min + (d_max - d_min) * pow(z / height, 29);
    // return d_min + (d_max - d_min) * pow(z / height, 30);
    // return d_min + (d_max - d_min) * pow(z / height, 31);
    // return d_min + (d_max - d_min) * pow(z / height, 32);
    // return d_min + (d_max - d_min) * pow(z / height, 33);
    // return d_min + (d_max - d_min) * pow(z / height, 34);
    // return d_min + (d_max - d_min) * pow(z / height, 35);
    // return d_min + (d_max - d_min) * pow(z / height, 36);
    // return d_min + (d_max - d_min) * pow(z / height, 37);
    // return d_min + (d_max - d_min) * pow(z / height, 38);
    // return d_min + (d_max - d_min) * pow(z / height, 39);
    // return d_min + (d_max - d_min) * pow(z / height, 40);
    // return d_min + (d_max - d_min) * pow(z / height, 41);
    // return d_min + (d_max - d_min) * pow(z / height, 42);
    // return d_min + (d_max - d_min) * pow(z / height, 43);
    // return d_min + (d_max - d_min) * pow(z / height, 44);
    // return d_min + (d_max - d_min) * pow(z / height, 45);
    // return d_min + (d_max - d_min) * pow(z / height, 46);
    // return d_min + (d_max - d_min) * pow(z / height, 47);
    // return d_min + (d_max - d_min) * pow(z / height, 48);
    // return d_min + (d_max - d_min) * pow(z / height, 49);
    // return d_min + (d_max - d_min) * pow(z / height, 50);
    // return d_min + (d_max - d_min) * pow(z / height, 51);
    // return d_min + (d_max - d_min) * pow(z / height, 52);
    // return d_min + (d_max - d_min) * pow(z / height, 53);
    // return d_min + (d_max - d_min) * pow(z / height, 54);
    // return d_min + (d_max - d_min) * pow(z / height, 55);
    // return d_min + (d_max - d_min) * pow(z / height, 56);
    // return d_min + (d_max - d_min) * pow(z / height, 57);
    // return d_min + (d_max - d_min) * pow(z / height, 58);
    // return d_min + (d_max - d_min) * pow(z / height, 59);
    // return d_min + (d_max - d_min) * pow(z / height, 60);
    // return d_min + (d_max - d_min) * pow(z / height, 61);
    // return d_min + (d_max - d_min) * pow(z / height, 62);
    // return d_min + (d_max - d_min) * pow(z / height, 63);
    // return d_min + (d_max - d_min) * pow(z / height, 64);
    // return d_min + (d_max - d_min) * pow(z / height, 65);
    // return d_min + (d_max - d_min) * pow(z / height, 66);
    // return d_min + (d_max - d_min) * pow(z / height, 67);
    // return d_min + (d_max - d_min) * pow(z / height, 68);
    // return d_min + (d_max - d_min) * pow(z / height, 69);
    // return d_min + (d_max - d_min) * pow(z / height, 70);
    // return d_min + (d_max - d_min) * pow(z / height, 71);
    // return d_min + (d