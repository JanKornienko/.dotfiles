-- ===========
-- COLORSCHEME
-- ===========

return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		return {
			vim.cmd([[colorscheme gruvbox]])
		}
	end
}
