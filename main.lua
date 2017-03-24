local myMod = RegisterMod("Curse",1);
local curseID = Isaac.GetCurseIdByName("Curse of Haste") - 1 -- get ID of Curse of the HASTE
local count = 0;
function myMod:PostCurseEval(Curses)
  if(math.random() < 0.3) then -- Chance of 50% to get the CURSE 
    return Curses | 1 << curseID
  else
    return Curses;
  end
end


function myMod:PostUpdate()
  local jogo = Game(); -- Create the OBJECT GAME
  local p1 = Isaac.GetPlayer(0); -- GET THE PLAYER
  if jogo ~= nil then -- SEE IF THE GAME EXISTS AT LEAST
    curses = jogo:GetLevel():GetCurses(); -- GET ALL GAMES CURSES
    if(curses & 1 << curseID) ~= 0 then -- SEE IF THE CURSE ON THE FLOOR IS THE HASTE
      local room = jogo:GetRoom() -- GET EVERY ROOM ON THE FLOOR
      if(room:IsFirstVisit() or room:HasTriggerPressurePlates())then -- IF THE FIRST TIME IN THE ROOM ORHAS A BUTTON
        count = room:GetFrameCount() -- COUNT THE TIME IN EVERY ROOM
        if(room:GetAliveBossesCount()>0 or room:GetAliveEnemiesCount()>0) and (count >= 2700) then 
          p1:TakeDamage(1,DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player),0);-- DEAL DAMAGE TO THE PLAYER 1
        end
      end
    end
  end
end

function myMod:TimerScreen() -- SHOW THE TIMER ON THE SCREEN
  local game = Game();
  local room = game:GetRoom();
  curses = game:GetLevel():GetCurses(); -- GET ALL GAMES CURSES
  if(curses & 1 << curseID) ~= 0 then -- IF IS CURSE OF THE HASTE
    T = 90 - room:GetFrameCount()/30; -- GET TIME ON THE ROOM
    if T< 0 then T = 0 end -- if the time is negative only show ZERO
    Isaac.RenderText(string.format("Time: %.f",T),290,10,255,255,255,255); -- SHOW THE TIMER
  else
    Isaac.RenderText("",0,0,0,0,0,255) -- SHOWS NOTHING
  end
end
myMod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL,myMod.PostCurseEval);
myMod:AddCallback(ModCallbacks.MC_POST_UPDATE,myMod.PostUpdate);
myMod:AddCallback(ModCallbacks.MC_POST_RENDER,myMod.TimerScreen);