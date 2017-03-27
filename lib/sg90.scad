$fn = 100;

use <common.scad>;

// L is in X
// D is in Y
// H is in Z

// Tower Pro Micro Servo SG90 spec

// Base without gearbox, brackets
specSG90BaseD = 11.8;
specSG90BaseL = 22.5;
specSG90BaseH = 15.9;

// Bracket
specSG90BrktT = 2.5;                // bracket thick
specSG90BrktL = 4.7;                // length of single bracket
specSG90BrktHoleOffEdge = 2.3;      // bracket hole offset from outer edge
specSG90BrktHoleD = 2.0;            // DIA of hole in bracket
specSG90BrktHoleR = specSG90BrktHoleD/2;
specSG90BrktHoleSp = 1.3;           // space size connect to hole in bracket

// Gearbox
specSG90GearH = 6.8;                // gearbox height (with bracket thick)
specSG90GearTopH = 4;               // top two gears
specSG90GearConH = 3.2;             // gear connector

// Top two gears
specSG90GearTopLD = 11.8;                       // DIA of large top gear
specSG90GearTopLR = specSG90GearTopLD/2;
specSG90GearTopSD = 5;                          // DIA of small top gear
specSG90GearTopSR = specSG90GearTopSD/2;
specSG90GearTopSOff = 8.8 - specSG90GearTopSR;  // offset of small top gear relative to center of large top gear

// Connector
specSG90ConH = 3.2;
specSG90ConD = 4.6;

// Cable
specSG90CableOffZ = 4.5;            // cable bottom off servo bottom
specSG90CableT = 1.2;               // cable thickness
specSG90CableD = 3.6;               // cable width

function sg90CubeSize() = [specSG90BaseL, specSG90BaseD, specSG90BaseH+specSG90GearH];
function sg90CenterOff() = [(specSG90BaseL-specSG90GearTopLD)/2, 0, sg90CubeSize()[2]/2];
function sg90BaseSize() = [specSG90BaseL, specSG90BaseD, specSG90BaseH];
function sg90OuterSize(con = false) = [
    specSG90BaseL + specSG90BrktL * 2,
    specSG90BaseD,
    specSG90BaseH+specSG90GearH+specSG90GearTopH+(con ? specSG90GearConH : 0)
];

function sg90ConD() = specSG90ConD;
function sg90ConH() = specSG90ConH;
function sg90SmallGearD() = specSG90GearTopSD;
function sg90SmallGearOff() = specSG90GearTopSOff;
function sg90BrktHoleD() = specSG90BrktHoleD;
function sg90BrktHoleOffEdge() = specSG90BrktHoleOffEdge;
function sg90BrktT() = specSG90BrktT;

module sg90BracketHoleF(ext = [0, 0, 0], slot = true) {
    h = specSG90BrktT+ext[2]*2;
    translate([specSG90BrktL/2-specSG90BrktHoleOffEdge, 0, 0]) {
        cylinder(h = h, d = specSG90BrktHoleD+ext[1]*2, center = true);
        if (slot) {
            translate([(specSG90BrktHoleOffEdge+ext[0])/2, 0, 0])
                cube([specSG90BrktHoleOffEdge+ext[0], specSG90BrktHoleSp+ext[1]*2, h], true);
        }
    }
}

module sg90BracketHoleR(ext = [0, 0, 0], slot = true) {
    mirror([1, 0, 0]) sg90BracketHoleF(ext, slot);
}

module sg90BracketF(ext = [0, 0, 0], hole = true) {
    difference() {
        cube([specSG90BrktL+ext[0]*2, specSG90BaseD+ext[1]*2, specSG90BrktT+ext[2]*2], true);
        if (hole) sg90BracketHoleF([ext[0]+0.1, ext[1], ext[2]+0.2]);
    }
}

module sg90BracketR(ext = [0, 0, 0], hole = true) {
    mirror([1, 0, 0]) sg90BracketF(ext, hole);
}

module sg90GearTopCentered(ext = [0, 0, 0]) {
    h = specSG90GearTopH + ext[2];
    cylinder(h = h, d = specSG90GearTopLD+ext[1]*2);
    sd = specSG90GearTopSD+ext[1]*2;
    translate([specSG90GearTopSOff, 0, 0])
        cylinder(h = h, d = sd);
    translate([0, -sd/2, 0])
        cube([specSG90GearTopSOff, sd, h]);
}

module sg90ConCentered(ext = [0, 0, 0]) {
    cylinder(h = specSG90ConH+ext[2], d = specSG90ConD+ext[1]*2);
}

module sg90Base(ext = [0, 0, 0]) {
    translate(sg90CenterOff())
        cube([specSG90BaseL+ext[0]*2, specSG90BaseD+ext[1]*2, sg90CubeSize()[2]+ext[2]*2], true);
}

module sg90Brackets(ext = [0, 0, 0], hole = true) {
    translate([(specSG90BaseL-specSG90GearTopLD)/2, 0, specSG90BaseH+specSG90BrktT/2]) {
        off = (specSG90BaseL+specSG90BrktL)/2;
        translate([off, 0, 0]) sg90BracketF(ext, hole);
        translate([-off, 0, 0]) sg90BracketR(ext, hole);
    }
}

module sg90GearTop(ext = [0, 0, 0]) {
    translate([0, 0, sg90CubeSize()[2]]) sg90GearTopCentered(ext);
}

module sg90Con(ext = [0, 0, 0]) {
    translate([0, 0, sg90CubeSize()[2]+specSG90GearTopH]) sg90ConCentered(ext);
}

module sg90(ext = [0, 0, 0], con = true, hole = true) {
    color("blue") union() {
        sg90Base(ext);
        sg90Brackets(ext, hole);
        sg90GearTop(ext);
    }
    if (con) color("white") sg90Con(ext);
}

module sg90Rack(thick = 2, r = 3, sp = 0.2, back = true) {
    sz = sg90OuterSize();
    l = sz[0] + thick*2;
    d = sz[1];
    h = sz[2]-specSG90GearTopH;
    difference() {
        translate([sg90CenterOff()[0], 0, (h-thick)/2]) cube([l, d, h+thick], true);
        sg90([sp, 0.2, 0.1], hole = false);
        translate([(specSG90BaseL-specSG90GearTopLD)/2, 0, specSG90BaseH+specSG90BrktT/2]) {
            off = (specSG90BaseL+specSG90BrktL)/2;
            translate([off, 0, 0]) {
                sg90BracketHoleF([sp, sp, specSG90GearH], false);
                translate([0, 0, -specSG90BrktT-thick]) cube([specSG90BrktL+thick*2+sp, specSG90BrktHoleD*2, thick], true);
            }
            translate([-off, 0, 0]) {
                sg90BracketHoleR([sp, sp, specSG90GearH], false);
                translate([0, 0, -specSG90BrktT-thick]) cube([specSG90BrktL+thick*2+sp, specSG90BrktHoleD*2, thick], true);
            }
        }
        // cable
        translate([sg90CenterOff()[0]-sg90CubeSize()[0]/2-specSG90BrktL/2-thick, 
                    -d/2-0.4+specSG90CableD/2, 
                    specSG90CableOffZ+specSG90CableT/2+0.2]) 
            cube([specSG90BrktL+thick*2+sp, d+0.2, specSG90CableT+0.8], true);
        
        //translate([sg90CenterOff()[0]-sg90CubeSize()[0]/2-specSG90BrktL/2-thick-specSG90BrktL, 
        //            0, 
        //            specSG90CableOffZ+specSG90CableT/2+0.2]) 
        //    cube([specSG90BrktL+thick*2+sp, d+0.2, specSG90CableT+0.4], true); 
        if (r > 0) {
            translate([0, 0, -thick/2]) cylinder(h = thick+0.2, r = r, center = true);
        }
    }
    if (back) {
        translate([sg90CenterOff()[0], (d+thick)/2, (h-thick)/2]) cube([l, thick, h+thick], true);
    }
}

// Rudders

function sg90RudderLongR() = 21;
function sg90RudderShortR() = 17.1;
function sg90RudderD() = 24.4;

module sg90RudderSp(h = 3.2, rudderH = 1.7) {
    translate([0, 0, -0.1]) union() {
        linear_extrude(rudderH+0.1) union() {
            polygon([
                [-4, -2.2],
                [-2.2, -18.8],
                [2.2, -18.8],
                [4, -2.2]
            ]);
            translate([0, -18.8, 0]) circle(2.2);
            square([20, 4.4], true);
            translate([10, 0, 0]) circle(2.2);
            translate([-10, 0, 0]) circle(2.2);
            polygon([
                [-3.4, 2.2],
                [-2.2, 14.9],
                [2.2, 14.9],
                [3.4, 2.2]
            ]);
            translate([0, 14.9, 0]) circle(2.2);
        }
        cylinder(h = h+0.2, r = 3.6);
    }
}

module sg90RudderSpTop(h = 3.2, rudderH = 1.7) {
    translate([0, 0, h]) rotate([0, 180, 0]) sg90RudderSp(h, rudderH);
}

module sg90RudderHalfSp(h = 3.2, rudderH = 1.7) {
    translate([0, 0, -0.1]) {
        linear_extrude(rudderH+0.1) union() {
            circle(3.5);
            polygon([
                [-3.5, 0],
                [-3.4, 2.2],
                [-2.2, 14.9],
                [2.2, 14.9],
                [3.4, 2.2],
                [3.5, 0]
            ]);
            translate([0, 14.9, 0]) circle(2.2);
        }
        cylinder(h = h+0.2, r = 3.6);
    }
}

module sg90RudderHalfSpTop(h = 3.2, rudderH = 1.7) {
    translate([0, 0, h]) rotate([0, 180, 0]) sg90RudderHalfSp(h, rudderH);
}

rudderSuppBallR = 3;

module sg90RudderSuppBall(r = rudderSuppBallR) {
    sphere(r);
}

module sg90RudderSupp(r = sg90RudderLongR()) {
    difference() {
        dr = r*2/3;
        d = (dr + rudderSuppBallR*2)*sin(45)*2;
        //translate([-d/2, -d/2, 0]) cube([d, d, specSG90GearTopH]);
        cylinder(h = specSG90GearTopH, r = r);
        translate([0, 0, -0.1]) sg90GearTopCentered([0.2, 0.2, 0.2]);
        for (i = [0:3]) {
            a = i*90+45;
            translate([dr*cos(a), dr*sin(a), specSG90GearTopH/2+rudderSuppBallR])
                sg90RudderSuppBall(rudderSuppBallR+0.2);
        }
    }
}

module sg90RudderSuppLong(r = sg90RudderLongR()) {
    sg90RudderSupp(r);
}

module sg90RudderSuppHalf(r = sg90RudderShortR()) {
    sg90RudderSupp(r);
}

module sg90RudderTopLong(r = sg90RudderLongR(), ball = true, rudder = true) {
    difference() {
        cylinder(h = specSG90ConH, r = r);
        if (rudder) sg90RudderSpTop(specSG90ConH);
        if (ball) {
            dr = r*2/3;
            for (i = [0:3]) {
                a = i*90+45;
                translate([dr*cos(a), dr*sin(a), specSG90ConH/2-rudderSuppBallR])
                    sg90RudderSuppBall(rudderSuppBallR+0.2);
            }
        }
        // holes for screws
        a = 18;
        ar = r*2/3;
        for (i = [a, 180-a, 180+a, -a]) {
            translate([ar*cos(i), ar*sin(i), -0.1]) hexNutScrewM25(h = specSG90ConH+0.2, nutH = 2.3);
        }
    }
}

module sg90RudderTopHalf(r = sg90RudderShortR(), ball = true, rudder = true) {
    difference() {
        cylinder(h = specSG90ConH, r = r);
        if (rudder) sg90RudderHalfSpTop(specSG90ConH);
        if (ball) {
            dr = r*2/3;
            for (i = [0:3]) {
                a = i*90+45;
                translate([dr*cos(a), dr*sin(a), specSG90ConH/2-rudderSuppBallR])
                    sg90RudderSuppBall(rudderSuppBallR+0.2);
            }
        }
        // holes for screws
        a = 18;
        ar = r*2/3;
        for (i = [0, 180, 270]) {
            translate([ar*cos(i), ar*sin(i), -0.1]) hexNutScrewM25(h = specSG90ConH+0.2, nutH = 2.3);
        }
    }
}

// Gear

module sg90Gear(r, n, h = 5) {
    difference() {
        gear(r, n, h);
        translate([0, 0, -0.1]) gear([2.45, 2.32], 21, 3.9);
    }
}
