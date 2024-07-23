# nuget.nvim

**Setup Example (using [lazy.nvim](https://github.com/folke/lazy.nvim))**:
```lua
{
  'Speiser/nuget.nvim',
  config = function()
    require('nuget').setup()
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
```
