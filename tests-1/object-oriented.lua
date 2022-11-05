require("src/object-oriented-lib")

math.randomseed(os.time())

describe("show objects and inheritance", function()

	it("uses base", function()
		local suffix = math.random(1000)
		local wanted = "b"..suffix
		local a = BASE(suffix)
		assert.is_equal(a:report(), wanted)

		local suffix = math.random(1000)
		local wanted = "b"..suffix
		local b = a:make_complex_name(suffix)
		assert.is_equal(b, wanted)
	end)

	it("uses derived", function()
		local suffix = math.random(1000)
		local wanted = "b"..suffix
		local a = DERIVED(suffix)
		assert.is_equal(a:report(), wanted)

		local stuff = math.random(1000)
		local wanted = "b"..suffix..stuff.."b".."42"
		local b = a:make_complex_name(stuff)
		assert.is_equal(b, wanted)

	end)

end)


