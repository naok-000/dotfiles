return {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--log=verbose",
		"--query-driver=/nix/store/*-clang-wrapper-*/bin/clang++,/nix/store/*-clang-wrapper-*/bin/clang,clang++,clang",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

	root_markers = {
		"compile_commands.json",
		"compile_flags.txt",
		".clangd",
		".git",
	},
	init_options = {
		fallbackFlags = { "-x", "c", "-std=gnu11" },
	},
}
