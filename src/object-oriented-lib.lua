--
-- See http://lua-users.org/wiki/ObjectOrientationTutorial
--


BASE = {
	name_base = "",
	name = "",
}
BASE.__index = BASE

setmetatable(BASE, {
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		self:new(...)
		return self
	end,
})

function BASE:new(suffix)
	self.name_base = "b"
	self.name = self:make_name(suffix)
	return self
end

function BASE:make_name(suffix)
	return self.name_base .. suffix
end

function BASE:report()
	return self.name
end

function BASE:make_complex_name(suffix)
	return self:make_name(suffix)
end


-- ##############################

DERIVED = {
	count = 42,
}
DERIVED.__index = DERIVED

setmetatable(DERIVED, {
	__index = BASE,
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		self:new(...)
		return self
	end,
})

function DERIVED:make_complex_name(stuff)
	return self:report() .. stuff .. self.name_base .. self.count
end

