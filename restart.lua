-------- requires ------------

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

preference = require "preference"
-------- background ----------

local function start(event)
	if event.phase == "began" then
		storyboard.removeScene("game")
		storyboard.gotoScene("game", "fade", 400)
		scoreText.text = 0
		finalScore.text = 0
		scoreText.isVisible = true
	end

end

function scene:createScene(event)

	local screenGroup = self.view

	--preference.save{a=0}
	tmpHighScore = preference.getValue("a")

	background = display.newImage("images/restart2.png")
	background:scale(1.2,1.2)
	background:addEventListener("touch", start)
	screenGroup:insert(background)

	city2_2 = display.newImage("images/city2.png")
	city2_2:setReferencePoint(display.BottomLeftReferencePoint)
	city2_2.x = 0
	city2_2.y = 320
	screenGroup:insert(city2_2)

	ScoreText = display.newText( "Score:", 130, 160, systemFont, 30 )
	screenGroup:insert(ScoreText)

	highScore = display.newText( "High Score:", 130, 190, systemFont, 30)
	screenGroup:insert(highScore)

	finalScore = display.newText( score, 240, 160, systemFont, 30 )
	screenGroup:insert(finalScore)

	print( tonumber(preference.getValue("a")) )
	print(score)
	print(tmpHighScore)
	if tonumber(score) > tonumber(preference.getValue("a")) then
		print("True")

		finalHighScore = display.newText( score, 300, 190, systemFont, 30)
		screenGroup:insert(finalHighScore)
		preference.save{a = score}
	else 
		finalHighScore = display.newText( tmpHighScore, 300, 190, systemFont, 30)
		screenGroup:insert(finalHighScore)
	end
		
end

function scene:enterScene(event)

	storyboard.purgeScene("game")
	Runtime:addEventListener("touch", start)

end

function scene:exitScene(event)

	Runtime:removeEventListener("touch", start)

end

function scene:destroyScene(event)

end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene