-- =========
-- AUTOSAVE
-- =========

return {
  "pocco81/auto-save.nvim",
  opts = {
    enabled = true,
    execution_message = {
      message = function() -- message to print on save
        return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
      end,
      dim = 0.18, -- dim the color of `message`
      cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    },
    trigger_events = { -- See :h events
      immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
      defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after waiting for `debounce_delay`)
      cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
    },
    write_all_buffers = false, -- write all buffers when the current one meets `condition`
    debounce_delay = 135, -- delay after which the pending save is executed
    callbacks = { -- functions to be executed at different points in the save process
      before_saving = nil, -- runs before saving the current buffer
      after_saving = nil, -- runs after saving the current buffer
    },
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      if
        fn.getbufvar(buf, "&modifiable") == 1
        and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        return true -- met condition(s), can save
      end
      return false -- can't save
    end,
  },
}
