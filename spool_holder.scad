use <BOSL/threading.scad>;
use <BOSL/transforms.scad>;

$threaded_sleeve = true;
$spool_holder = true;
$assembled = false;

$fa = 0.01;
$fs = 0.3;
$epsilon = 0.01;
$infty = 1000;

support_dia = 20;
support_dia_tol = 1.3;

thread_len = 120;
thread_min_width = 2;
thread_pitch = 5;
thread_slop = 0.35;
thread_depth = thread_pitch / 4;
thread_dia = support_dia + support_dia_tol + thread_min_width + thread_pitch;

spool_holder_h = 15;
spool_holder_max_dia = 80;
spool_holder_min_dia = 40;
spool_holder_min_wall = 3;
spool_holder_nut_dia = thread_dia + 2 * (thread_slop + spool_holder_min_wall);

module support() {
    cylinder(d=support_dia, h=$infty, center=true);
}

module support_hole() {
    cylinder(d=support_dia + support_dia_tol, h=$infty, center=true);
}

module threaded_sleeve() {
    difference() {
        trapezoidal_threaded_rod(d=thread_dia, l=thread_len, pitch=thread_pitch,
                                 thread_angle=45, thread_depth=thread_pitch/4,
                                 slop=thread_slop);
        support_hole();
    }
}

module spool_holder_basic() {
    difference() {
        cylinder(d1=spool_holder_max_dia, d2=spool_holder_min_dia, h=spool_holder_h);

 	d = sqrt(2) * spool_holder_max_dia/2 - spool_holder_min_wall;
        for (i = [0:2]) rotate(120 * i, [0, 0, 1]) {
            translate([spool_holder_max_dia/2, 0, -$epsilon])
                cylinder(h=spool_holder_h + 2 * $epsilon, d=d);
        }
    }
}

module spool_holder_nut() {
    difference() {
        cylinder(d=spool_holder_nut_dia, h=spool_holder_h);
        trapezoidal_threaded_rod(d=thread_dia, l=thread_len, pitch=thread_pitch,
                                 thread_angle=45, thread_depth=thread_pitch/4,
                                 slop=thread_slop, internal=true);
    }
}

module spool_holder() {
    difference() {
        spool_holder_basic();
        cylinder(d=spool_holder_nut_dia - $epsilon, h=$infty, center=true);
    }
    spool_holder_nut();
}

if ($threaded_sleeve) threaded_sleeve();
if ($spool_holder) spool_holder();

if ($assembled) rotate([0, 90, 0]) {
    support_len = 150;
    top_half(z=-support_len/2, s=$infty) bottom_half(z=support_len/2, s=$infty) support();
    threaded_sleeve();
    zflip_copy(offset=-5*thread_pitch) spool_holder();
}

