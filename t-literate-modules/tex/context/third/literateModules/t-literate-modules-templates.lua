-- A Lua file of t-literate-module templates

-- A Lua file (the lua code associated with t-literate-modules.mkiv)

if not modules then modules = { } end modules ['t-literate-modules-templates'] = {
    version   = 1.000,
    comment   = "Literate MkIV ConTeXt modules - templates",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata                 = thirddata                 or {}
thirddata.literateModules = thirddata.literateModules or {}

local litMods       = thirddata.literateModules
litMods.templates   = {}
local templates     = litMods.templates
templates.mkiv      = {}
templates.lua       = {}
templates.templates = {}

local pp = require('pl/pretty')
local table_insert = table.insert
local table_concat = table.concat

