local policy = require('apicast.policy')
local _M = policy.new('GUID policy', '0.1')

local new = _M.new
local random = math.random

local function uuid()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
      return string.format('%x', v)
  end)
end

function _M.new(config)
  local self = new(config)

  self.header_name = config.header_name

  return self
end

function _M:rewrite()
  local header_name = self.header_name or 'GUID'
  local req_headers = ngx.req.get_headers() or {}

  if req_headers[header_name] == nil then
    ngx.req.set_header(header_name, uuid())
  end
end

return _M
