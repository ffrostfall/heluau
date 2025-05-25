local TEST, CASE, CHECK, FINISH = require("@vendor/testkit").test()

local complex = require("@complex/")
local constants = require("@constants/")

TEST("complex numbers", function()
	CASE("euler's identity")
	do
		local e = complex.from_real(constants.e)
		local product = complex.pow(e, complex.create(0, math.pi))

		CHECK(complex.real_part(product) == -1)
	end

	CASE("sqrt(-4)")
	do
		local x = complex.create(-16, 0)
		local result = complex.pow(x, complex.create(0.5, 0))

		CHECK(complex.imaginary_part(result) == 4)
	end

	CASE('tostring "1 + 2i"')
	do
		local complex_num = complex.create(1, 2)
		local str = complex.tostring(complex_num)

		CHECK(str == "1 + 2i")
	end
end)

FINISH()
