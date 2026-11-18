local formatter = require("rest-nvim.formatter")

describe("response formatter", function()
    it("provides a built-in formatter for JSON filetypes", function()
        local cmd = formatter.get("json")
        assert.is_not_nil(cmd)
        assert.equals("jq", cmd[1])
    end)

    it("matches filetypes case-insensitively", function()
        assert.same(formatter.get("json"), formatter.get("JSON"))
    end)

    it("has no built-in formatter for other filetypes", function()
        assert.is_nil(formatter.get("text"))
    end)

    it("formats valid JSON", function()
        if vim.fn.executable("jq") ~= 1 then
            pending("jq is not installed")
            return
        end
        local lines, ok = formatter.format({ '{"foo": 123}' }, "json")
        assert.is_true(ok)
        assert.same({ "{", '  "foo": 123', "}" }, lines)
    end)

    it("keeps invalid JSON untouched", function()
        local lines, ok = formatter.format({ "not json" }, "json")
        assert.is_false(ok)
        assert.same({ "not json" }, lines)
    end)
end)