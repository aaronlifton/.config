local function setup(_, options)
	if Yatline == nil then
        return
    end

	options = options or {}

    local default_path_fg = "cyan"
    local default_filter_fg = "brightyellow"
    local default_search_label = "  search"
    local default_filter_label = "  filter"
    local default_no_filter_label = ""
    local default_flatten_label = "   flatten"
    local default_separator = "  "
	local config = {
        path_fg = options.path_fg or default_path_fg,
        filter_fg = options.filter_fg or default_filter_fg,
        search_label = options.search_label or default_search_label,
        filter_label = options.filter_label or default_filter_label,
        no_filter_label = options.no_filter_label or default_no_filter_label,
        flatten_label = options.flatten_label or default_flatten_label,
        separator = options.separator or default_separator,
	}

    local function trim_filename(filename, max_length, trim_length)
        if not max_length or not trim_length then
            return filename
        end

        -- Count UTF-8 characters
        local len = utf8len(filename)

        if len <= max_length then
            return filename
        end

        if len <= trim_length * 2 then
            return filename
        end

        return utf8sub(filename, 1, trim_length) .. "..." .. utf8sub(filename, len - trim_length + 1, len)
    end

    function Yatline.coloreds.get:tab_path()
        local cwd = cx.active.current.cwd
        local filter = cx.active.current.files.filter

        local filter_suffix

        local search = ""
        if cwd.is_search then
            search = #cwd:frag() > 0 and string.format("%s: %s", config.search_label, cwd:frag()) or config.flatten_label
        end

        if not filter then
            filter_suffix = search == "" and search or search
        elseif search == "" then
            filter_suffix = string.format("%s: %s", config.filter_label, tostring(filter))
        else
            filter_suffix = string.format("%s%s%s: %s", search, config.separator, config.filter_label, tostring(filter))
        end

        if filter_suffix == "" then
            filter_suffix = config.no_filter_label
        end

        local path = ya.readable_path(tostring(cwd))

        if config.trimmed or config.trimed then
            local max_length = config.max_length or 24
            local trim_length = config.trim_length or 10

            path = trim_filename(path, max_length, trim_length)
        end

	if path == "" and filter_suffix == "" then
		return {}
	end

	local spacing = " "
	local spacing_fg = ""
        return {
	    { spacing, spacing_fg },
            { string.format("%s", path), config.path_fg },
	    { filter_suffix ~= "" and spacing or "", spacing_fg },
            { string.format("%s", filter_suffix), config.filter_fg },
	    { spacing, spacing_fg },
        }
    end
end

return { setup = setup }
