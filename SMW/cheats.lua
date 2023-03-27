local hotkeys = {
  powerUp =      "C",
  powerDown =    "V",
  flingRandom =  "B", -- Flings the player in a random direction and speed,
  itemBoxUp =    "period", -- Changes the contents of the item box
  itemBoxDown =  "comma", -- Changes the contents of the item box
  invincibility = "I", -- Toggles invincibility
  toggleWater =  "N", -- Toggles if the current stage is a water level
  infiniteTime = "M", -- Toggles unlimited time for a stage
  pSpeed =       "L", -- Toggles infinite p speed
  enemyChaos =   "P", -- If enabled, a random speed and direction is applied to every sprite every frame
  flingForward = "H" -- Makes the player go a random amount up and to the right
}

local lastKeys = input.get()

function keyPress(key)
  return (input.get()[key] and not lastKeys[key])
end


local invincibility = 0
local infiniteTime = false
local enemyChaos = false

local powerupNum = memory.readbyte(0x7E0019)
local itemboxNum = memory.readbyte(0x7E0DC2)

function flingPlayer()
  memory.writebyte(0x7E007B,math.random(0,255))
  memory.writebyte(0x7E007D,math.random(0,255))
end
function marioPos(x,y)
  --memory.writebyte(0x7E007F, memory.readbyte(0x7E007F)+x)
  memory.writebyte(0x7E00D1, memory.readbyte(0x7E00D1)+10)
end
function powerUp(x)
  memory.writebyte(0x7E0019, memory.readbyte(0x7E0019)+x)
  print('Changed power up to ')
  print(memory.readbyte(0x7E0019))
  powerupNum = memory.readbyte(0x7E0019)
end
function itemBox(x)
  memory.writebyte(0x7E0DC2,itemboxNum+x)
  itemboxNum = memory.readbyte(0x7E0DC2)
end



gui.register(function()
  if (keyPress(hotkeys.powerUp)) then
      powerUp(1)
  end
  if (keyPress(hotkeys.powerDown)) then
      powerUp(-1)
  end
  if (keyPress(hotkeys.flingRandom)) then
      flingPlayer()
  end
  if (keyPress(hotkeys.itemBoxUp)) then
      itemBox(1)
  end
  if (keyPress(hotkeys.itemBoxDown)) then
      itemBox(-1)
  end
  if (keyPress(hotkeys.invincibility)) then
      if (invincibility == 1) then
        invincibility = 0
        print("Invincibility off")
      elseif (invincibility == 0) then
        invincibility = 1
        powerupNum = memory.readbyte(0x7E0019)
        print("Invincibility on")
      end
  end
  if (keyPress(hotkeys.toggleWater)) then
    if (memory.readbyte(0x7E0085) == 1) then
      memory.writebyte(0x7E0085,0)
      print("Water off")
    else
      memory.writebyte(0x7E0085,1)
      print("Water on")
    end
  end
  if (keyPress(hotkeys.infiniteTime)) then
    infiniteTime = not infiniteTime
    if (infiniteTime) then
      print("Infinite time on")
    else
      print("Infinite time off")
    end
  end
  if (keyPress(hotkeys.pSpeed)) then
    infinitePSpeed = not infinitePSpeed
    if (infinitePSpeed) then
      print("Infinite P speed on")
    else
      print("Infinite P speed off")
    end
  end
  if (keyPress(hotkeys.enemyChaos)) then
      enemyChaos = not enemyChaos
      if (enemyChaos) then
        print("Enemy chaos on")
      else
        print("Enemy chaos off")
      end
  end
  if (keyPress(hotkeys.flingForward)) then
    memory.writebyte(0x7E007B,math.random(0,0x80))
    memory.writebyte(0x7E007D,math.random(0x80,255))
  end
  if (input.get()["T"]) then
    pSwitchToggle = not pSwitchToggle
    if (pSwitchToggle) then
      print("P switch on")
    else
      print("P switch off")
    end
  end

  lastKeys = input.get()

  if (infiniteTime) then
    memory.writebyte(0x7E0F31,9)
  end
  if (invinciblity == 1) then
    memory.writebyte(0x7E0019,powerupNum)
  end
  if (enemyChaos) then
    --for i,j in pairs({a=0x7E00D8,b=0x7E00D9,c=0x7E00DA,d=0x7E00DB,e=0x7E00DC,f=0x7E00DD,g=0x7E00DE,h=0x7E00DF,i=0x7E00E0,j=0x7E00E1,k=0x7E00E2,l=0x7E00E3,m=0x7e00E4,n=0x7E00E5,o=0x7E00E6,p=0x7E00E7,q=0x7E00E8,r=0x7E00E9,s=0x7E00EA,t=0x7E00EB,u=0x7E00EC,v=0x7E00ED,w=0x7E00EF}) do
    --  memory.writebyte(j,memory.readbyte(j)+math.random(-10,10))
    --end
    for i,j in pairs({a=1,b=2,c=3,d=4,e=5,f=6,g=7,h=8,i=9,j=10,k=11,l=12,m=13,n=14,o=15,p=16,q=17,r=18,s=19,t=20,u=21,v=22,w=23,x=24}) do
      memory.writebyte(0x7E00A9+j,memory.readbyte(0x7E00A9+j)+math.random(-10,10))
    end
  end
  if (infinitePSpeed) then
    memory.writebyte(0x7E13E4,125)
  end
  if (pSwitchToggle) then
    memory.writebyte(0x7E14AD,50)
  end
end)
