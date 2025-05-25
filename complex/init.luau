local e = 2.7182818285

local function REAL(n: vector)
	return n.x
end

local function IMAGINARY(n: vector)
	return n.y
end

-- Constructors
local function complex_create(real: number, imaginary: number): vector
	return vector.create(real, imaginary, 0)
end

local function complex_from_real(real: number): vector
	return vector.create(real, 0, 0)
end

local function complex_from_imaginary(imaginary: number): vector
	return vector.create(0, imaginary, 0)
end

-- Accessors
local function complex_real_part(complex_num: vector): number
	return REAL(complex_num)
end

local function complex_imaginary_part(complex_num: vector): number
	return IMAGINARY(complex_num)
end

-- Operations
local function complex_add(left: vector, right: vector): vector
	return left + right
end

local function complex_subtract(left: vector, right: vector): vector
	return left - right
end

local function complex_multiply(left: vector, right: vector): vector
	return vector.create(
		left.x * right.x - left.y * right.y,
		left.x * right.y + left.y * right.x,
		0
	)
end

local function complex_conjugate(complex_num: vector): vector
	return vector.create(REAL(complex_num), -IMAGINARY(complex_num), 0)
end

local function complex_log(z: vector): vector
	return vector.create(math.log(vector.magnitude(z)), math.atan2(IMAGINARY(z), REAL(z)), 0)
end

local function complex_exp(z: vector): vector
	local raised = e ^ REAL(z)

	return vector.create(raised * math.cos(IMAGINARY(z)), raised * math.sin(IMAGINARY(z)), 0)
end

local function complex_pow(base: vector, exponent: vector): vector
	return complex_exp(complex_multiply(exponent, complex_log(base)))
end

local function complex_lerp(a: vector, b: vector, t: vector): vector
	return complex_add(a, complex_multiply(complex_subtract(a, b), t))
end

local function complex_scale(complex_num: vector, lambda: number): vector
	return complex_num * lambda
end

local function complex_inverse(complex_num: vector): vector
	return complex_scale(complex_conjugate(complex_num), 1 / vector.dot(complex_num, complex_num))
end

local function complex_divide(left: vector, right: vector): vector
	return left * complex_inverse(right)
end

local function within_epsilon(left: vector, right: vector, epsilon: number): boolean
	return math.abs(REAL(left) - REAL(right)) < epsilon
		and math.abs(IMAGINARY(left) - IMAGINARY(right)) < epsilon
end

-- String representation
local function complex_tostring(complex_num: vector): string
	return `{REAL(complex_num)} + {IMAGINARY(complex_num)}i`
end

return {
	create = complex_create,
	from_real = complex_from_real,
	from_imaginary = complex_from_imaginary,

	real_part = complex_real_part,
	imaginary_part = complex_imaginary_part,

	add = complex_add,
	subtract = complex_subtract,
	multiply = complex_multiply,
	divide = complex_divide,

	log = complex_log,
	exp = complex_exp,
	pow = complex_pow,

	inverse = complex_inverse,
	conjugate = complex_conjugate,
	scale = complex_scale,

	within_epsilon = within_epsilon,
	tostring = complex_tostring,
	lerp = complex_lerp,
}
