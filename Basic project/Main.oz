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
	ExplosionMine
	ExplosionMissile


in

		%Deal with explosion and damage
		proc {ExplosionMine PositionExp} %Attention pas de diff mine et missile
				local MineTemp MessageMine1 MessageMine2 Death in
				{Send  PlayerList.1.port sayMineExplode(PlayerList.1.id PositionExp MessageMine1)}
				case MessageMine1
					of nil then skip
					[]sayDeath(ID) then Death=true
					[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(PlayerList.1.id LifeLeft)}
					else skip
				end

				{Send  PlayerList.1.port sayMineExplode(PlayerList.2.id PositionExp MessageMine2)}
				case MessageMine2
					of nil then skip
					[]sayDeath(?ID) then Death=true
					[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(PlayerList.2.id LifeLeft)}
					else skip
				end
				end
		end

		%Deal with explosion and damage
		proc {ExplosionMissile PositionExp} %Attention pas de diff mine et missile
				local MineTemp MessageMine1 MessageMine2 Death in
				{Send  PlayerList.1.port sayMissileExplode(PlayerList.1.id PositionExp MessageMine1)}
				case MessageMine1
					of nil then skip
					[]sayDeath(ID) then Death=true
					[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(PlayerList.1.id LifeLeft)}
					else skip
				end

				{Send  PlayerList.1.port sayMissileExplode(PlayerList.2.id PositionExp MessageMine2)}
				case MessageMine2
					of nil then skip
					[]sayDeath(?ID) then Death=true
					[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(PlayerList.2.id LifeLeft)}
					else skip
				end
				end
		end

		%play turn by turn
		fun {Playturn Player Item Round}

					{Delay 100}    %juste pour less tests c'est plus visible a virer
					if Round==0 then {Send Player.port dive()} end %required by consigne
					{System.show Player.id}
					local DirTemp PosTemp ItemTemp FireTemp MineTemp MessageDeath MessageMine Death in
							%Player choose to move
							{Send Player.port move(Player.id PosTemp DirTemp)}
							{Wait PosTemp}
							{System.show waiting_psotemp}
							{Wait DirTemp}
							{Send GUI_port movePlayer(Player.id PosTemp)}
							{System.show move_done}

						  if PosTemp \= surface then {Send (if Player.id==1 then PlayerList.1.port else PlayerList.2.port end)  sayMove(Player.id DirTemp)}  %add broadcast

									%allow player to charge FireItem
									{Send Player.port chargeItem(Player.id ItemTemp)}
									{Wait ItemTemp}
									{System.show chargeitem}
									if ItemTemp \= null then {Send (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  sayCharge(Player.id ItemTemp)} end %add broadcast

										%allow player to fire Item
										{Send Player.port fireItem(Player.id FireTemp)}
										{Wait FireTemp}
										case FireTemp
										     of missile(pt(x:_ y:_)) then {ExplosionMissile FireTemp.1}
												 [] mine(pt(x:_ y:_))    then {Send GUI_port putMine(Player.id FireTemp.1)}
												 []	drone(_ _ )		       then {System.show droooooonnne}
												 [] sonar 							 then {System.show sonaaeeeeeer}
												 else {System.show rieeeennn}
										end

										%if Death == true then

										{System.show FireTemp}
										{System.show endfireitemmmmmmmmmmmmmmmmm}


										%allow player to detonate mine
										{Send Player.port fireMine(Player.id MineTemp)}
										{Wait MineTemp}
										if MineTemp \= null then
																						{ExplosionMissile MineTemp}
																						{Send GUI_port removeMine(Player.id MineTemp)}
																						end
								%	end
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
		fun {LauchgameTurn Round} %rajouter sayDeath au cas ou il est mort pendant le tour de l'autre
				{System.show round}
				{System.show Round}
				if ({Playturn PlayerList.1 null Round}) then
																										{Send GUI_port removePlayer(ID1)}
																										win2
				else
					if {Playturn PlayerList.2 null Round} then
																										{Send GUI_port removePlayer(ID2)}
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

	{System.show playerlisst}

	ID1=id(id:1 color:red name:basicAI)
	ID2=id(id:2 color:blue name:fishy)
	PlayerList=player(port:{PlayerManager.playerGenerator player1 red 1} id:ID1 color:red kind:player1 item:_)|player(port:{PlayerManager.playerGenerator player2 blue 2} id:ID2 color:blue kind:player2 item_)

	{System.show player1_Info}

	{Send PlayerList.1.port initPosition(ID1 Position1)}
	{Wait Position1}
	{System.show Position1.x}
	{System.show Position1.y}
	{Send GUI_port initPlayer(ID1 Position1)}


	{System.show player2_Info}
	{Send PlayerList.2.port initPosition(ID2 Position2)} %id.id pas la meme qu'avec le truc du prof
	{System.show player2_dooone}
	{Wait Position2}
	{System.show player2_dooone}
	{Send GUI_port initPlayer(ID2 Position2)}


	%Lance le jeux
	{System.show done}
	{Delay 3000}%time to load GUI
	{System.show {LauchgameTurn 0}}
end
