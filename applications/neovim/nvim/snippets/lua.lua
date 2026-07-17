local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
    s('req', {
        t("local "),
        i(1, "name"),
        t(" = require('"),
        i(2, "module"),
        t("')"),
    }),
}
