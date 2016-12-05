-------- requires ------------

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

-------- background ----------

local function start(event)
		storyboard.removeScene("game")
		storyboard.gotoScene("game", "fade", 400)
		return true
end

function scene:createScene(event)
	
	local screenGroup = self.view

	background = display.newImage("images/start2.png")
	background:scale(1.2, 1.2)
	screenGroup:insert(background)
	--background:addEventListener("tap", start)

	city2_2 = display.newImage("images/city2.png")
	city2_2:setReferencePoint(display.BottomLeftReferencePoint)
	city2_2.x = 0
	city2_2.y = 320
	screenGroup:insert(city2_2)
		
end

function scene:enterScene(event)
	Runtime:addEventListener("tap", start)
end

function scene:exitScene(event)
	Runtime:removeEventListener("tap", start)
end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene