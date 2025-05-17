local complex = require(@complex)

-- Constructors
local function f64_array_create(n: number): buffer
   return buffer.create(8 * n)
end

local function f32_array_create(n: number): buffer
   return buffer.create(4 * n)
end

local function c32_array_create(n: number): buffer
   return buffer.create(8 * n)
end

-- Getters
local function f64_read_index(array: buffer, index: number): number
   return buffer.readf64(array, 8 * index)
end

local function f32_read_index(array: buffer, index: number): number
   return buffer.readf32(array, 4 * index)
end

local function c32_read_index(array: buffer, index: number): vector
   return vector.create(
      buffer.readf32(array, 8 * index),
      buffer.readf32(array, 8 * index + 4),
      0
   )
end

-- Setters
local function f64_write_index(array: buffer, index: number, value: number): buffer
   return buffer.writef64(array, 8 * index, value)
end

local function f32_write_index(array: buffer, index: number, value: number): buffer
   return buffer.writef32(array, 4 * index, value)
end

local function c32_write_index(array: buffer, index: number, value: vector): buffer
   buffer.writef32(array, 8 * index, vector.x)
   return buffer.writef32(array, 8 * index + 4, vector.y)
end

--Length
local function f64_len(array: buffer): number
   return buffer.len(array) / 8
end

local function f32_len(array: buffer): number
   return buffer.len(array) / 4
end

local function c32_len(array: buffer): number
   return buffer.len(array) / 8
end

local function f64_size(array: buffer): number
   return {buffer.len(array) / 8}
end

local function f32_size(array: buffer): number
   return {buffer.len(array) / 4}
end

local function c32_size(array: buffer): number
   return {buffer.len(array) / 8}
end

--Algebra and Arithmetic
local function float_add(number_one: number, number_two: number): number
   return number_one + number_two
end

local function float_sub(number_one: number, number_two: number): number
   return number_one - number_two
end

local function vector_add(vector_one: vector, vector_two: vector): vector
   return vector_one + vector_two
end

local function vector_sub(vector_one: vector, vector_two: vector): vector
   return vector_one - vector_two
end

--Mapping Functions
local function array_map(array: buffer,
			 read_function: (buffer, number) -> (number | vector | buffer),
			 write_function: (buffer, number, number | vector | buffer) -> buffer,
			 length_function: buffer -> number,
			 create_function: number -> buffer,
			 unary_function: (number | vector | buffer) -> (number | vector | buffer))
   local n = length_function(array)
   local ancilla = create_function(n)
   for index = 0, n - 1 do
      write_function(ancilla,
		     index,
		     unary_function(read_function(array, index))
      )
   end
   return ancilla
end

local function array_binary_map(array_one: buffer,
				array_two: buffer,
				read_function: (buffer, number) -> (number | vector | buffer),
				write_function: (buffer, number, number | vector | buffer) -> buffer,
				length_function: buffer -> number,
				create_function: number -> buffer,
				binary_function: (number | vector | buffer, number | vector | buffer) -> (number | vector | buffer))
   local n = length_function(array_one)
   local ancilla = create_function(n)
   for index = 0, n - 1 do
      write_function(ancilla,
		     index,
		     binary_function(read_function(array_one, index),
				     read_function(array_two, index)
		     )
      )
   end
   return ancilla
end

local function array_parameterized_binary_map(array_one: buffer,
					      array_two: buffer,
					      parameter: number | buffer | vector,
					      read_function: (buffer, number) -> (number | vector | buffer),
					      write_function: (buffer, number, number | vector | buffer) -> buffer,
					      length_function: buffer -> number,
					      create_function: number -> buffer,
					      parameterized_binary_function: (number | vector | buffer, number | vector | buffer, number | buffer | vector) -> (number | vector | buffer))
   local n = length_function(array_one)
   local ancilla = create_function(n)
   for index = 0, n - 1 do
      write_function(ancilla,
		     index,
		     parameterized_binary_function(read_function(array_one, index),
						   read_function(array_two, index),
						   parameter
		     )
      )
   end
   return ancilla
end

--Addition
local function f64_array_add(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   f64_read_index,
			   f64_write_index,
			   f64_len,
			   f64_array_create,
			   float_add
   )
end

local function f32_array_add(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   f32_read_index,
			   f32_write_index,
			   f32_len,
			   f32_array_create,
			   float_add
   )
end

local function c32_array_add(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   c32_read_index,
			   c32_write_index,
			   c32_len,
			   c32_array_create,
			   complex.addition
   )
end

--Subtraction
local function f64_array_sub(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   f64_read_index,
			   f64_write_index,
			   f64_len,
			   f64_array_create,
			   float_sub
   )
end

local function f32_array_sub(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   f32_read_index,
			   f32_write_index,
			   f32_len,
			   f32_array_create,
			   float_sub
   )
end

local function c32_array_sub(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   c32_read_index,
			   c32_write_index,
			   c32_len,
			   c32_array_create,
			   complex.addition
   )
end

--Hadamard Multiplication
local function f64_array_mul(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   f64_read_index,
			   f64_write_index,
			   f64_len,
			   f64_array_create,
			   float_mul
   )
end

local function f32_array_mul(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   f32_read_index,
			   f32_write_index,
			   f32_len,
			   f32_array_create,
			   float_mul
   )
end

local function c32_array_mul(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array_one,
			   array_two,
			   c32_read_index,
			   c32_write_index,
			   c32_len,
			   c32_array_create,
			   complex.multiplication
   )
end

local function f32_array_exp(array: buffer): buffer
   return array_map(array,
		    f32_read_index,
		    f32_write_index,
		    f32_len,
		    f32_array_create,
		    math.exp
   )
end

local function f64_array_exp(array: buffer): buffer
   return array_map(array,
		    f64_read_index,
		    f64_write_index,
		    f64_len,
		    f64_array_create,
		    math.exp
   )
end

local function f32_array_imag_exp(array: buffer): buffer
   return array_map(array,
		    f32_read_index,
		    c32_write_index,
		    f32_len,
		    c32_array_create,
		    complex.imag_exp
   )
end		    

--Scaling
local function f64_array_scale(array: buffer, scalar: number): buffer
   return array_map(array,
		    f64_read_index,
		    f64_write_index,
		    f64_len,
		    f64_array_create,
		    function(x: number): number return scalar * x end
   )
end

local function f32_array_scale(array: buffer, scalar: number): buffer
   return array_map(array,
		    f32_read_index,
		    f32_write_index,
		    f32_len,
		    f32_array_create,
		    function(x: number): number return scalar * x end
   )
end

local function c32_array_scale(array: buffer, scalar: number): buffer
   return array_map(array,
		    c32_read_index,
		    c32_write_index,
		    c32_len,
		    c32_array_create,
		    function(x: vector): vector return scalar * x end
   )
end

--Realization and Complexification
local function c32_array_to_f32_real(array: buffer): buffer
   return array_map(array,
		    c32_read_index,
		    f32_write_index,
		    c32_len,
		    f32_array_create,
		    complex.real_part
   )
end

local function c32_array_to_f64_real(array: buffer): buffer
   return array_map(array,
		    c32_read_index,
		    f64_write_index,
		    c32_len,
		    f64_array_create,
		    complex.real_part
   )
end

local function c32_array_to_f32_imag(array: buffer): buffer
   return array_map(array,
		    c32_read_index,
		    f32_write_index,
		    c32_len,
		    f32_array_create,
		    complex.imaginary_part
   )
end

local function c32_array_to_f64_imag(array: buffer): buffer
   return array_map(array,
		    c32_read_index,
		    f64_write_index,
		    c32_len,
		    f64_array_create,
		    complex.imaginary_part
   )
end


local function f32_array_to_c32(array: buffer): buffer
   return array_map(array,
		    f32_read_index,
		    c32_write_index,
		    f32_len,
		    c32_array_create,
		    complex.from_real
   )
end

local function f64_array_to_c32(array: buffer): buffer
   return array_map(array,
		    f64_read_index,
		    c32_write_index,
		    f64_len,
		    c32_array_create,
		    complex.from_real
   )
end

local function two_f32_array_to_c32(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array,
			   f32_read_index,
			   c32_write_index,
			   f32_len,
			   c32_array_create,
			   complex.create
   )
end

local function two_f64_array_to_c32(array_one: buffer, array_two: buffer): buffer
   return array_binary_map(array,
			   f64_read_index,
			   c32_write_index,
			   f64_len,
			   c32_array_create,
			   complex.create
   )
end

--Lerp
local function f32_array_lerp(array_one: buffer,
			      array_two: buffer,
			      interp_param: number): buffer
   return array_parameterized_binary_map(array_one,
					 array_two,
					 inter_param,
					 f32_read_index,
					 f32_write_index,
					 f32_len,
					 f32_array_create,
					 math.lerp
   )
end

local function f64_array_lerp(array_one: buffer,
			      array_two: buffer,
			      interp_param: number): buffer
   return array_parameterized_binary_map(array_one,
					 array_two,
					 inter_param,
					 f64_read_index,
					 f64_write_index,
					 f64_len,
					 f64_array_create,
					 math.lerp
   )
end

local function c32_array_lerp(array_one: buffer,
			      array_two: buffer,
			      interp_param: number): buffer
   return array_parameterized_binary_map(array_one,
					 array_two,
					 inter_param,
					 c32_read_index,
					 c32_write_index,
					 c32_len,
					 c32_array_create,
					 complex.lerp
   )
end

--Structural Operations
local function array_concatenate(array_one: buffer,
				 array_two: buffer): buffer
   local byte_length_one = buffer.len(array_one)
   local byte_length_two = buffer.len(array_two)
   local ancilla = buffer.create(byte_length_one + byte_length_two)
   buffer.copy(ancilla, 0, array_one)
   return buffer.copy(ancilla, byte_length_one, array_two)
end

return {
   concatenate = array_concatenate,
   map = array_map,
   binary_map = array_binary_map,
   parameterized_binary_map = parameterized_binary_map,
   
   f32 = {
      create = f32_array_create,

      read = f32_read_index,
      write = f32_write_index,

      length = f32_len,

      add = f32_array_add,
      subtract = f32_array_sub,
      multiply = f32_array_multiply,

      exp = f32_array_exp,
      imag_exp = f32_array_imag_exp,

      lerp = f32_array_lerp,

      scale = f32_array_scale
   },
   f64 = {
      create = f64_array_create,

      read = f64_read_index,
      write = f64_write_index,

      length = f64_len,

      add = f64_array_add,
      subtract = f64_array_sub,
      multiply = f64_array_multiply,

      lerp = f64_array_lerp,

      exp = f64_array_exp,
      image_exp = f64_array_image_exp,

      scale = f64_array_scale
   },
   c32 = {
      create = c32_array_create,

      read = c32_read_index,
      write = c32_write_index,

      length = c32_len,
      size = 

      add = c32_array_add,
      subtract = c32_array_sub,
      multiply = c32_array_multiply,

      lerp = c32_array_lerp,

      exp = c32_array_exp,
      image_exp = c32_array_image_exp,

      scale = c32_array_scale
   }
}
