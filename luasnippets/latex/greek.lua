-- Place this in ${HOME}/.config/nvim/LuaSnip/all.lua
return {
	-- A snippet that expands the trigger "hi" into the string "Hello, world!".
	-- Examples of Greek letter snippets, autotriggered for efficiency
	s({ trig = ";a", snippetType = "autosnippet" }, {
		t("\\alpha"),
	}),
	s({ trig = ";b", snippetType = "autosnippet" }, {
		t("\\beta"),
	}),
	s({ trig = ";g", snippetType = "autosnippet" }, {
		t("\\gamma"),
	}),
	s({ trig = ";l", snippetType = "autosnippet" }, {
		t("\\lambda"),
	}),
	s({ trig = ";p", snippetType = "autosnippet" }, {
		t("\\phi"),
	}),
}
