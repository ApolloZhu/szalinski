difference() {
  translate([-45.0000000000, 33.0001196000, 4.0000000000]) {
    scale([40.0000000000, 56.0000000000, 8.0000000000]) {
      translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
        cube([1, 1, 1]);
      }
    }
  }
  union() {
    translate([-53.0000000000, 33.0000000000, 4.0000000000]) {
      scale([8.8000000000, 40.8000000000, 8.0000000000]) {
        translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
          cube([1, 1, 1]);
        }
      }
    }
    translate([-37.0000000000, 33.0000000000, 4.0000000000]) {
      scale([8.8000000000, 40.8000000000, 8.0000000000]) {
        translate([-0.5000000000, -0.5000000000, -0.5000000000]) {
          cube([1, 1, 1]);
        }
      }
    }
  }
}