local t = {
	trunner = function(answer)
		print("T:i have the answer: " .. answer)
	end
}

function runner(answer)
	print("i have the answer: " .. answer)
end

function get_uname()
	local handle = io.popen("uname 2>&1")
	if handle == nil then
		return false, "popen did not happen"
	end

	local result = handle:read("*a")
	local rc = {handle:close()}
	if rc[3] ~= 0 then
		return false, result
	end
	return true, result
end

describe("play wth mocks", function()

	it("registers a spy as a callback", function()
		local s = spy.new(function() end)

		s(1, 2, 3)
		s(4, 5, 6)

		assert.spy(s).was.called()
		assert.spy(s).was.called(2)
		assert.spy(s).was.called_with(1, 2, 3)
	end)

	it("overrides the answer", function()
		stub(t, "trunner")

		t.trunner("fifty")
		assert.stub(t.trunner).was.called()

		t.trunner:revert()
		t.trunner("fifty-one")
	end)

	context("isolate a spy's effect", function()
		-- Isolate a spy in this test.  Using insulate() for the
		-- context didn't help; this requires the revert().
		local myspy
		before_each(function()
			myspy = spy.on(io, "popen")
		end)
		after_each(function()
			io.popen:revert()
		end)
			
		it("can spy on io.popen", function()
			local rc, val = get_uname()
			print("Spy uname: " .. val)
			assert.is_true(rc)
			assert.spy(myspy).was_called()
		end)
	end)

	context("isolate a stub's effect", function()
		-- Isolate the stub in this test so it doesn't affect the
		-- next test.  Using insulate() for the context didn't help;
		-- this requires the revert().
		before_each(function()
			stub(io, "popen")
		end)
		after_each(function()
			io.popen:revert()
		end)
		it("can stub io.popen", function()
			local rc, val = get_uname()
			print("Stub uname: " .. val)
			assert.is_not_true(rc)
			assert.is_equal(val, "popen did not happen")
			assert.stub(io.popen).was.called()
		end)
	end)

	-- Use the lessons learned above about isolating the effect of spies
	-- and stubs, and do it with mock.
	context("isolate a mock's spy effect", function()
		local mymock
		before_each(function()
			-- mock adds spies for the functions in the io table.
			mymock = mock(io)
		end)
		after_each(function()
			mock.revert(mymock)
		end)

		it("can mock io.popen with a spy", function()
			local rc, val = get_uname()
			print("Mock spy uname: " .. val)
			assert.is_true(rc)
			assert.spy(mymock.popen).was.called()
		end)
	end)

	-- Use the lessons learned above about isolating the effect of spies
	-- and stubs, and do it with mock.
	context("isolate a mock's stub effect", function()
		local mymock
		before_each(function()
			-- mock adds stubs for the functions in the io table.
			mymock = mock(io, true)
		end)
		after_each(function()
			mock.revert(mymock)
		end)

		it("can mock io.popen with a spy", function()
			local rc, val = get_uname()
			print("Mock stub uname: " .. val)
			assert.is_not_true(rc)
			assert.is_equal(val, "popen did not happen")
			assert.stub(mymock.popen).was.called()
		end)
	end)
end)

