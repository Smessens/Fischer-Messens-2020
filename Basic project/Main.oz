functor
import
	GUI at 'GUI.ozf'

define

player
GUI_port

fun {CreatePlayer}
	port:{PlayerManager.playerGenerator 1 1 0}
end

in


GUI_port = {GUI.portWindow}
{Send GUI_port buildWindow}


{CreatePlayer}


end
