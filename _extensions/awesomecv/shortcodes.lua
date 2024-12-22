function yaml(args)
    return pandoc.RawInline('typst', '#data-to-resume-entries(data: yaml("' .. args[1] .. '"))')
end