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
	PlayRound
	TestPlayer
	LauchgameTurn
	Playturn

in
		fun {Playturn Player Item Round}

					{Delay 500}    %juste pour less tests c'est plus visible a virer
					if Round==0 then {Send Player.port dive()} end %required by consigne

					%if Round==10 then 	{Send GUI_port surface(Player.id)} end %pour test a viere

					local DirTemp PosTemp ItemTemp FireTemp MineTemp MessageDeath MessageMine Death in
							%Player choose to move
							{Send Player.port move(Player.id PosTemp DirTemp)}
							{Wait DirTemp}
							{Wait PosTemp}
							{Send GUI_port movePlayer(Player.id PosTemp)}
						  if PosTemp \= surface then {Send (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  sayMove(Player.id DirTemp)}  %add broadcast

								%allow player to charge FireItem
								{Send Player.port chargeItem(Player.id ItemTemp)}
								{Wait ItemTemp}
								if ItemTemp \= null then {Send (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  sayCharge(Player.id ItemTemp)} end %add broadcast

								%allow player to fire Item
								{Send Player.port fireItem(Player.id FireTemp)}
								{Wait FireTemp}
								if FireTemp \= null then
																		if FireTemp == mine then {Send (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  sayMinePlaced(Player.id)}
																														 		{System.show mIIIIIIIIIIINNNNNNNNNZZZZZZZZ}
																														 		{Delay 10000}
																														 		{Send GUI_port putMine(Player.id PosTemp)}
																															end
																		if FireTemp == missile then {System.show mISSSSSSSSIIIIIILLLLLEEE}
																																{Delay 10000}
																														end
								end
								{System.show FireTemp}
								{System.show yoooooooooooooooooooooooooooo}

%S'occuper des missile
								%allow player to detonate mine

								{Send Player.port fireMine(Player.id MineTemp)}
								{Wait MineTemp}
								if MineTemp \= null then
																				{Send  Player.port sayMineExplode(Player.id MineTemp MessageMine)}
																				case MessageMine % implémenté le suicide
																					of nil then skip
																					[]sayDeath(?ID) then Death=true
																					[]sayDamageTaken(?ID ?Damage ?LifeLeft) then {Send GUI_port lifeUpdate(ID LifeLeft)}
																					else skip
																				end
																				{Send GUI_port removeMine(Player.id MineTemp) }
																				end %add broadcast


							else
								{Send (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  saySurface(Player.id)}
								{Send Player.port dive()}
								{Send GUI_port surface(Player.id)}

							end % si en surface passe son tour
							{Send Player.port isDead(MessageDeath)}
							{Wait MessageDeath}
							MessageDeath
					end
		end


		%Fonction utile pour le jeux
		fun {LauchgameTurn Round}
				{System.show round}
				{System.show Round}
				if ({Playturn PlayerList.1 null Round}) then
																										{Send GUI_port removePlayer(1)}
																										win2
				else
					if {Playturn PlayerList.2 null Round} then
																										{Send GUI_port removePlayer(2)}
																										win1
					else
						if Round<4000 then  {LauchgameTurn Round+1}
						else game_end
						end
					end
				end
		end


	% initialise les players et leur Position ------------
	GUI_port = {GUI.portWindow}
	{Send GUI_port buildWindow}

	ID1=id(id:1 color:red name:basicAI)
	ID2=id(id:2 color:blue name:basicAI)
	PlayerList=player(port:{PlayerManager.playerGenerator player1 red 1} id:ID1 color:red kind:player1 item:_)|player(port:{PlayerManager.playerGenerator player2 blue 2} id:ID2 color:blue kind:player2 item_)

	{System.show gui}
	{System.show player1_Info}

	{Send PlayerList.1.port initPosition(ID1 Position1)}
	{Wait Position1}
	{System.show Position1.x}
	{System.show Position1.y}
	{Send GUI_port initPlayer(ID1 Position1)}


	{System.show player2_Info}
	{Send PlayerList.2.port initPosition(ID2 Position2)}
	{Wait Position2}
	{Send GUI_port initPlayer(ID2 Position2)}


	%Lance le jeux
	{System.show done}
	{Delay 3000}%time to load GUI
	{System.show {LauchgameTurn 0}}
end
