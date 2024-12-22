-- ==========
-- BUFFERLINE
-- ==========

return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "thick",
			truncate_names = true,
			offsets = {
				{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						separator = true
				}
			}
		}
	}
}
 
