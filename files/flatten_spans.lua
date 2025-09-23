function flatten_spans_fields(tag, timestamp, record)
    -- Process 'spans' array
    if record.spans then
        for i, span in ipairs(record.spans) do
            for k, v in pairs(span) do
                record["spans_"..i.."_"..k] = tostring(v)
            end
        end
        record.spans = nil
    end
    return 1, timestamp, record
end