return {
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        top_down = false, -- Show notifications from bottom to top
      },
      explorer = {
        enabled = true,
        replace_netrw = true, -- Replace netrw with the snacks explorer
        trash = true, -- Use the system trash when deleting files
      },
      picker = {
        sources = {
          explorer = {
            hidden = true, -- Show hidden files by default
            ignored = true, -- Show gitignored files
            layout = {
              layout = {
                position = "right",
              },
              width = 40,
            },
          },
          files = {
            hidden = true, -- Show hidden files in file picker
            ignored = true, -- Show gitignored files
          },
          grep = {
            hidden = true, -- Search in hidden files
            ignored = true, -- Search in gitignored files
          },
        },
      },
    },
  },
}
