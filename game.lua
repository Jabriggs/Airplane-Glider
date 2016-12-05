-------- requires ------------

local physics = require "physics"
physics.start()
physics.setGravity(0, 2)
local sprite = require "sprite"

local storyboard = require ("storyboard")
local scene = storyboard.newScene()

-------- background ----------

function scene:createScene(event)

	local screenGroup = self.view

	local background = display.newImage("images/bg.png")
	background:scale(320, 480)
	screenGroup:insert(background)
	
	ceiling = display.newImage("images/Line.png")
	ceiling.x = 150
	ceiling.y = -30
	physics.addBody(ceiling, "static", {density=.1, bounce=0.1, friction=.2})
	screenGroup:insert(ceiling)
	
	theFloor = display.newImage("images/Line.png")
	theFloor.x = 150
	theFloor.y = 340
	physics.addBody(theFloor, "static", {density=.1, bounce=0.1, friction=.2})
	screenGroup:insert(theFloor)

	city1_1 = display.newImage("images/city1.png")
	city1_1:setReferencePoint(display.BottomLeftReferencePoint)
	city1_1.x = 0
	city1_1.y = 320
	city1_1.speed = 1
	screenGroup:insert(city1_1)

	city1_2 = display.newImage("images/city1.png")
	city1_2:setReferencePoint(display.BottomLeftReferencePoint)
	city1_2.x = 480
	city1_2.y = 320
	city1_2.speed = 1
	screenGroup:insert(city1_2)

	city2_1 = display.newImage("images/city2.png")
	city2_1:setReferencePoint(display.BottomLeftReferencePoint)
	city2_1.x = 0
	city2_1.y = 320
	city2_1.speed = 2
	screenGroup:insert(city2_1)

	city2_2 = display.newImage("images/city2.png")
	city2_2:setReferencePoint(display.BottomLeftReferencePoint)
	city2_2.x = 480
	city2_2.y = 320
	city2_2.speed = 2
	screenGroup:insert(city2_2)
		
	sheetData = { width=50, height=17, numFrames=4, sheetContentWidth=200, sheetContentHeight=17 }
 
	mySheet = graphics.newImageSheet( "images/plane.png", sheetData )
 
	sequenceData = {
		{ name = "normalRun", start=1, count=4, time=800 }
	}
 
	bird = display.newSprite( mySheet, sequenceData )
	bird.x = -80
	bird.y = 100 
	bird:scale(1.5,1.5)
	bird:play()
	bird.collided = false
	physics.addBody(bird, "static", {density=0.1, bounce=0.1, friction=0.2, radius=12})
	screenGroup:insert(bird)
	jetIntro = transition.to(bird, {time=2000, x=100, onComplete=birdReady})

	sheetData = { width=24, height=23, numFrames=8, sheetContentWidth=192, sheetContentHeight=23 }
 
	mySheet2 = graphics.newImageSheet( "images/explosion.png", sheetData )
 
	sequenceData = {
		{ name = "normalRun", start=1, count=8, time=800 }
	}
 
	explosion = display.newSprite( mySheet2, sequenceData )
	explosion.x = 100 
	explosion.y = 100 
	explosion.isVisible = false
	screenGroup:insert(explosion)
	
	topPipe1 = display.newImage("images/topPipe.png")
	topPipe1.x = 500
	topPipe1.y = 20
	topPipe1.speed = 3
	topPipe1.initY = topPipe1.y
	physics.addBody(topPipe1, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(topPipe1)

	bottomPipe1 = display.newImage("images/bottomPipe.png")
	bottomPipe1.x = topPipe1.x
	bottomPipe1.y = topPipe1.y + 390
	bottomPipe1.speed = 3
	bottomPipe1.initY = bottomPipe1.y
	physics.addBody(bottomPipe1, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(bottomPipe1)
	
	topPipe2 = display.newImage("images/topPipe.png")
	topPipe2.x = 675
	topPipe2.y = 75
	topPipe2.speed = 3
	topPipe2.initY = topPipe2.y
	physics.addBody(topPipe2, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(topPipe2)

	bottomPipe2 = display.newImage("images/bottomPipe.png")
	bottomPipe2.x = topPipe2.x
	bottomPipe2.y = topPipe2.y + 390
	bottomPipe2.speed = 3
	bottomPipe2.initY = bottomPipe2.y
	physics.addBody(bottomPipe2, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(bottomPipe2)
	
	topPipe3 = display.newImage("images/topPipe.png")
	topPipe3.x = 850
	topPipe3.y = -10
	topPipe3.speed = 3
	topPipe3.initY = topPipe3.y
	physics.addBody(topPipe3, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(topPipe3)

	bottomPipe3 = display.newImage("images/bottomPipe.png")
	bottomPipe3.x = topPipe3.x
	bottomPipe3.y = topPipe3.y + 390
	bottomPipe3.speed = 3
	bottomPipe3.initY = bottomPipe3.y
	physics.addBody(bottomPipe3, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(bottomPipe3)
	
	topPipe4 = display.newImage("images/topPipe.png")
	topPipe4.x = 1025
	topPipe4.y = 55
	topPipe4.speed = 3
	topPipe4.initY = topPipe4.y
	physics.addBody(topPipe4, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(topPipe4)

	bottomPipe4 = display.newImage("images/bottomPipe.png")
	bottomPipe4.x = topPipe4.x
	bottomPipe4.y = topPipe4.y + 390
	bottomPipe4.speed = 3
	bottomPipe4.initY = bottomPipe4.y
	physics.addBody(bottomPipe4, "static", { density=3.0, friction=0.5, bounce=0.3 } )
	screenGroup:insert(bottomPipe4)
	
end

score = 0
newScore = 0
scoreText = display.newText( score, 75, 30, native.systemFont, 30 )

function scrollCity(self, event)
	if self.x < - 475 then
		self.x = 480
	else
		self.x = self.x - self.speed
	end
end

function movePipes(self, event)

	--newScore = tonumber(scoreText)

	if self.x < bird.x and self.x > bird.x - 4 then
		newScore = newScore + 1
		score = newScore
		scoreText.text = tostring(newScore) 
	end
	if topPipe2.x < bird.x and topPipe2.x > bird.x - 4 then
		newScore = newScore + 1
		score = newScore
		scoreText.text = tostring(newScore) 
	end
	if topPipe3.x < bird.x and topPipe3.x > bird.x - 3 then
		newScore = newScore + 1
		score = newScore
		scoreText.text = tostring(newScore) 
	end
	if topPipe4.x < bird.x and topPipe4.x > bird.x - 4 then
		newScore = newScore + 1
		score = newScore
		scoreText.text = tostring(newScore) 
	end

	if self.x < -200 then
			self.x = 500
			bottomPipe1.x = 500
			self.y = math.random(-30, 90)
			bottomPipe1.y = self.y + 390
	else
	if topPipe2.x < -150 then
			topPipe2.x = self.x + 175
			bottomPipe2.x = bottomPipe1.x + 175
			topPipe2.y = math.random(-30, 90)
			bottomPipe2.y = topPipe2.y + 390
	end
	if topPipe3.x < -100 then
			topPipe3.x = topPipe2.x + 175
			bottomPipe3.x = bottomPipe2.x + 175
			topPipe3.y = math.random(-30, 90)
			bottomPipe3.y = topPipe3.y + 390
	end
	if topPipe4.x < -100 then
			topPipe4.x = topPipe3.x + 175
			bottomPipe4.x = bottomPipe3.x + 175
			topPipe4.y = math.random(-30, 90)
			bottomPipe4.y = topPipe4.y + 390
	end

		self.x = self.x - self.speed
		bottomPipe1.x = bottomPipe1.x - bottomPipe1.speed
		topPipe2.x = topPipe2.x - topPipe2.speed
		bottomPipe2.x = bottomPipe2.x - bottomPipe2.speed
		topPipe3.x = topPipe3.x - topPipe3.speed
		bottomPipe3.x = bottomPipe3.x - bottomPipe3.speed
		topPipe4.x = topPipe4.x - topPipe4.speed
		bottomPipe4.x = bottomPipe4.x - bottomPipe4.speed

	end
end

function birdReady()
	bird.bodyType = "dynamic"
end

function activateBird(self, event)
	self:applyForce(0, -.6, self.x, self.y)
end


function touchScreen(event)
	if event.phase == "began" then
		bird.enterFrame = activateBird
		Runtime:addEventListener("enterFrame", bird)
	end
	
	if event.phase == "ended" then
		Runtime:removeEventListener("enterFrame", bird)
	end
end

function onCollision(event)
	if event.phase == "began" then
		explosion.x = bird.x
		explosion.y = bird.y
		explosion.isVisible = true
		explosion:play()
		scoreText.isVisible = false
		storyboard.removeScene("restart")
		storyboard.gotoScene("restart", "fade", 400)
		
	end
end

function scene:enterScene(event)

	storyboard.purgeScene("restart")

	score = 0
	newScore = 0

	Runtime:addEventListener("touch", touchScreen)

	city1_1.enterFrame = scrollCity
	Runtime:addEventListener("enterFrame", city1_1)

	city1_2.enterFrame = scrollCity
	Runtime:addEventListener("enterFrame", city1_2)

	city2_1.enterFrame = scrollCity
	Runtime:addEventListener("enterFrame", city2_1)

	city2_2.enterFrame = scrollCity
	Runtime:addEventListener("enterFrame", city2_2)
	
	topPipe1.enterFrame = movePipes
	Runtime:addEventListener("enterFrame", topPipe1)
	
	Runtime:addEventListener("collision", onCollision)

end

function scene:exitScene(event)

		Runtime:removeEventListener("touch", touchScreen)
		Runtime:removeEventListener("enterFrame", city1_1)
		Runtime:removeEventListener("enterFrame", city1_2)
		Runtime:removeEventListener("enterFrame", city2_1)
		Runtime:removeEventListener("enterFrame", city2_2)
		Runtime:removeEventListener("enterFrame", topPipe1)
		Runtime:removeEventListener("enterFrame", topPipe2)
		Runtime:removeEventListener("enterFrame", topPipe3)
		Runtime:removeEventListener("enterFrame", topPipe4)
		Runtime:removeEventListener("collision", onCollision)
		
end

function scene:destroyScene(event)

end


scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene