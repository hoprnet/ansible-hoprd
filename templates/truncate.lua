function truncate_message(tag, timestamp, record)
    local msg = record["field_message"]
    
    if msg then
        -- Graylog accepts 250. We limit to 220 due to some UTF-8 characters occupying more than 1 byte
        local max_length = 220
        -- Populate full_message with the non-truncated field_message if full_message is empty or undefined
        if not record["full_message"] or record["full_message"] == "" then
            record["full_message"] = msg
        end
        
        -- We do the first cut to 250 chars
        local truncated = string.sub(msg, 1, max_length)
        if #msg > max_length then
            truncated = truncated .. "..."
        end
        
        record["short_message"] = truncated
    end
    return 1, timestamp, record
end