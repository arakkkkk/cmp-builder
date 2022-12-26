M = {}
function M.add(pattern_table, cmp_name, trigger_characters, rg_option, replacement, is_test)
	trigger_characters = trigger_characters or {"."}
	rg_option = rg_option or ""
	local cmp_table = {}
	local function add_cmp(table, path)
		for _, pattern in pairs(pattern_table) do
			local handle = io.popen("rg -o " .. rg_option .. " '" .. pattern .. "' -IN --trim " .. string.gsub(path, " ", "\\ "))
			if handle then
				local io_output = handle:read("*a")
				for line in io_output:gmatch("([^\n]*)\n?") do
					if line ~= "" then
						if replacement then
							line = string.gsub(line, replacement["before"], replacement["after"])
						end
						if is_test then
							print(line)
						end
						table[line] = 1
					end
				end
				handle:close()
			end
		end
		if is_test then
			print("--------------------------")
		end
		return table
	end
	cmp_table = add_cmp(cmp_table, vim.fn.getcwd())

	local source = {}
	---Return whether this source is available in the current context or not (optional).
	---@return boolean
	function source:is_available()
		return true
	end
	---Return the debug name of this source (optional).
	---@return string
	function source:get_debug_name()
		return cmp_name
	end
	---Return trigger characters for triggering completion (optional).
	function source:get_trigger_characters()
		return trigger_characters
	end
	---Invoke completion (required).
	---@param params cmp.SourceCompletionApiParams
	---@param callback fun(response: lsp.CompletionResponse|nil)
	local function add_cmp_callback()
		cmp_table = add_cmp(cmp_table, vim.fn.expand("%"))

		local cmps = {}
		for k, _ in pairs(cmp_table) do
			cmps[#cmps + 1] = { label = k }
		end
		return cmps
	end
	function source:complete(params, callback)
		callback(add_cmp_callback())
	end
	---Resolve completion item (optional). This is called right before the completion is about to be displayed.
	---Useful for setting the text shown in the documentation window (`completion_item.documentation`).
	---@param completion_item lsp.CompletionItem
	---@param callback fun(completion_item: lsp.CompletionItem|nil)
	function source:resolve(completion_item, callback)
		callback(completion_item)
	end
	---Executed after the item was selected.
	---@param completion_item lsp.CompletionItem
	---@param callback fun(completion_item: lsp.CompletionItem|nil)
	function source:execute(completion_item, callback)
		callback(completion_item)
	end
	---Register your source to nvim-cmp.
	require("cmp").register_source(cmp_name, source)
end
return M
