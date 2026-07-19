local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local rep = require('luasnip.extras').rep

return {
    s('forl', {
        t("for (int "),
        i(1, "i"),
        t(" = 0; "),
        rep(1),
        t(" < "),
        i(2, "count"),
        t("; "),
        rep(1),
        t({ "++) {", "\t" }),
        i(0),
        t({ "", "}" }),
    }),

    s('fori', {
        t("for (int i = 0; i < "),
        i(1, "count"),
        t({ "; i++) {", "\t" }),
        i(0),
        t({ "", "}" }),
    }),

    s({ trig = 'func', dscr = 'Define a function (K&R style)' }, {
        i(1, "void"),
        t(" "),
        i(2, "fun"),
        t("("),
        i(3, "void"),
        t({ ") {", "\t" }),
        i(0),
        t({ "", "}" }),
    }),
}
