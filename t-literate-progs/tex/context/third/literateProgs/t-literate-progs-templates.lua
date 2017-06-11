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

local addTemplate = litProgs.addTemplate

local pp = require('pl/pretty')
texio.write_nl('t-literate-progs-templates.lua')
texio.write_nl('-------------------------')
texio.write_nl(pp.write(thirddata))
texio.write_nl('-------------------------')