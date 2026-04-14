local Popup = require 'nui.popup'
local Layout = require 'nui.layout'

local cinput = Popup {
  position = '50%',
  size = {
    width = 60,
    height = 15,
  },
  relative = 'editor',
  enter = true,
  focusable = true,
  border = {
    -- padding = {
    --   top = 2,
    --   bottom = 2,
    --   left = 3,
    --   right = 3,
    -- },
    style = 'rounded',
    text = {
      top = ' program input ',
      top_align = 'center',
      bottom_align = 'left',
    },
  },
  buf_options = {
    modifiable = true,
    readonly = false,
    buftype = '',
    bufhidden = '',
    autoread = true,
  },
  win_options = {
    winblend = 10,
    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  },
}

local cparam = Popup {
  enter = true,
  focusable = true,
  border = {
    -- padding = {
    --   top = 2,
    --   bottom = 2,
    --   left = 3,
    --   right = 3,
    -- },
    style = 'rounded',
    text = {
      top_align = 'center',
      bottom = 'compile cmd',
      bottom_align = 'left',
    },
  },
  buf_options = {
    modifiable = true,
    readonly = false,
    buftype = '',
    bufhidden = '',
    autoread = true,
  },
  win_options = {
    winblend = 10,
    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  },
}

-- local comp = Layout(
--   {
--     position = '50%',
--     size = {
--       width = 60,
--       height = 15,
--     },
--     relative = 'editor',
--   },
--   Layout.Box({
--     Layout.Box(cinput, { size = '70%' }),
--     -- Layout.Box(cparam, { size = '30%' }),
--   }, { dir = 'col' })
-- )

local exi = function()
  -- vim.api.nvim_set_current_win(cparam.winid)
  -- vim.cmd.write()
  vim.api.nvim_set_current_win(cinput.winid)
  vim.cmd.write()

  cinput:unmount()
end
local enterIn = function(file, dir)
  -- local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  -- print(content)
  -- print 'bruh'
  -- vim.cmd.wq()
  exi()

  print(string.format('compiling %s', file))

  vim.system({ 'sh', '-c', string.format('clang++ %s', file) }, { text = true, cwd = dir }, function(out)
    -- print 'bamboozled'
    -- print(out.code)
    if out.code ~= 0 then
      print(out.stderr, '\n', string.format('clang++ %s', file))
      return
    end

    vim.system({ 'sh', '-c', 'foot sh -c "./a.out < $HOME/.cache/cc-in.txt && while true; do sleep 1; done"' }, { cwd = dir })
  end)
end

local openIn = function()
  local file = vim.api.nvim_buf_get_name(0)

  if vim.fn.fnamemodify(file, ':e') ~= 'cpp' then return end

  local dir = vim.fn.fnamemodify(file, ':p:h')

  -- local file = 'a.cpp'
  -- local dir = '.'

  cinput:mount()
  -- vim.api.nvim_set_current_win(cparam.winid)
  -- vim.cmd.edit(vim.fs.normalize '~/.cache/cc-par.txt')
  -- cparam.bufnr = vim.api.nvim_win_get_buf(cparam.winid)

  vim.api.nvim_set_current_win(cinput.winid)
  vim.cmd.edit(vim.fs.normalize '~/.cache/cc-in.txt')
  cinput.bufnr = vim.api.nvim_win_get_buf(cinput.winid)

  vim.keymap.set({ 'n', 'i', 'v' }, '<C-CR>', function() enterIn(file, dir) end, { buffer = cinput.bufnr, noremap = true })
  -- vim.keymap.set({ 'n', 'i', 'v' }, '<C-CR>', function() enterIn(file, dir) end, { buffer = cparam.bufnr, noremap = true })

  vim.keymap.set({ 'n', 'i', 'v' }, '<C-x>', exi, { buffer = cinput.bufnr, noremap = true })
  -- vim.keymap.set({ 'n', 'i', 'v' }, '<C-x>', exi, { buffer = cparam.bufnr, noremap = true })
  -- vim.api.nvim_buf_set_name(poop.bufnr, vim.fs.normalize '~/.cache/cc-in.txt')
  -- vim.fn.bufload(poop.bufnr)
end

vim.keymap.set('n', '<leader>c', openIn, { desc = 'Kompayls za kode' })
