# nuget.nvim

**WIP: Currently only shows latest version as diagnostic in `.csproj` files.**

![screenshot](doc/screenshot.png)

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
