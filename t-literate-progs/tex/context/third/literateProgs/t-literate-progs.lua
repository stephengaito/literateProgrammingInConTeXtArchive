-- A Lua file (the lua code associated with t-literate-progs.mkiv)

if not modules then modules = { } end
modules ['t-literate-progs'] = {
    version   = 1.000,
    comment   = "Literate Programming in ConTeXt - lua",
    author    = "PerceptiSys Ltd (Stephen Gaito)",
    copyright = "PerceptiSys Ltd (Stephen Gaito)",
    license   = "MIT License"
}

thirddata               = thirddata               or {}
thirddata.literateProgs = thirddata.literateProgs or {}

local litProgs  = thirddata.literateProgs
litProgs.code   = {}
local code      = litProgs.code
code.mkiv       = {}
code.lua        = {}
code.templates  = {}
code.lakefile   = {}

local pp = require('pl/pretty')
local table_insert = table.insert
local table_concat = table.concat

-- We need a simple Lua based template engine
-- Our template engine has been inspired by:
--   https://john.nachtimwald.com/2014/08/06/using-lua-as-a-templating-engine/
-- (via the minLua JoyLoL template engine)

function litProgs.renderNextChunk(prevChunk, renderedText, curTemplate)
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
            newChunk = luaFunc(litProgs)
          end
        end
        result = litProgs.renderNextChunk(newChunk, renderedText, curTemplate)
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

function litProgs.render(aTemplate)
  return litProgs.renderNextChunk("", { }, aTemplate)
end

-- Now we need the code that captures and creates a given code/file type

local function renderFile(aFilePath, baseTemplate)
  local outFile = io.open(aFilePath, 'w')
  --outFile:write(pp.write(litProgs))
  local renderedBaseTemplate = litProgs.renderNextChunk("", {}, baseTemplate)
  --outFile:write('\n--------------\n')
  outFile:write(renderedBaseTemplate)
  outFile:close()
end

function litProgs.setCodeStream(aCodeStream)
  code.curCodeStream = aCodeStream
end

function litProgs.addCode(aCodeType, bufferName)
  local bufferContents  =
    buffers.getcontent(bufferName):gsub("\13", "\n")
  code[aCodeType]       = code[aCodeType] or { }
  local codeType        = code[aCodeType]
  local aCodeStream     = code.curCodeStream or 'default'
  codeType[aCodeStream] = codeType[aCodeStream] or { }
  local codeStream      = codeType[aCodeStream]
  table_insert(codeStream, bufferContents)
end

function litProgs.createCodeFile(aCodeType,
                                 aCodeStream,
                                 aFilePath)
  -- here be dragons! -- how do we pass in cType and cSubType
  renderFile(aFilePath, litProgs.templates.lua.file)
  -- here be dragons!
end

function litProgs.addMkIVCode(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.mkiv, bufferContents)
end

function litProgs.createMkIVFile(aFilePath)
  renderFile(aFilePath, litProgs.templates.mkiv.file)
end

function litProgs.addLuaCode(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.lua, bufferContents)
end

function litProgs.createLuaFile(aFilePath)
  renderFile(aFilePath, litProgs.templates.lua.file)
end

function litProgs.addLuaTemplate(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.templates, bufferContents)
end

function litProgs.createLuaTemplateFile(aFilePath)
  renderFile(aFilePath, litProgs.templates.templates.file)
end

function litProgs.addLakefile(bufferName)
  local bufferContents = buffers.getcontent(bufferName):gsub("\13", "\n")
  table_insert(code.lakefile, bufferContents)
end

function litProgs.createLakefile(aFilePath)
  renderFile(aFilePath, litProgs.templates.lakefile.file)
end

function litProgs.dumpLitProgsTable()
  return pp.write(litProgs)
end

function litProgs.createLitProgsTableFile(aFilePath)
  renderFile(aFilePath, litProgs.templates.litProgsTable.file)
end
