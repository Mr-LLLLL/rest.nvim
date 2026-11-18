describe("config", function()
    it("reload() applies options set after the module was loaded", function()
        local original = vim.g.rest_nvim
        local config = require("rest-nvim.config")

        assert.is_true(config.response.hooks.format)

        -- Simulate rest.nvim being lazy-loaded on the `http` filetype: the config
        -- module is loaded by the ftplugin before the user's setup() callback runs.
        vim.g.rest_nvim = vim.tbl_deep_extend("force", {}, original or {}, {
            response = { hooks = { format = false } },
        })
        config.reload()

        assert.is_false(config.response.hooks.format)

        vim.g.rest_nvim = original
        config.reload()

        assert.is_true(config.response.hooks.format)
    end)

    it("setup() reloads an already loaded config", function()
        local original = vim.g.rest_nvim
        local rest = require("rest-nvim")

        rest.setup(vim.tbl_deep_extend("force", {}, original or {}, {
            response = { hooks = { format = false } },
        }))

        assert.is_false(require("rest-nvim.config").response.hooks.format)

        rest.setup(original)

        assert.is_true(require("rest-nvim.config").response.hooks.format)
    end)
end)