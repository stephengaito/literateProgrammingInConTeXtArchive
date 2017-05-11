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

local pp = require('pl/pretty')
local table_insert = table.insert
local table_concat = table.concat

-- We need a simple Lua based template engine
-- Our template engine has been inspired by:
--   https://john.nachtimwald.com/2014/08/06/using-lua-as-a-templating-engine/
-- (via the minLua JoyLoL template engine)

function litMods.renderNextChunk(prevChunk, renderedText, curtemplate)
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
        result = litMods.renderNextChunck(newChunk, renderedText, curTemplate)
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
  outFile:write(pp.write(litMods))
  local renderedBaseTemplate = litMods.renderNextChunk("", {}, baseTemplate)
  outFile:write('\n--------------\n')
  outFile:write(renderedBaseTemplate)
  outFile:close()
end

function litMods.addMkIVCode(bufferName)
  table_insert(code.mkiv, buffers.getcontent(bufferName))
end

function litMods.createMkIVFile(aFilePath)
  renderFile(aFilePath, litMods.templates.mkivFile)
end

function litMods.addLuaCode(bufferName)
  table_insert(code.lua, buffers.getcontent(bufferName))
end

function litMods.createLuaFile(aFilePath)
  renderFile(aFilePath, litMods.templates.luaFile)
end

function litMods.addLuaTemplate(bufferName)
  table_insert(code.templates, buffers.getcontent(bufferName))
end

function litMods.creteLuaTemplateFile(aFilePath)
  renderFile(aFilePath, litMods.templates.templateFile)
end
