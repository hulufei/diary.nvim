# Diary.nvim

> An unexamined life is not worth living. — <cite>Socrates</cite>

A simple and efficient diary plugin for Neovim, designed to streamline the process of maintaining daily logs and reflections.

## Features

- **Create a New Diary Entry**: Use `:DiaryNew` command to start a new diary entry for the day.
- **Review Random Diary Entry**: Use `:DiaryReviewRandom` command to select a random entry from your diary for reflection.
- **Reflect on This Day in History**: Use `:YesterdayOnceMore` command to revisit diary entries from the same date in previous years, offering insights into your personal growth and changes over time.
- **Generate Table of Contents**: Use `:DiaryGenerateLinks` to create a comprehensive Table of Contents (TOC) in an index file, accumulating links to all your diary entries for easy navigation.

## Installation

To install the plugin using [lazy.nvim](https://github.com/folke/lazy.nvim), add the following configuration to your `init.lua`:

```lua
{
  "hulufei/diary.nvim",
  opts = {
    "diary-dir" = "~/path/to/your/diary"
  }
}
```

## Unlicensed

Find the full [Unlicense][unlicense] in the `UNLICENSE` file, but here's a
snippet.

> This is free and unencumbered software released into the public domain.
>
> Anyone is free to copy, modify, publish, use, compile, sell, or distribute
> this software, either in source code form or as a compiled binary, for any
> purpose, commercial or non-commercial, and by any means.

[Neovim]: https://neovim.io/
[Fennel]: https://fennel-lang.org/
[nfnl]: https://github.com/Olical/nfnl
[unlicense]: http://unlicense.org/
[Plenary]: https://github.com/nvim-lua/plenary.nvim
