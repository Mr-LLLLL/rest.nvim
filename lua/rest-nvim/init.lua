---@mod rest-nvim rest.nvim
---
---@brief [[
---
--- A fast and asynchronous Neovim HTTP client written in Lua
---
---@brief ]]

---@toc rest-contents

local rest = {}

---@deprecated use `vim.g.rest_nvim` instead
---Set up rest.nvim
---This api does nothing but set `vim.g.rest_nvim` to `user_configs`
---@param user_configs? rest.Opts User configurations
function rest.setup(user_configs)
    -- Set up rest.nvim configurations
    vim.g.rest_nvim = user_configs or {}
    -- The configuration module may have been loaded before this function runs (for
    -- example by the `http` ftplugin, which loads `rest-nvim.dotenv` and therefore
    -- `rest-nvim.config`). Reload it so late options are actually applied.
    require("rest-nvim.config").reload()
end

return rest
