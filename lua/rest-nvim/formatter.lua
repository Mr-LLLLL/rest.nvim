---@mod rest-nvim.formatter rest.nvim built-in response formatters
---
---@brief [[
---
--- Internal helpers that format the response body when the response filetype
--- doesn't provide a `'formatexpr'` or `'formatprg'` of its own.
---
---@brief ]]

local logger = require("rest-nvim.logger")

local formatter = {}

---Built-in formatters, used only when the response filetype has no formatter
---configured. The command is executed as a list to avoid shell quoting issues.
---@type table<string, string[]>
local defaults = {
    json = { "jq", "." },
}

---Get the built-in formatter command for the given filetype
---@param filetype string
---@return string[]? cmd
function formatter.get(filetype)
    return defaults[filetype:lower()]
end

---Format lines with the built-in formatter of the given filetype
---@param lines string[]
---@param filetype string
---@return string[] lines The formatted lines, or the original lines on failure
---@return boolean ok Whether the lines were formatted
function formatter.format(lines, filetype)
    local cmd = formatter.get(filetype)
    if not cmd then
        return lines, false
    end
    if vim.fn.executable(cmd[1]) ~= 1 then
        logger.debug(("built-in formatter `%s` (for %s) was not found"):format(cmd[1], filetype))
        return lines, false
    end

    local formatted = vim.fn.systemlist(cmd, lines)
    -- NOTE: `systemlist()` returns the formatter's error output as well, so never
    -- use it when the command failed or the response body would be replaced by it.
    if vim.v.shell_error ~= 0 or #formatted == 0 then
        logger.debug(("formatting %s with `%s` failed"):format(filetype, table.concat(cmd, " ")))
        return lines, false
    end
    return formatted, true
end

return formatter