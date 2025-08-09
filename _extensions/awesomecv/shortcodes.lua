-- Simple YAML parser for basic key-value pairs
local function simple_yaml_parse(content)
    local data = {}
    local current_key = nil
    local current_item = {}
    local in_details = false
    
    for line in content:gmatch("[^\r\n]+") do
        local original_line = line
        local trimmed_line = line:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
        local indent_level = #(line:match("^%s*") or "")
        
        if trimmed_line == "" then
            -- Skip empty lines
        elseif indent_level == 0 and trimmed_line:match("^[%w_-]+:$") then
            -- New top-level key (e.g., "nobel-prize:")
            if current_key and next(current_item) then
                data[current_key] = current_item
            end
            current_key = trimmed_line:gsub(":$", "")
            current_item = {}
            in_details = false
        elseif indent_level > 0 and trimmed_line:match("^title:%s*(.+)") then
            current_item.title = trimmed_line:match("^title:%s*(.+)")
        elseif indent_level > 0 and trimmed_line:match("^location:%s*(.+)") then
            current_item.location = trimmed_line:match("^location:%s*(.+)")
        elseif indent_level > 0 and trimmed_line:match("^date:%s*(.+)") then
            current_item.date = trimmed_line:match("^date:%s*(.+)")
        elseif indent_level > 0 and trimmed_line:match("^description:%s*(.+)") then
            current_item.description = trimmed_line:match("^description:%s*(.+)")
        elseif indent_level > 0 and trimmed_line:match("^details:%s*$") then
            current_item.details = {}
            in_details = true
        elseif in_details and original_line:match("^%s*-%s*(.+)") then
            local detail = original_line:match("^%s*-%s*(.+)")
            table.insert(current_item.details, detail)
        elseif in_details and indent_level > 0 and not original_line:match("^%s*-%s*") then
            in_details = false
        end
    end
    
    -- Add the last item
    if current_key and next(current_item) then
        data[current_key] = current_item
    end
    
    return data
end

-- Convert YAML data to Typst resume-entry code
local function yaml_to_typst_entries(data)
    local typst_code = {}
    
    -- Convert table to array if it's a dictionary
    local entries = {}
    if data and type(data) == "table" then
        -- Check if it's a dictionary (has string keys)
        local is_dict = false
        for k, v in pairs(data) do
            if type(k) == "string" then
                is_dict = true
                break
            end
        end
        
        if is_dict then
            -- Convert dictionary values to array
            for k, v in pairs(data) do
                table.insert(entries, v)
            end
        else
            entries = data
        end
    end
    
    for _, item in ipairs(entries) do
        local entry_parts = {}
        table.insert(entry_parts, "#resume-entry(")
        
        -- Add title
        if item.title then
            local title_str = tostring(item.title)
            -- Escape quotes in the string
            title_str = title_str:gsub('"', '\\"')
            table.insert(entry_parts, '  title: "' .. title_str .. '",')
        else
            table.insert(entry_parts, '  title: none,')
        end
        
        -- Add location
        if item.location then
            local location_str = tostring(item.location)
            location_str = location_str:gsub('"', '\\"')
            table.insert(entry_parts, '  location: "' .. location_str .. '",')
        else
            table.insert(entry_parts, '  location: none,')
        end
        
        -- Add date
        if item.date then
            local date_str = tostring(item.date)
            date_str = date_str:gsub('"', '\\"')
            table.insert(entry_parts, '  date: "' .. date_str .. '",')
        else
            table.insert(entry_parts, '  date: none,')
        end
        
        -- Add description
        if item.description then
            local desc_str = tostring(item.description)
            desc_str = desc_str:gsub('"', '\\"')
            table.insert(entry_parts, '  description: "' .. desc_str .. '"')
        else
            table.insert(entry_parts, '  description: none')
        end
        
        table.insert(entry_parts, ")")
        
        -- Add details if present
        if item.details and type(item.details) == "table" then
            table.insert(entry_parts, "#resume-item[")
            -- Handle both array and dictionary formats
            if #item.details > 0 then
                -- It's an array
                for _, detail in ipairs(item.details) do
                    local detail_str = tostring(detail)
                    table.insert(entry_parts, "  - " .. detail_str)
                end
            else
                -- It might be a dictionary, convert to array
                for _, detail in pairs(item.details) do
                    local detail_str = tostring(detail)
                    table.insert(entry_parts, "  - " .. detail_str)
                end
            end
            table.insert(entry_parts, "]")
        end
        
        table.insert(typst_code, table.concat(entry_parts, "\n"))
    end
    
    return table.concat(typst_code, "\n\n")
end

-- New function that processes YAML in Lua and generates Typst code directly
function yaml(args)
    local file_path = args[1]
    if not file_path then
        error("yaml_entries shortcode requires a file path argument")
    end
    
    -- Read and parse the YAML file
    local file = io.open(file_path, "r")
    if not file then
        error("Could not open file: " .. file_path)
    end
    local yaml_content = file:read("*all")
    file:close()
    
    local yaml_data = simple_yaml_parse(yaml_content)
    local typst_code = yaml_to_typst_entries(yaml_data)
    return pandoc.RawInline('typst', typst_code)
end