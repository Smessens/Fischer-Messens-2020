functor
import
	GUI at 'GUI.ozf'
	Input at 'Input.ozf'
	PlayerManager at 'PlayerManager.ozf'
	Main at 'Main.ozf'
	Browser(browse:Browse)

define
	GUI_port
	CreatePlayer
	Player
	Position

	proc {CreatePlayer}
			Player={PlayerManager.playerGenerator 0 red 0}
	end


	proc {InitPlayer Player}
		local PlayerID Position in
			{Send Player.port initPosition(PlayerID Position)}
			{Browse "wesh"}
			{Wait PlayerID}
			{Wait Position}
			{Send GUI_port initPlayer(PlayerID Position)}
		end
	end
in


	{Main.CreatePlayer}

	GUI_port = {GUI.portWindow}
	{Send GUI_port buildWindow}


	{Main.InitPlayer}
	Position=pt(x:1 y:1)
  {GUI.initPlayer 0 Position}

end
