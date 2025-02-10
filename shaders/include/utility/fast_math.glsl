#if !defined INCLUDE_UTILITY_FAST_MATH
#define INCLUDE_UTILITY_FAST_MATH

// Faster alternative to acos
// Source: https://seblagarde.wordpress.com/2014/12/01/inverse-trigonometric-functions-gpu-optimization-for-amd-gcn-architecture/#more-3316
// Max relative error: 3.9 * 10^-4
// Max absolute error: 6.1 * 10^-4
// Polynomial degree: 2
float fast_acos(float x) {
	const float C0 = 1.57018;
	const float C1 = -0.201877;
	const float C2 = 0.0464619;

	float res = (C2 * abs(x) + C1) * abs(x) + C0; // p(x)
	res *= sqrt(1.0 - abs(x));

	return x >= 0 ? res : pi - res; // Undo range reduction
}
vec2 fast_acos(vec2 v) { return vec2(fast_acos(v.x), fast_acos(v.y)); }

// Spherical linear interpolation of two unit vectors
vec3 slerp(vec3 v0, vec3 v1, float t) {
	float cos_theta = dot(v0, v1);
	if (cos_theta > 0.999) return v0;

	float theta = fast_acos(cos_theta);
	float rcp_sin_theta = rcp(sin(theta));
	
	float w0 = rcp_sin_theta * sin((1.0 - t) * theta);
	float w1 = rcp_sin_theta * sin(t * theta);

	return v0 * w0 + v1 * w1;
}

float pow4(float x) { return sqr(sqr(x)); }
float pow5(float x) { return pow4(x) * x; }
float pow6(float x) { return sqr(cube(x)); }
float pow7(float x) { return pow6(x) * x; }
float pow8(float x) { return sqr(pow4(x)); }

float pow12(float x) {
	return cube(pow4(x));
}

float pow16(float x) {
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	return x;
}

float pow32(float x) {
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	return x;
}

float pow64(float x) {
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	return x;
}

float pow128(float x) {
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	x *= x;
	return x;
}

float pow1d5(float x) {
	return x * sqrt(x);
}

float rcp_length(vec2 v) { return inversesqrt(dot(v, v)); }
float rcp_length(vec3 v) { return inversesqrt(dot(v, v)); }

// Computes the length of a vector and normalizes it using one inversesqrt
void length_normalize(vec2 v, out vec2 normalized, out float len) {
	float len_sq = length_squared(v);
	float rcp_len = inversesqrt(len_sq);
	len = len_sq * rcp_len;
	normalized = rcp_len * v;
}
void length_normalize(vec3 v, out vec3 normalized, out float len) {
	float len_sq = length_squared(v);
	float rcp_len = inversesqrt(len_sq);
	len = len_sq * rcp_len;
	normalized = rcp_len * v;
}

vec2 clamp_length(vec2 v, float min_len, float max_len) {
	float len; vec2 normalized;
	length_normalize(v, normalized, len);

	return normalized * clamp(len, min_len, max_len);
}

vec3 clamp_length(vec3 v, float min_len, float max_len) {
	float len; vec3 normalized;
	length_normalize(v, normalized, len);

	return normalized * clamp(len, min_len, max_len);
}

// compute the length of a vector, knowing its direction
float length_knowing_direction(vec3 v, vec3 v_norm) {
	if (v_norm.x != 0.0) { 
		return abs(v.x / v_norm.x);
	} else if (v_norm.y != 0.0) {
		return abs(v.y / v_norm.y);
	} else {
		return abs(v.z / v_norm.z);
	}
}

#endif // INCLUDE_UTILITY_FAST_MATH
