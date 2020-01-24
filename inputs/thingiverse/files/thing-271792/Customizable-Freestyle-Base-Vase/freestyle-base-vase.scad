// Customizable Freestyle Base Vase
// preview[view:south]

/* [Basic Vase Shape] */

// Hit "Clear" below to erase the default shape. Then click and drag to draw an outline for the bottom of your vase. (Disregard errors that may appear while the box is empty.)
base_shape = [[[-0.028767123287671233,0.0410958904109589],[-0.015068493150684932,0.043835616438356165],[0.012328767123287671,0.04657534246575343],[0.026027397260273973,0.04657534246575343],[0.04246575342465753,0.052054794520547946],[0.06164383561643835,0.052054794520547946],[0.08356164383561644,0.057534246575342465],[0.10273972602739725,0.06027397260273973],[0.12465753424657534,0.06575342465753424],[0.18767123287671234,0.11506849315068493],[0.19315068493150686,0.12876712328767123],[0.1958904109589041,0.14246575342465753],[0.19863013698630136,0.15616438356164383],[0.21506849315068494,0.23013698630136986],[0.24246575342465754,0.273972602739726],[0.2534246575342466,0.28493150684931506],[0.2671232876712329,0.29315068493150687],[0.31643835616438354,0.29315068493150687],[0.33013698630136984,0.2821917808219178],[0.3547945205479452,0.2136986301369863],[0.3547945205479452,0.2],[0.3547945205479452,0.18082191780821918],[0.3547945205479452,0.18082191780821918],[0.3356164383561644,0.09863013698630137],[0.3356164383561644,0.09863013698630137],[0.3356164383561644,0.08493150684931507],[0.3356164383561644,0.08493150684931507],[0.3356164383561644,0.07123287671232877],[0.3356164383561644,0.07123287671232877],[0.33835616438356164,-0.021917808219178082],[0.34383561643835614,-0.0410958904109589],[0.34657534246575344,-0.06301369863013699],[0.3547945205479452,-0.07945205479452055],[0.4123287671232877,-0.16712328767123288],[0.41506849315068495,-0.18356164383561643],[0.41506849315068495,-0.19726027397260273],[0.36027397260273974,-0.2493150684931507],[0.34657534246575344,-0.2547945205479452],[0.33013698630136984,-0.2547945205479452],[0.33013698630136984,-0.2547945205479452],[0.24246575342465754,-0.24383561643835616],[0.24246575342465754,-0.24383561643835616],[0.22054794520547946,-0.23835616438356164],[0.22054794520547946,-0.23835616438356164],[0.20684931506849316,-0.23835616438356164],[0.20684931506849316,-0.23835616438356164],[0.19041095890410958,-0.2356164383561644],[0.19041095890410958,-0.2356164383561644],[0.17123287671232876,-0.2356164383561644],[0.17123287671232876,-0.2356164383561644],[0.08082191780821918,-0.26301369863013696],[0.06712328767123288,-0.27123287671232876],[0.056164383561643834,-0.27945205479452057],[0.03972602739726028,-0.29041095890410956],[-0.02054794520547945,-0.3561643835616438],[-0.036986301369863014,-0.36712328767123287],[-0.056164383561643834,-0.38082191780821917],[-0.06986301369863014,-0.3863013698630137],[-0.08356164383561644,-0.3917808219178082],[-0.14657534246575343,-0.3972602739726027],[-0.16301369863013698,-0.3972602739726027],[-0.17945205479452056,-0.3917808219178082],[-0.19315068493150686,-0.3863013698630137],[-0.24794520547945206,-0.3452054794520548],[-0.25616438356164384,-0.3315068493150685],[-0.26438356164383564,-0.32054794520547947],[-0.26986301369863014,-0.30684931506849317],[-0.27534246575342464,-0.29041095890410956],[-0.3082191780821918,-0.20273972602739726],[-0.31095890410958904,-0.18904109589041096],[-0.3136986301369863,-0.17534246575342466],[-0.31643835616438354,-0.1589041095890411],[-0.31643835616438354,-0.1589041095890411],[-0.31095890410958904,-0.07945205479452055],[-0.31095890410958904,-0.07945205479452055],[-0.30273972602739724,-0.06301369863013699],[-0.30273972602739724,-0.06301369863013699],[-0.29178082191780824,-0.049315068493150684],[-0.28356164383561644,-0.038356164383561646],[-0.28356164383561644,-0.038356164383561646],[-0.2232876712328767,0.024657534246575342],[-0.21232876712328766,0.03287671232876712],[-0.21232876712328766,0.03287671232876712],[-0.1684931506849315,0.052054794520547946],[-0.14931506849315068,0.052054794520547946],[-0.13561643835616438,0.057534246575342465],[-0.08356164383561644,0.057534246575342465],[-0.06986301369863014,0.057534246575342465],[-0.036986301369863014,0.043835616438356165]],[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88]]]; // [draw_polygon]

// Width of vase shape draw box (mm). Actual width may differ.
base_width  = 100;

// Height of vase shape draw box (mm). Actual height may differ.
base_height = 100;

// Extruded height of vase (mm).
vase_height = 60;

// Clockwise rotation of top relative to bottom (degrees).
vase_twist = 45;

// For twisted vases, more layers yield smoother sides; fewer layers yield faceted or flat sides. Minimum: 1.
vase_layers = 60;

// Size of top relative to bottom.
top_scale = 1.4;

/* [Bonus Modes] */

// Merge your basic vase design with transformed copies of itself. Bonus!
bonus_mode = 0; // [0:None, 1:Mirrored, 2:Multiples]

// Flip the mirrored copy in which direction? Applies only in Mirrored mode.
mirror_direction = 0; // [0:Horizontal, 1:Vertical]

// Total number of instances of the basic vase to merge. Applies only in Multiples mode.
multiple_instances = 3;

// Counterclockwise offset of each instance (degrees). Applies only in Multiples mode.
multiple_twist = 60;

union() {
	
	// We start with one unmodified instance, regardless of mode.
	VaseInstance();
	
	// Mirrored mode - add a second instance mirrored in the given direction.
	if (bonus_mode == 1) {
		mirror([mirror_direction == 0 ? 1 : 0, mirror_direction == 1 ? 1 : 0, 0])
		VaseInstance();
	}
	
	// Multiples mode - add multiple copies rotated by increments around origin.
	else if (bonus_mode == 2) {
		if (multiple_instances > 1) {
			for (instance = [1 : multiple_instances - 1]) {
				rotate([0, 0, instance * multiple_twist])
				VaseInstance();
			}
		}
	}
	
	// What other interesting forms can you make by combining
	// various transformations of the basic VaseInstance?
}
 
// This module generates one instance of the basic vase:
// the polygon drawing is scaled to size and extruded into 3D.
module VaseInstance() {

	linear_extrude(
			height = vase_height,
			slices = vase_layers,
			twist  = vase_twist,
			scale  = top_scale)

	scale([base_width, base_height, 1])		
	
	polygon(
			points = base_shape[0],
			paths  = base_shape[1]);

}