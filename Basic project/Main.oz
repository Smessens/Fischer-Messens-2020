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
	Position3
	ID1
	ID2
	ID3

	Color
	PlayerList
	PortList
	PlayerPositon
	PlayRound
	TestPlayer
	LauchgameTurn
	Playturn
	ExplosionMine
	ExplosionMissile
	InitiatePlayers
	MakePortList


	%listMine				% A implémenter

in

		fun {MakePortList List}
				case List
						of H|T then H.port|{MakePortList T}
						[] H then H.port
				end
		end

		%nom et couleur sont pas encore alz % cette fonction est dégueulasse
		fun {Color Num}
				if Num == 1 then red
				else
						if Num == 2 then blue
						else green
						end
				end
		end

    %nom et couleur sont pas encore alz
    proc {InitiatePlayers TempList AccId}
					local PosTemp in
					{System.show TempList}
					{System.show tempList}

							 case TempList
									of H|T then
													{Send H.port initPosition(id(id:AccId color:{Color AccId} name:basicAI) PosTemp)}
													{Wait PosTemp}
													{Send GUI_port initPlayer(id(id:AccId color:{Color AccId} name:basicAI) PosTemp)}
													{InitiatePlayers T AccId+1}
									[] H then
													{Send H.port initPosition(id(id:AccId color:{Color AccId} name:basicAI) PosTemp)}
													{Wait PosTemp}
													{Send GUI_port initPlayer(id(id:AccId color:{Color AccId} name:basicAI) PosTemp)}
								  else skip
							 end
					end
		end

		%Deal with explosion and damage
		proc {ExplosionMine PositionExp player} %Attention pas de diff mine et missile
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
					[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(PlayerList.2.id LifeLeft)}
					else skip
				end

				{Send  PlayerList.1.port sayMissileExplode(PlayerList.2.id PositionExp MessageMine2)}
				case MessageMine2
					of nil then skip
					[]sayDeath(?ID) then Death=true
					[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(PlayerList.1.id LifeLeft)}
					else skip
				end
				end
		end

		%play turn by turn
		fun {Playturn Player Item Round}

					%placed func here so can use State
					proc {ExplosionMissile PositionExp Target} %Attention pas de diff mine et missile
							local MineTemp MessageMissile Death in
								{Send  Target.port sayMissileExplode(Player.id PositionExp MessageMissile)}
								{Wait MessageMissile}
								case MessageMissile
									of nil then skip
									[]sayDeath(ID) then {Send GUI_port removePlayer(ID)}
									[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(ID LifeLeft)} % send only to GUI , have to send to everybody
									else skip
								end
							end
					end

					{Delay 100}    %juste pour less tests c'est plus visible a virer
					if Round==0 then {Send Player.port dive()} end %required by consigne
					{System.show Player.id}
					local DirTemp PosTemp ItemTemp FireTemp MineTemp MessageDeath IdTarget PosTarget IdTargetSon PosTargetSon MessageMine Death in
							%Player choose to move
							{System.show waiting_psotemp}
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
												 []	drone(_ _ )		       then {Send  (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  sayPassingDrone(FireTemp IdTarget PosTarget)} 	{System.show drone} 	{System.show PosTarget} {Send  Player.port sayAnswerDrone(FireTemp IdTarget PosTarget)}%pssitargert answertarget
												 [] sonar 							 then {Send  (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  sayPassingSonar(IdTargetSon PosTargetSon)}{Send  Player.port sayAnswerSonar(IdTargetSon PosTargetSon)}
												 else {System.show rieeeennn}
										end


										{System.show FireTemp}
										{System.show endfireitemmmmmmmmmmmmmmmmm}
										{Send Player.port isDead(Death)}
										{Wait Death}


										if (Death \= true) then
												%allow player to detonate mine
												{System.show Player.id}
												{Send Player.port fireMine(Player.id MineTemp)}
												{Wait MineTemp}
												{System.show detonateminem}
												if MineTemp \= null then
																								{System.show explosion_mine}
																								{ExplosionMissile MineTemp}
																								{Send GUI_port removeMine(Player.id MineTemp)}
																								end
				  					end
							else
								{Send (if Player.id==1 then PlayerList.2.port else PlayerList.1.port end)  saySurface(Player.id)}
								{Send Player.port dive()}
								{Send GUI_port surface(Player.id)}

							end % si en surface passe son tour
							{System.show premesssagedeath}
							{Send Player.port isDead(MessageDeath)}
							{System.show ppostmesssagedeath}

							{Wait MessageDeath}
							{System.show MessageDeath}

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
	ID2=id(id:2 color:blue name:basicAI)
	ID3=id(id:3 color:green name:basicAI)



	PlayerList=player(port:{PlayerManager.playerGenerator player1 red 1} id:ID1 color:red kind:player1 item:_)|player(port:{PlayerManager.playerGenerator player2 blue 2} id:ID2 color:blue kind:player2 item_)|player(port:{PlayerManager.playerGenerator player3 green 3} id:ID3 color:green kind:player3 item:_)
  PortList={MakePortList PlayerList}

	{System.show player1_Info}

  {InitiatePlayers PlayerList 1}

	%Lance le jeux
	{System.show done}
	{Delay 3000}%time to load GUI
	%{System.show {LauchgameTurn 0}}
	{System.show 'Game will be terminated in 10 sec'}%
  {Delay 10000}
	{System.show 'Prank je sais pas comment quitter'}%
	%{Exit GUI_port}

	%quitter le programme
end
