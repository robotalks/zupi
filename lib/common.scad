module nut(n, h, r) {
    s = 360/n;
    linear_extrude(h) polygon([for (i = [0:n-1]) [r*cos(i*s), r*sin(i*s)]]);
}

module hexNut(h, r) {
    nut(6, h, r);
}

module hexNutM25(h = 2.2, r = 3.2) {
    hexNut(h, r);
}

module hexNutScrewM25(h, nutH = 2.2, screwD = 2.8) {
    hexNutM25(nutH);
    cylinder(h = h, d = screwD);
}

module gear(r, n, h) {
    s = 360/n/2;
    linear_extrude(h) polygon([for (i = [0:n*2-1]) [r[i%2]*cos(i*s), r[i%2]*sin(i*s)]]);
}

module bearBall(r = 3) {
    sphere(r);
}

hookBaseH = 4;  // base height of hook
hookBaseL = 4;  // length of hook
hookBaseD = 2;  // depth of hook
hookSizeH = 2;
hookSizeD = 2;

function makeHook(baseH, baseL = 4, baseD = 2, sizeH = 2, sizeD = 2) = [baseH, baseL, baseD, sizeH, sizeD];

module hook(params) {
    baseH = params[0];
    baseL = params[1];
    baseD = params[2];
    sizeH = params[3];
    sizeD = params[4];

    rotate([0, 90, 90]) translate([0, 0, -baseL/2])
    linear_extrude(height = baseL) polygon([
        [sizeH, 0],
        [0, -sizeD],
        [0, 0],
        [-baseH, 0],
        [-baseH, baseD],
        [sizeH, baseD]
    ]);
}

function hookLocTop(params) = [0, 0, -params[0]];
function hookLocL(params) = [0, params[1]/2, 0];
function hookLocR(params) = [0, -params[1]/2, 0];
function hookLocBack(params) = [params[2], 0, 0];
function hookLocBottom(params) = [0, 0, params[3]];
function hookLocFront(params) = [-params[4], 0, 0];
function hookLocMid(params) = [params[2]/2, 0, 0];
function hookLocBaseCenter(params) = [0, 0, -params[0]/2];

$fn = 100;

hexNutScrewM25(h = 5);
