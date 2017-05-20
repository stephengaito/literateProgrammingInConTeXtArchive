-- A Lua file (the lua code associated with t-literate-modules.mkiv)

if not modules then modules = { } end modules ['t-literate-modules'] = {
    version   = 1.000,
    comment   = "Literate MkIV ConTeXt modules - lua",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata                 = thirddata                 or {}
thirddata.literateModules = thirddata.literateModules or {}

local litMods  = thirddata.literateModules
litMods.code   = {}
local code     = litMods.code
code.mkiv      = {}
code.lua       = {}
code.templates = {}
code.lakefile  = {}

local pp = require('pl/pretty')
local table_insert = table.insert
local table_concat = table.concat

-- We need a simple Lua based template engine
-- Our template engine has been inspired by:
--   https://john.nachtimwald.com/2014/08/06/using-lua-as-a-templating-engine/
-- (via the minLua JoyLoL template engine)

function litMods.renderNextChunk(prevChunk, renderedText, curTemplate)
  local result = ""
 
  if prevChunk
    and type(prevChunk) == 'string'
    and 0 < #prevChunk then
    table_insert(renderedText, prevChunk)
  end
 
  if type(curTemplate) == 'string' and (0 < #curTemplate) then
    if curTemplate:find('{{') then
      local position  = 1
      local textChunk = curTemplate:match('^.*{{', position)
      if textChunk then
        local textChunkLen = #textChunk
        textChunk = textChunk:sub(1, textChunkLen-2)
        if 0 < #textChunk then table_insert(renderedText, textChunk) end
        position = position + textChunkLen
      end
 
      local luaChunk = curTemplate:match('^.+}}', position)
      if luaChunk then
        local luaChunkLen = #luaChunk
        luaChunk = luaChunk:sub(1, luaChunkLen-2)
        position = position + luaChunkLen
        curTemplate = curTemplate:sub(position, #curTemplate)
        local newChunk = ""
        if not luaChunk:match('^%s*$') then
          -- consider using an PCall here....
          local luaFunc, errMessage = load(luaChunk)
          if luaFunc then
            newChunk = luaFunc(litMods)
          end
        end
        result = litMods.renderNextChunk(newChunk, renderedText, curTemplate)
      end
    else -- there is no '{{' in the template
      table_insert(renderedText, curTemplate)
      result = table_concat(renderedText)
    end
  else
    -- nothing to do...
    result = table_concat(renderedText)
  end
  return result
end

function litMods.render(aTemplate)
  return litMods.renderNextChunk("", { }, aTemplate)
end

-- Now we need the code that captures and creates a given code/file type

local function renderFile(aFilePath, baseTemplate)
  local outFile = io.open(aFilePath, 'w')
  --outFile:write(pp.write(litMods))
  local renderedBaseTemplate = litMods.renderNextChunk("", {}, baseTemplate)
  --outFile:write('\n--------------\n')
  outFile:write(renderedBaseTemplate)
  outFile:close()
end

function litMods.addMkIVCode(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.mkiv, bufferContents)
end

function litMods.createMkIVFile(aFilePath)
  renderFile(aFilePath, litMods.templates.mkiv.file)
end

function litMods.addLuaCode(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.lua, bufferContents)
end

function litMods.createLuaFile(aFilePath)
  renderFile(aFilePath, litMods.templates.lua.file)
end

function litMods.addLuaTemplate(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.templates, bufferContents)
end

function litMods.createLuaTemplateFile(aFilePath)
  renderFile(aFilePath, litMods.templates.templates.file)
end

function litMods.addLakefile(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.lakefile, bufferContents)
end

function litMods.createLakefile(aFilePath)
  renderFile(aFilePath, litMods.templates.lakefile.file)
end

function litMods.dumpLitModsTable()
  return pp.write(litMods)
end

function litMods.createLitModsTableFile(aFilePath)
  renderFile(aFilePath, litMods.templates.litModsTable.file)
end