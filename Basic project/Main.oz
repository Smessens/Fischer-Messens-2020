functor
import
	GUI at 'GUI.ozf'
	Input at 'Input.ozf'
	PlayerManager at 'PlayerManager.ozf'
	System

define

	GUI_port
	List
	Position1
	Position2
	ID1
	ID2
	PlayerList
	PlayerPositon



	proc {Lauchgame}
				{System.show yoooo}
				local PosTemp DirTemp in
					{Send PlayerList.1 move(ID1 PosTemp DirTemp)}
					{Wait DirTemp}
					{Wait PosTemp}
					{System.show yoooo}

					{System.show DirTemp}
				end

	end


in


GUI_port = {GUI.portWindow}
{Send GUI_port buildWindow}

PlayerList={PlayerManager.playerGenerator player1 red ID1} |{PlayerManager.playerGenerator player2 blue ID2}



{System.show gui}

{System.show player1_Info}
ID1=id(id:1 color:red name:s)
{Send PlayerList.1 initPosition(ID1 Position1)}
{Wait Position1}
{Send GUI_port initPlayer(ID1 Position1)}



{System.show player2_Info}
ID2=id(id:2 color:blue name:fuckoz)
{Send PlayerList.2 initPosition(ID2 Position2)}
{Wait Position2}
{Send GUI_port initPlayer(ID2 Position2)}




{System.show done}
{Lauchgame}

end
