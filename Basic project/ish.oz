functor

import

Browser(browse:Browse)


define
{Browse "Hello World"}

end





fun{StartPlayer Color ID} % reinsert <p1> <p2>
    Stream
    Port
    Position
in
    {NewPort Stream Port}  % reinsert <p1> <p2>
    thread
        {TreatStream Stream}
        Position =pt(x:1 y:1)

        {initPosition 0 Position}
    end
    Port
end


GUI_port
PlayerList % A list of player records



%%%%% Procedures
fun {GeneratePlayers}
	fun {Aux PlayerList ColorList IDNum}
		if IDNum > Input.nbPlayer then /*return*/ nil
		else
			% Note : {PlayerManager.playerGenerator Kind Color IDNum} returns a new player port
			case PlayerList#ColorList of (H1|T1)#(H2|T2) then
			if (Input.isTurnByTurn) then
/*TURN BY TURN*/	/*return*/ player(port:{PlayerManager.playerGenerator H1 H2 IDNum} turnToWait:0 alive:true)|{Aux T1 T2 IDNum+1}
				else
/*SIMULTANEOUS*/	/*return*/ player(port:{PlayerManager.playerGenerator H1 H2 IDNum})|{Aux T1 T2 IDNum+1}
				end
			end
		end
	end
in
	/*return*/ {Aux Input.players Input.colors 1}
end

% Asks the Player port to choose a starting position
proc {InitPlayer Player}
	local PlayerID Position in
		{Send Player.port initPosition(PlayerID Position)}
		{Wait PlayerID}
		{Wait Position}
		{Print {Util.stringID PlayerID}#' initialized at position ('#Position.x#','#Position.y#')'}
		{Send GUI_port initPlayer(PlayerID Position)}
	end
end
