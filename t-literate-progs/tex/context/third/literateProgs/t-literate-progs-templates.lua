-- A Lua file of t-literate-progs templates

if not modules then modules = { } end
modules ['t-literate-progs-templates'] = {
    version   = 1.000,
    comment   = "Literate Programming in ConTeXt - templates",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata               = thirddata               or {}
thirddata.literateProgs = thirddata.literateProgs or {}

local litProgs          = thirddata.literateProgs
litProgs.templates      = {}
local templates         = litProgs.templates
templates.mkiv          = {}
templates.lua           = {}
templates.templates     = {}
templates.lakefile      = {}
templates.litProgsTable = {}

local table_insert = table.insert
local table_concat = table.concat

templates.mkiv.file = [=[
{{return table.concat(thirddata.literateProgs.code.mkiv, "\n\n") }}
]=]

templates.lua.file = [=[
{{ return table.concat(thirddata.literateProgs.code.lua, "\n\n") }}
]=]

templates.templates.file = [=[
{{ return table.concat(thirddata.literateProgs.code.templates, "\n\n") }}
]=]

templates.lakefile.file = [=[
{{ return table.concat(thirddata.literateProgs.code.lakefile, "\n\n") }}
]=]

templates.litProgsTable.file = [=[
{{ return thirddata.literateProgs.dumpLitProgsTable() }}
]=]
