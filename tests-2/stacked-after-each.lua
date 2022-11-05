describe("use stacked after_each to ensure a cleanup step runs", function()

	local left

	setup(function()
		print("XX: Expect this test to fail, but the cleanup step will still run")
	end)

	after_each(function()
		assert.is_true(left)
		print("WE NEVER GET TO THIS STATEMENT")
	end)

	after_each(function()
		print("A CLEANUP STEP")
	end)

	it("pass after_each", function()
		left = false
	end)

end)

