return {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--log=verbose",
		-- "--compile-commands-dir=firmware",
	},
	init_options = {
		fallbackFlags = { "-x", "c", "-std=gnu11" },
	},
}
