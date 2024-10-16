function _G.SetMethods(class, obj)
  setmetatable(obj, class.methods)
  class.methods.__index = class.methods
end
