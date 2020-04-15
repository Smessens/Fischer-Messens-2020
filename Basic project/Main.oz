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



in


GUI_port = {GUI.portWindow}
{Send GUI_port buildWindow}

{System.show gui}



{System.show playerlisst}
ID1=id(id:1 color:red name:_)
Position1=pt(x:1 y:1)
{Send {PlayerManager.playerGenerator player1 red ID1} initPosition(ID1 Position1)}
{Send GUI_port initPlayer(ID1 Position1)}

{System.show playerlisst}

ID2=id(id:2 color:blue name:fuckoz)
Position2=pt(x:2 y:2)
{Send {PlayerManager.playerGenerator player2 blue ID2} initPosition(ID2 Position2)}
{Send GUI_port initPlayer(ID2 Position2)}



{System.show done}

end
