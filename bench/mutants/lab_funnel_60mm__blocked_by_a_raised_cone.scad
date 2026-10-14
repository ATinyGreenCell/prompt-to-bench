$fn=96;
difference(){
  union(){ cylinder(d=10,h=20); translate([0,0,20]) cylinder(d1=10,d2=60,h=30); }
  translate([0,0,-1]) cylinder(d=6.8,h=21);              // spout bore up to z=20
  translate([0,0,22.5]) cylinder(d1=10,d2=60,h=30);      // cone hollowed by raising it 2.5 mm
}