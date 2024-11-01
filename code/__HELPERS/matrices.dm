//Luma coefficients suggested for HDTVs. If you change these, make sure they add up to 1.
#define LUMA_R 0.213
#define LUMA_G 0.715
#define LUMA_B 0.072

/// Datum which stores information about a matrix decomposed with decompose().
/datum/decompose_matrix
	///?
	var/scale_x = 1
	///?
	var/scale_y = 1
	///?
	var/rotation = 0
	///?
	var/shift_x = 0
	///?
	var/shift_y = 0

/// Decomposes a matrix into scale, shift and rotation.
///
/// If other operations were applied on the matrix, such as shearing, the result
/// will not be precise.
///
/// Negative scales are now supported. =)
/matrix/proc/decompose()
	var/datum/decompose_matrix/decompose_matrix = new
	. = decompose_matrix
	var/flip_sign = (a*e - b*d < 0)? -1 : 1 // Det < 0 => only 1 axis is flipped - start doing some sign flipping
	// If both axis are flipped, nothing bad happens and Det >= 0, it just treats it like a 180° rotation
	// If only 1 axis is flipped, we need to flip one direction - in this case X, so we flip a, b and the x scaling
	decompose_matrix.scale_x = sqrt(a * a + d * d) * flip_sign
	decompose_matrix.scale_y = sqrt(b * b + e * e)
	decompose_matrix.shift_x = c
	decompose_matrix.shift_y = f
	if(!decompose_matrix.scale_x || !decompose_matrix.scale_y)
		return
	// If only translated, scaled and rotated, a/xs == e/ys and -d/xs == b/xy
	var/cossine = (a/decompose_matrix.scale_x + e/decompose_matrix.scale_y) / 2
	var/sine = (b/decompose_matrix.scale_y - d/decompose_matrix.scale_x) / 2 * flip_sign
	decompose_matrix.rotation = arctan(cossine, sine) * flip_sign

/matrix/proc/TurnTo(old_angle, new_angle)
	. = new_angle - old_angle
	Turn(.) //BYOND handles cases such as -270, 360, 540 etc. DOES NOT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT

/atom/proc/SpinAnimation(speed = 10, loops = -1, clockwise = 1, segments = 3, parallel = TRUE)
	if(!segments)
		return
	var/segment = 360/segments
	if(!clockwise)
		segment = -segment
	var/list/matrices = list()
	for(var/i in 1 to segments-1)
		var/matrix/M = matrix(transform)
		M.Turn(segment*i)
		matrices += M
	var/matrix/last = matrix(transform)
	matrices += last

	speed /= segments

	if(parallel)
		animate(src, transform = matrices[1], time = speed, loops , flags = ANIMATION_PARALLEL)
	else
		animate(src, transform = matrices[1], time = speed, loops)
	for(var/i in 2 to segments) //2 because 1 is covered above
		animate(transform = matrices[i], time = speed)
		//doesn't have an object argument because this is "Stacking" with the animate call above
		//3 billion% intentional

/**
 * Shear the transform on either or both axes.
 * * x - X axis shearing
 * * y - Y axis shearing
 */
/matrix/proc/Shear(x, y)
	return Multiply(matrix(1, x, 0, y, 1, 0))

//Dumps the matrix data in format a-f
/matrix/proc/tolist()
	. = list()
	. += a
	. += b
	. += c
	. += d
	. += e
	. += f

//Dumps the matrix data in a matrix-grid format
/*
a d 0
b e 0
c f 1
*/
/matrix/proc/togrid()
	. = list()
	. += a
	. += d
	. += 0
	. += b
	. += e
	. += 0
	. += c
	. += f
	. += 1

///The X pixel offset of this matrix
/matrix/proc/get_x_shift()
	. = c

///The Y pixel offset of this matrix
/matrix/proc/get_y_shift()
	. = f

/////////////////////
// COLOUR MATRICES //
/////////////////////

/* Documenting a couple of potentially useful color matrices here to inspire ideas
// Greyscale - indentical to saturation @ 0
list(LUMA_R,LUMA_R,LUMA_R,0, LUMA_G,LUMA_G,LUMA_G,0, LUMA_B,LUMA_B,LUMA_B,0, 0,0,0,1, 0,0,0,0)

// Color inversion
list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

// Sepiatone
list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0)
*/

//Does nothing
/proc/color_matrix_identity()
	return list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

//Adds/subtracts overall lightness
//0 is identity, 1 makes everything white, -1 makes everything black
/proc/color_matrix_lightness(power)
	return list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, power,power,power,0)

//Changes distance hues have from grey while maintaining the overall lightness. Greys are unaffected.
//1 is identity, 0 is greyscale, >1 oversaturates colors
/proc/color_matrix_saturation(value)
	var/inv = 1 - value
	var/R = round(LUMA_R * inv, 0.001)
	var/G = round(LUMA_G * inv, 0.001)
	var/B = round(LUMA_B * inv, 0.001)

	return list(R + value,R,R,0, G,G + value,G,0, B,B,B + value,0, 0,0,0,1, 0,0,0,0)

//Changes distance colors have from rgb(127,127,127) grey
//1 is identity. 0 makes everything grey >1 blows out colors and greys
/proc/color_matrix_contrast(value)
	var/add = (1 - value) / 2
	return list(value,0,0,0, 0,value,0,0, 0,0,value,0, 0,0,0,1, add,add,add,0)

//Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting greys
//0 is identity, 120 moves reds to greens, 240 moves reds to blues
/proc/color_matrix_rotate_hue(angle)
	var/sin = sin(angle)
	var/cos = cos(angle)
	var/cos_inv_third = 0.333*(1-cos)
	var/sqrt3_sin = sqrt(3)*sin
	return list(
round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), 0,
round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), 0,
round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), 0,
0,0,0,1,
0,0,0,0)

//These next three rotate values about one axis only
//x is the red axis, y is the green axis, z is the blue axis.
/proc/color_matrix_rotate_x(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(1,0,0,0, 0,cosval,sinval,0, 0,-sinval,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_y(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,0,-sinval,0, 0,1,0,0, sinval,0,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_z(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,sinval,0,0, -sinval,cosval,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)


//Returns a matrix addition of A with B
/proc/color_matrix_add(list/A, list/B)
	if(!istype(A) || !istype(B))
		return color_matrix_identity()
	if(A.len != 20 || B.len != 20)
		return color_matrix_identity()
	var/list/output = list()
	output.len = 20
	for(var/value in 1 to 20)
		output[value] = A[value] + B[value]
	return output

//Returns a matrix multiplication of A with B
/proc/color_matrix_multiply(list/A, list/B)
	if(!istype(A) || !istype(B))
		return color_matrix_identity()
	if(A.len != 20 || B.len != 20)
		return color_matrix_identity()
	var/list/output = list()
	output.len = 20
	var/x = 1
	var/y = 1
	var/offset = 0
	for(y in 1 to 5)
		offset = (y-1)*4
		for(x in 1 to 4)
			output[offset+x] = round(A[offset+1]*B[x] + A[offset+2]*B[x+4] + A[offset+3]*B[x+8] + A[offset+4]*B[x+12]+(y==5?B[x+16]:0), 0.001)
	return output

///Converts RGB shorthands into RGBA matrices complete of constants rows (ergo a 20 keys list in byond).
/proc/color_to_full_rgba_matrix(color)
	if(istext(color))
		var/list/L = ReadRGB(color)
		if(!L)
			CRASH("Invalid/unsupported color format argument in color_to_full_rgba_matrix()")
		return list(L[1]/255,0,0,0, 0,L[2]/255,0,0, 0,0,L[3]/255,0, 0,0,0,L.len>3?L[4]/255:1, 0,0,0,0)
	else if(!islist(color)) //invalid format
		return color_matrix_identity()
	var/list/L = color
	switch(L.len)
		if(3 to 5) // row-by-row hexadecimals
			. = list()
			for(var/a in 1 to L.len)
				var/list/rgb = ReadRGB(L[a])
				for(var/b in rgb)
					. += b/255
				if(length(rgb) % 4) // RGB has no alpha instruction
					. += a != 4 ? 0 : 1
			if(L.len < 4) //missing both alphas and constants rows
				. += list(0,0,0,1, 0,0,0,0)
			else if(L.len < 5) //missing constants row
				. += list(0,0,0,0)
		if(9 to 12) //RGB
			. = list(L[1],L[2],L[3],0, L[4],L[5],L[6],0, L[7],L[8],L[9],0, 0,0,0,1)
			for(var/b in 1 to 3)  //missing constants row
				. += L.len < 9+b ? 0 : L[9+b]
			. += 0
		if(16 to 20) // RGBA
			. = L.Copy()
			if(L.len < 20) //missing constants row
				for(var/b in 1 to 20-L.len)
					. += 0
		else
			CRASH("Invalid/unsupported color format argument in color_to_full_rgba_matrix()")//Returns an identity color matrix which does nothing

/proc/color_identity()
	return list(1,0,0, 0,1,0, 0,0,1)

//Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting whites
//TODO: Need a version that only affects one color (ie shift red to blue but leave greens and blues alone)
/proc/color_rotation(angle)
	if(angle == 0)
		return color_identity()
	angle = clamp(angle, -180, 180)
	var/cos = cos(angle)
	var/sin = sin(angle)

	var/constA = 0.143
	var/constB = 0.140
	var/constC = -0.283
	return list(
		LUMA_R + cos * (1-LUMA_R) + sin * -LUMA_R, LUMA_R + cos * -LUMA_R + sin * constA, LUMA_R + cos * -LUMA_R + sin * -(1-LUMA_R),
		LUMA_G + cos * -LUMA_G + sin * -LUMA_G, LUMA_G + cos * (1-LUMA_G) + sin * constB, LUMA_G + cos * -LUMA_G + sin * LUMA_G,
		LUMA_B + cos * -LUMA_B + sin * (1-LUMA_B), LUMA_B + cos * -LUMA_B + sin * constC, LUMA_B + cos * (1-LUMA_B) + sin * LUMA_B
	)

#undef LUMA_R
#undef LUMA_G
#undef LUMA_B

/atom/proc/shake_animation(var/intensity = 8) //Makes the object visibly shake
	var/initial_transform = new/matrix(transform)
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	var/rotation = 2+soft_cap(intensity, 1, 1, 0.94)
	var/offset = 1+soft_cap(intensity*0.3, 1, 1, 0.8)
	var/time = 2+soft_cap(intensity*0.3, 2, 1, 0.92)
	animate(src, transform=turn(transform, rotation*shake_dir), pixel_x=init_px + offset*shake_dir, time=1)
	animate(transform=initial_transform, pixel_x=init_px, time=time, easing=ELASTIC_EASING)

/*
	This proc makes the input taper off above cap. But there's no absolute cutoff.
	Chunks of the input value above cap, are reduced more and more with each successive one and added to the output
	A higher input value always makes a higher output value. but the rate of growth slows
*/
/proc/soft_cap(var/input, var/cap = 0, var/groupsize = 1, var/groupmult = 0.9)

	//The cap is a ringfenced amount. If we're below that, just return the input
	if (input <= cap)
		return input

	var/output = 0
	var/buffer = 0
	var/power = 1//We increment this after each group, then apply it to the groupmult as a power

	//Ok its above, so the cap is a safe amount, we move that to the output
	input -= cap
	output += cap

	//Now we start moving groups from input to buffer


	while (input > 0)
		buffer = min(input, groupsize)	//We take the groupsize, or all the input has left if its less
		input -= buffer

		buffer *= groupmult**power //This reduces the group by the groupmult to the power of which index we're on.
		//This ensures that each successive group is reduced more than the previous one

		output += buffer
		power++ //Transfer to output, increment power, repeat until the input pile is all used

	return output

/datum/ColorMatrix
	var/list/matrix
	var/combined = 1
	var/const/lumR = 0.3086 //  or  0.2125
	var/const/lumG = 0.6094 //  or  0.7154
	var/const/lumB = 0.0820 //  or  0.0721

/datum/ColorMatrix/New(mat, contrast = 1, brightness = null)
	..()

	if(istext(mat))
		SetPreset(mat)
		if(!matrix)
			SetColor(mat, contrast, brightness)
	else if(isnum(mat))
		SetSaturation(mat, contrast, brightness)
	else
		matrix = mat

/datum/ColorMatrix/proc/Reset()
	matrix = list(1,0,0,
				  0,1,0,
				  0,0,1)

/datum/ColorMatrix/proc/Get(contrast = 1)
	var/list/mat = matrix
	mat = mat.Copy()

	for(var/i = 1 to min(mat.len, 12))
		mat[i] *= contrast

	return mat

/datum/ColorMatrix/proc/SetSaturation(s, c = 1, b = null)
	var/sr = (1 - s) * lumR
	var/sg = (1 - s) * lumG
	var/sb = (1 - s) * lumB

	matrix = list(c * (sr + s), c * (sr),     c * (sr),
				  c * (sg),     c * (sg + s), c * (sg),
				  c * (sb),     c * (sb),     c * (sb + s))

	SetBrightness(b)

/datum/ColorMatrix/proc/SetBrightness(brightness)
	if(brightness == null) return

	if(!matrix)
		Reset()


	if(matrix.len == 9 || matrix.len == 16)
		matrix += brightness
		matrix += brightness
		matrix += brightness

		if(matrix.len == 16)
			matrix += 0

	else if(matrix.len == 12)
		for(var/i = matrix.len to matrix.len - 3 step -1)
			matrix[i] = brightness

	else if(matrix.len == 3)
		for(var/i = matrix.len - 1 to matrix.len - 4 step -1)
			matrix[i] = brightness

/datum/ColorMatrix/proc/hex2value(hex)
	var/num1 = copytext(hex, 1, 2)
	var/num2 = copytext(hex, 2)

	if(isnum(text2num(num1)))
		num1 = text2num(num1)
	else
		num1 = text2ascii(lowertext(num1)) - 87

	if(isnum(text2num(num1)))
		num2 = text2num(num1)
	else
		num2 = text2ascii(lowertext(num2)) - 87

	return num1 * 16 + num2

/datum/ColorMatrix/proc/SetColor(color, contrast = 1, brightness = null)
	var/rr = hex2value(copytext(color, 2, 4)) / 255
	var/gg = hex2value(copytext(color, 4, 6)) / 255
	var/bb = hex2value(copytext(color, 6, 8)) / 255

	rr = round(rr * 1000) / 1000 * contrast
	gg = round(gg * 1000) / 1000 * contrast
	bb = round(bb * 1000) / 1000 * contrast

	matrix = list(rr, gg, bb,
				  rr, gg, bb,
				  rr, gg, bb)

	SetBrightness(brightness)

/datum/ColorMatrix/proc/SetPreset(preset)
	switch(lowertext(preset))
		if("invert")
			matrix = list(-1,0,0,
						  0,-1,0,
						  0,0,-1,
						  1,1,1)
		if("nightsight")
			matrix = list(1,1,1,
						  0,0,0,
						  0,0,0,
						  0.25,0.25,0.25)
		if("nightsight_glasses")
			matrix = list(1,1,1,
						  0,0,0,
						  0,0,0,
						  0.1,0.1,0.1)
		if("thermal")
			matrix = list(1.1, 0, 0,
						  0, 1, 0,
						  0, 0, 1,
						  0, 0, 0)
		if("hos")
			matrix = list(1.2, 0.1, 0,
						  0, 1, 0,
						  0, 0, 1,
						  0, 0, 0)
		if("yellow")
			matrix = list(1.2, 0.1, 0,
						  0, 1, 0,
						  0, 0, 1,
						  -0.05, -0.05, -0.05)
		if("nvg")
			matrix = list(1,0,0,
						  0,1.1,0,
						  0,0,1,
						  0,0,0)
		if("meson")
			matrix = list(1, 0, 0,
						  0, 1.1, 0,
						  0, 0, 1,
						  -0.05, -0.05, -0.05)
		if("sci")
			matrix = list(1, 0, 0.05,
						  0.05, 0.95, 0.05,
						  0.05, 0, 1,
						  0, 0, 0)
		if("greyscale")
			matrix =  list(0.33, 0.33, 0.33,
						   0.33, 0.33, 0.33,
						   0.33, 0.33, 0.33,
						   0, 0, 0)
		if("sepia")
			matrix = list(0.393,0.349,0.272,
						  0.769,0.686,0.534,
						  0.189,0.168,0.131,
						  0,0,0)
		if("black & white")
			matrix = list(1.5,1.5,1.5,
						  1.5,1.5,1.5,
						  1.5,1.5,1.5,
						  -1,-1,-1)
		if("polaroid")
			matrix = list(1.438,-0.062,-0.062,
						  0.122,1.378,-0.122,
						  0.016,-0.016,1.483,
						  -0.03,0.05,-0.02)
		if("bgr_d")
			matrix = list(0,0,1,
						  0,1,0,
						  1,0,0,
						  0,0,-0.5)
		if("brg_d")
			matrix = list(0,0,1,
						  1,0,0,
						  0,1,0,
						  0,-0.5,0)
		if("gbr_d")
			matrix = list(0,1,0,
						  0,0,1,
						  1,0,0,
						  0,0,-0.5)
		if("grb_d")
			matrix = list(0,1,0,
						  1,0,0,
						  0,0,1,
						  0,-0.5,0)
		if("rbg_d")
			matrix = list(1,0,0,
						  0,0,1,
						  0,1,0,
						  -0.5,0,0)
		if("rgb_d")
			matrix = list(1,0,0,
						  0,1,0,
						  0,0,1,
						  -0.3,-0.3,-0.3)
		if("rgb")
			matrix = list(1,0,0,
						  0,1,0,
						  0,0,1,
						  0,0,0)
