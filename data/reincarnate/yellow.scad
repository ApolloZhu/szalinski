difference() {
  translate([0.0000000000, 33.0001196000, 4.0000000000]) {
    scale([40.0000000000, 56.0000000000, 8.0000000000]) {
      translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
        cube([1, 1, 1]);
      }
    }
  }
  difference() {
    translate([-3.8000016000, 32.9999376000, 4.0000000000]) {
      scale([32.4000000000, 40.8000000000, 8.0000000000]) {
        translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
          cube([1, 1, 1]);
        }
      }
    }
    union() {
      union() {
        union() {
          translate([-16.2000000000, 24.6000000000, 4.0000000000]) {
            scale([7.6000000000, 24.0000000000, 8.0000000000]) {
              translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
                cube([1, 1, 1]);
              }
            }
          }
          translate([-16.2000000000, 49.4000000000, 4.0000000000]) {
            scale([7.6000000000, 8.0000000000, 8.0000000000]) {
              translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
                cube([1, 1, 1]);
              }
            }
          }
        }
        translate([0.0000000000, 24.6000000000, 4.0000000000]) {
          scale([7.2000000000, 24.0000000000, 8.0000000000]) {
            translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
              cube([1, 1, 1]);
            }
          }
        }
      }
      translate([0.0000000000, 49.4000000000, 4.0000000000]) {
        scale([7.2000000000, 8.0000000000, 8.0000000000]) {
          translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
            cube([1, 1, 1]);
          }
        }
      }
    }
  }
}