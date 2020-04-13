functor
import
	GUI at 'GUI.ozf'
	Input at 'Input.ozf'
	PlayerManager at 'PlayerManager.ozf'
	Main at 'Main.ozf'
	Browser(browse:Browse)
	System

define
	GUI_port
	CreatePlayer
	portPlayer1
	portPlayer2
	Position


	proc {CreatePlayer}
			portPlayer1={PlayerManager.playerGenerator 0 red 0}
			portPlayer2={PlayerManager.playerGenerator 0 blue 1}
	end


	proc {InitPlayer Player}
		local PlayerID Position in
			{Send Player.port initPosition(PlayerID Position)}

			{Wait PlayerID}
			{Wait Position}
			{Send GUI_port initPlayer(PlayerID Position)}
		end
	end

in

%%	{System.show 0}

	GUI_port = {GUI.portWindow}
	{System.show 5}

	{Send GUI_port buildWindow}

	{System.show 0}

	{Main.CreatePlayer}

	{System.show 31}

	{Main.InitPlayer}
	Position=pt(x:1 y:1)
  {GUI.initPlayer 0 Position}
	{System.show 32}

end
