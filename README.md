# nuget.nvim
**A NuGet Package Manager for Neovim**

![screenshot](doc/screenshot.png)

## Features
- [x] Show latest version as diagnostics after opening or updating a `.csproj` file
- [ ] Update all NuGet packages
- [ ] "Include prerelease" toggle
- [ ] `nuget.config` support
- [ ] Autocompletion for package versions while editing `.csproj` files
- [ ] Manage packages solution-wide (similar to Visual Studio)

## Installation
### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  'Speiser/nuget.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('nuget').setup()
  end,
}
```
