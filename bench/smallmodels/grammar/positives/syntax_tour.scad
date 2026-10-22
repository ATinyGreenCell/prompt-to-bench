// syntax tour: one valid OpenSCAD file that uses every construct openscad.gbnf covers.
// validate.py must accept it, and OpenSCAD must parse it (it is not meant to render).
/* [Customizer section] */
use <MCAD/units.scad>
include <MCAD/materials.scad>

$fn = 64; $fa = 12; $fs = 2;
w = 20;    // width
h=5;d=.5;e=2.;f=1e-3;g=1.5E+3;hx=0x1F;
s = "quote \" backslash \\ newline \n tab \t hex \x41 unicode \u00e9 \U01F600 é µm ±0.1 °";
v = [1, 2, 3];
r = [0 : 2 : 10];
neg = [-5 : 5];
m = v.x + v.y * v.z - r.begin + r.step / r.end;
idx = [[1, 2], [3, 4]][1][0];
tern = w > 10 ? "big" : w > 5 ? "mid" : "small";
logic = !(w < 3) && h >= 2 || w != h && w == 20;
p = -w ^ 2 % 7 + +h;
fn = function (x, y = 2) x * y;
called = fn(3)(4);
lit = (function (x) x + 1)(2);
lc1 = [for (i = [0 : 3]) if (i % 2 == 0) i else -i];
lc2 = [for (i = 0, j = 1; i < 5; i = i + 1, j = j * 2) [i, j]];
lc3 = [each v, 4, each[5, 6], for (a = [0 : 60 : 359]) [cos(a), sin(a)] * 10];
lc4 = [let (a = 1) a, let (b = 2) for (i = [0 : b]) i];
lc5 = [for (i = [0 : 2]) let (x = i * 2) x, (for (j = [1, 2]) j)];
lc6 = [for (i = [0:2]) if (i > 0) for (j = [0:i]) [i, j]];
nested = [[for (i = [0 : 2]) i], [for (j = [0 : 2]) j],];
empty = [];
withlet = let (a = 2, b = a * 3) a + b;
checked = assert(w > 0, "w must be positive") w * 2;
echoed = echo("w is", w) w;
special = $preview ? 32 : 128;
und = undef;
isu = is_undef(und) ? 1 : 2;
offset = 3; scale = 1.5; color = "red"; text = "label";  // module names used as variables
from_mod_vars = offset * scale;
cubes = 2; my_cube = 3; cube_w = 4; translated = 5;   // names that only start like modules

function area(a, b = 1,) = a * b;
function pts(n) = [for (i = [0 : n - 1]) [cos(360 * i / n), sin(360 * i / n)]];
function sum(v, i = 0) = i < len(v) ? v[i] + sum(v, i + 1) : 0;

module plate(size = [w, 30, h], holes = 4) {
    module inner() cylinder(d = 3, h = 2 * h, center = true);
    difference() {
        cube(size);
        for (i = [0 : holes - 1], j = [0 : 1])
            translate([4 + i * 4, 4 + j * 22, h / 2]) inner();
    }
}

module tagged() { children(); children(0); children([0 : $children - 1]); }

plate();
plate([10, 10, 2], holes = 2);
translate([0, 0, 10]) rotate([0, 0, 45]) scale([1, 1, 2]) mirror([1, 0, 0]) cube(1);
multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0]]) color("red", 0.5) color([1, 0, 0]) sphere(1);
offset(r = 1) square(2, center = true);
hull() { circle(1); translate([5, 0]) circle(1); }
minkowski() { cube(1); sphere(0.2); }
union() { cube(1); } intersection() { cube(2); sphere(1.2); }
linear_extrude(height = 5, center = true, convexity = 10, twist = 30, slices = 20, scale = 0.5) square(2);
rotate_extrude($fn = 64, angle = 270) translate([10, 0]) circle(2);
polyhedron(points = [[0, 0, 0], [1, 0, 0], [0, 1, 0], [0, 0, 1]], faces = [[0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]]);
polygon(points = pts(6));
text("Hi", size = 5, font = "Liberation Sans:style=Bold", halign = "center");
import("part.stl");
surface(file = "heights.dat", center = true);
render(convexity = 2) difference() { cube(2); sphere(1); }
projection(cut = true) cube(1);
resize([2, 2, 2]) sphere(1);
intersection_for (i = [0 : 2]) rotate([0, 0, i * 60]) cube(10, center = true);
tagged() { cube(1); sphere(1); }
for (p = [[0, 0], [1, 1]]) translate(p) cube(0.5);
let (a = 2) cube(a);
echo(str("w = ", w)) cube(1);
assert(len(v) == 3, "need 3");
echo(area(2), sum([1, 2, 3]), fn(2), called, lit);
if (w > 10) { cube(1); } else if (w > 5) sphere(1); else { cylinder(1, 1); }
if (h > 1) cube(1); else{ sphere(1); }
if (h > 1) cube(1); else#cube(2);
* cube(1); !sphere(2); #cylinder(r = 1, h = 1); %cube(3);
{ x = 1; cube(x); }
;;
translate([0,0,0]);
difference(){cube(10);translate([0,0,-1])cylinder(r=2,h=12);}
translate ([1, 2, 3]) cube (1) ;
cube(/* size */ 10 /* mm */);
translate([1, // x
           2, 3]) cube(1);
	cube(1);	// a tab-indented line
/**** a block comment with **stars** inside ****/
