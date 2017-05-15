-- A Lua file of t-literate-module templates

if not modules then modules = { } end modules ['t-literate-modules-templates'] = {
    version   = 1.000,
    comment   = "Literate MkIV ConTeXt modules - templates",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata                 = thirddata                 or {}
thirddata.literateModules = thirddata.literateModules or {}

local litMods          = thirddata.literateModules
litMods.templates      = {}
local templates        = litMods.templates
templates.mkiv         = {}
templates.lua          = {}
templates.templates    = {}
templates.lakefile     = {}
templates.litModsTable = {}

local table_insert = table.insert
local table_concat = table.concat

templates.mkiv.file = [=[
{{ return table.concat(thirddata.literateModules.code.mkiv, "\n\n") }}
]=]

templates.lua.file = [=[
{{ return table.concat(thirddata.literateModules.code.lua, "\n\n") }}
]=]

templates.templates.file = [=[
{{ return table.concat(thirddata.literateModules.code.templates, "\n\n") }}
]=]

templates.lakefile.file = [=[
{{ return table.concat(thirddata.literateModules.code.lakefile, "\n\n") }}
]=]

templates.litModsTable.file = [=[
{{ return thirddata.literateModules.dumpLitModsTable() }}
]=]
