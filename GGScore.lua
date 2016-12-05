-- Project: GGScore
--
-- Date: September 23, 2012
--
-- Version: 0.1
--
-- File name: GGScore.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Update History:
--
-- 0.1 - Initial release
--
-- Comments: 
--
--		GGScore allows you to create easy to use leaderboards for your Corona SDK 
--		powered games.
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGScore = {}
local GGScore_mt = { __index = GGScore }

local json = require( "json" )

local time = os.time
local date = os.date
local sort = table.sort

--- Initiates a new GGScore leaderboard.
-- @param name The name of the leaderboard.
-- @param allowDuplicate True if duplicate names are allowed, false otherwise.
-- @param gcID The id of the GameCenter leaderboard to attach this one to. Optional.
-- @return The new leaderboard.
function GGScore:new( name, allowDuplicate, gcID )
    
    local self = {}
    
    setmetatable( self, GGScore_mt )
    
    self.name = name
    self.allowDuplicate = allowDuplicate
    self.gcID = gcID
    self.leaderboards = {}
    self.scores = {}
    
    return self
    
end

--- Adds a score to the leaderboard.
-- @param name The name of the player.
-- @param value The score value.
-- @param date The date timestamp. Default will be result of os.time()
-- @param submitToGC True if you would like this score submitted to GameCenter, false otherwise. Optional, default is false.
function GGScore:add( name, value, date, submitToGC )

	local score = { name = name, value = value, date = date }
	
	score.name = score.name or self:getDefaultName() or ""
	score.value = score.value or self:getDefaultScore() or ""
	score.date = score.date or time()
	
	if self:getMaxNameLength() then
		score.name = string.sub( score.name, 1, self:getMaxNameLength() ) 
	end
	
	if self:getMaxScoreLength() then
		score.value = string.sub( score.value, 1, self:getMaxScoreLength() ) 
	end

	if not self.allowDuplicate then
		
		for i = 1, #self.scores, 1 do
			if self.scores[ i ].name == name then
				return
			end
		end
		
	end
	
	self.scores[ #self.scores + 1 ] = score
	
	if gameNetwork and submitToGC and self.gcID then
		gameNetwork.request( 
			"setHighScore",
			{
				localPlayerScore = 
				{ 
					category = self.gcID, 
					value = score.value 
				},
				listener = requestCallback
			}
		)
	end
	
end

--- Gets all scores by a player.
-- @param name The name of the player.
-- @return The scores.
function GGScore:getScoresByPerson( name )

	local allScores = self:getScores()
	local scores = {}
	
	for i = 1, #allScores, 1 do
		if allScores[ i ].name == name then
			scores[ #scores + 1 ] = allScores[ i ]
		end
	end
	
	return scores
	
end

--- Sorts the scores.
-- @param ascending True if the scores should be sorted ascending, false if descending. Default is descending.	
function GGScore:sort( ascending )
	if ascending then
		sort( self.scores, function( a, b ) return tonumber( a.value ) < tonumber( b.value ) end )
	else	
		sort( self.scores, function( a, b ) return tonumber( a.value ) > tonumber( b.value ) end )
	end
end

--- Prints the scores to the console.
-- @param ascending True if the scores should be displayed descending, false if ascending. Default is descending.
function GGScore:print( descending )
	
	self:sort( descending )
	
	local score
	for i = 1, #self.scores, 1 do
		score = self.scores[ i ]
		print( i, score.name, score.value, date( "%c", score.date ) )
	end
	
end

--- Sets the name of this leaderboard.
-- @param name The name to set.
function GGScore:setName( name )
	self.name = name
end

--- Gets the name of this leaderboard.
-- @return The name.
function GGScore:getName()
	return self.name
end

--- Sets the list of all scores.
-- @param scores The list of scores to set.
function GGScore:setScores( scores )
	self.scores = scores
end

--- Gets a list of all scores.
-- @param Ascending True if the scores should be sorted in ascending order, false if descending. Default is descending.
function GGScore:getScores( ascending )
	self:sort( ascending )
	return self.scores
end

--- Sets the default name for this leaderboard.
-- @param name The name to set.
function GGScore:setDefaultName( name )
	self.defaultName = name
end

--- Gets the default name for this leaderboard.
-- @return The default name.
function GGScore:getDefaultName()
	return self.defaultName
end

--- Sets the default score for this leaderboard.
-- @param score The value to set.
function GGScore:setDefaultScore( score )
	self.defaultScore = score
end

--- Gets the default score for this leaderboard.
-- @return The default score value.
function GGScore:getDefaultScore()
	return self.defaultScore
end

--- Sets the maximum allowed length of names.
-- @param length The length to set.
function GGScore:setMaxNameLength( length )
	self.maxNameLength = length
end

--- Gets the maximum allowed length of names.
-- @return The max length.
function GGScore:getMaxNameLength()
	return self.maxNameLength
end

--- Sets the maximum allowed length of scores.
-- @param length The length to set.
function GGScore:setMaxScoreLength( length )
	self.maxScoreLength = length
end

--- Gets the maximum allowed length of scores.
-- @return The max length.
function GGScore:getMaxScoreLength()
	return self.maxScoreLength
end

--- Saves this leaderboard to disk.
function GGScore:save()

	local data = {}
	
	data.name = self:getName()
	data.defaultName = self:getDefaultName()
	data.defaultScore = self:getDefaultScore()
	data.maxNameLength = self:getMaxNameLength()
	data.maxScoreLength = self:getMaxScoreLength()
	data.scores = self:getScores()
	
	local path = system.pathForFile( self.name .. ".score", system.DocumentsDirectory )
	local file = io.open( path, "w" )
		
	if not file then
		return
	end	
		
	file:write( json.encode( data ) )
	io.close( file )
	file = nil
		
end

--- Loads a leaderboard to disk.
-- @param name The name of the board to load. Only required if loading and creating a board at the same time.
function GGScore:load( name )

	local data = {}
	
	name = name or self.name
	
	if not name then
		return
	end
	
	local path = system.pathForFile( name .. ".score", system.DocumentsDirectory )
	local file = io.open( path, "r" )
	
	if not file then
		return
	end
	
	data = json.decode( file:read( "*a" ) )
	io.close( file )
	
	self:setName( data.name )
	self:setScores( data.scores )
	self:setDefaultName( data.defaultName )
	self:setDefaultScore( data.defaultScore )
	self:setMaxNameLength( data.maxNameLength )
	self:setMaxScoreLength( data.maxScoreLength )

	return self
	
end

--- Destroys this GGScore object.
function GGScore:destroy()
	for k, v in pairs( self ) do
		k, v = nil, nil
	end
end

return GGScore