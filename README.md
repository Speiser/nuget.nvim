# nuget.nvim

**Setup Example (using [lazy.nvim](https://github.com/folke/lazy.nvim))**:
```lua
{
  dir = 'C:/Users/bernh/Documents/Git/nuget.nvim',
  config = function()
    require('nuget').setup()
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
```
