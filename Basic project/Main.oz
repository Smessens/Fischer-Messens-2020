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



in


GUI_port = {GUI.portWindow}
{Send GUI_port buildWindow}

{System.show gui}



{System.show playerlisst}

Position1=pt(x:1 y:1)
{Send {PlayerManager.playerGenerator player1 red 1} initPosition(1 Position1)}
{Send GUI_port initPlayer(1 Position1)}

{System.show playerlisst}

Position2=pt(x:2 y:2)
{Send {PlayerManager.playerGenerator player2 blue 2} initPosition(2 Position2)}
{Send GUI_port initPlayer(2 Position2)}



{System.show done}

end /*define*/
