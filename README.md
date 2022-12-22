# cmp-builder
Create completion with nvim-cmp from ripgrep patterns.

## Instration
Using packer
```
use({
	"arakkkkk/cmp-builder",
	requires = { "hrsh7th/nvim-cmp" }
})
```

## Usage
### Lua file
```
require("cmp-builder").add(
	pattern_table,
	cmp_name,
	-- below parameters is optional
	trigger_characters,
	rg_option,
	replacement,
	is_test
	)

require('cmp').setup({
  sources = {
  	...
    { name = cmp_name }
  },
})
```

### Parameters
| Parameter          | Type          | Desctiption                          | Example              |
|--------------------|---------------|--------------------------------------|----------------------|
| pattern_table      | table(string) | Patterns of ripgrep to add cmp.      | {":[a-zA-Z0-9_-]+:"} |
| cmp_name           | string        | Name of cmp source.                  | md_tags              |
| trigger_characters | table(string) | Trigger characters of nvim-cmp.      | {".", ":"}           |
| rg_option          | string        | Set ripgrep options.                 | -tmd                 |
| replacement        | table         | Replace matched cmp lines.           | nil                  |
| is_test            | bool          | If it is true, added cmp is printed. | nil                  |

## Examples
### Vimwiki tags
```
local pattern_table = { ":[a-zA-Z0-9_]+:[\\s\\n]" }
local cmp_name = "mdtags"
local trigger_characters = { ".", "#" }
local rg_option = "-tmd -twiki"
require("cmp-builder").add(pattern_table, cmp_name, trigger_characters, rg_option)

require('cmp').setup({
  sources = {
  	...
    { name = "mdtags" }
  },
})
```

### Tex ref from label definitions.
```
local pattern_table = { "\\\\label\\{[^\\}]+\\}" }
local cmp_name = "tex"
local trigger_characters = { ".", "\\" }
local rg_option = "-ttex"
local replacement = { before = "label", after = "ref" }
require("cmp-builder").add(pattern_table, cmp_name, trigger_characters, rg_option, replacement)
require('cmp').setup({
  sources = {
  	...
    { name = "tex" }
  },
})
```
