functor
import
	GUI at 'GUI.ozf'
	Input at 'Input.ozf'
	PlayerManager at 'PlayerManager.ozf'
	System

define

	Maman
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
	InitiatePlayers
	MakePortList


	%listMine				% A implémenter

in

		fun {MakePortList List}
				case List
						of nil then nil
						[] H|T then H.port|{MakePortList T}
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
									of nil then skip
									[] H|T then
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



		%play turn by turn
		fun {Playturn Player Round}

          local PosMine PosMissile ExplosionMissile  ExplosionMine in
					%placed func here so can use State
					proc {ExplosionMissile Target} %Attention pas de diff mine et missile
							local MessageMissile Death in
								{Send  Target.port sayMissileExplode(Player.id PosMissile MessageMissile)}
								{Wait MessageMissile}
								case MessageMissile
									of nil then skip
									[]sayDeath(ID) then {Send GUI_port removePlayer(ID)}
									[]sayDamageTaken(ID Damage ?LifeLeft) then {Send GUI_port lifeUpdate(ID LifeLeft)}    % send only to GUI , have to send to everybody
									else skip
								end
							end
					end

					proc {ExplosionMine Target} %Attention pas de diff mine et missile
							local MessageMine Death in
								{Send  Target.port sayMineExplode(Player.id PosMine MessageMine)}
								{Wait MessageMine}
								case MessageMine
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
						%	{System.show PlayerList}

						  %if PosTemp \= surface then {List.forAll PortList proc {$ PortA}  {System.show surface_wesh} {Send PortA sayMove(Player.id DirTemp)}  end}
							if PosTemp \= surface then  {System.show surface_wesh} % {List.forAll 1|2|3|nil proc {$ A}  {System.show A}  end}

							{System.show postemp_transmitted}

									%allow player to charge FireItem
									{Send Player.port chargeItem(Player.id ItemTemp)}
									{Wait ItemTemp}
									{System.show chargeitem}
									{System.show ItemTemp}
									if ItemTemp \= null then 	{List.forAll PortList proc {$ A} {System.show messsage} {Send A sayCharge(Player.id ItemTemp)} end} end
									{System.show messsageCharged}

									%allow player to fire Item
									{Send Player.port fireItem(Player.id FireTemp)}
									{Wait FireTemp}
									case FireTemp
									     of missile(pt(x:_ y:_)) then {List.forAll PortList ExplosionMissile}
											 [] mine(pt(x:_ y:_))    then {Send GUI_port putMine(Player.id FireTemp.1)}
											 []	drone(_ _ )		       then {List.forAll PortList proc {$ PortA} local IdTarget PosTarget in {Send PortA sayPassingDrone(FireTemp IdTarget PosTarget)} {Send  Player.port sayAnswerDrone(FireTemp IdTarget PosTarget)} end end}
											 [] sonar 							 then {List.forAll PortList proc {$ PortA} local IdTargetSon PosTargetSon in {Send PortA sayPassingSonar(IdTargetSon PosTargetSon)} {Send  Player.port sayAnswerSonar(IdTargetSon PosTargetSon)} end end}
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
																							{ExplosionMine MineTemp}
																							{Send GUI_port removeMine(Player.id MineTemp)}
											end
			  					end
							else
							  {List.forAll PortList proc {$ A} {Send A  saySurface(Player.id)} end}
								{Send Player.port dive()}
								{Send GUI_port surface(Player.id)}

							end % si en surface passe son tour

							{System.show premessageDeath}
							{Send Player.port isDead(MessageDeath)}
							{Wait MessageDeath}
							{System.show MessageDeath}
							MessageDeath
					end
				end
		end




		%Fonction utile pour le jeux
		proc {LauchgameTurn Round AliveList} %rajouter sayDeath au cas ou il est mort pendant le tour de l'autre
				{System.show round}
				{System.show Round}
				{System.show AliveList}

				local Message in
						case AliveList
										of nil then {System.show 'no player , something went wrong'}
										[] H|T then
																if H==nil then  {LauchgameTurn Round +1 AliveList}
																else
												           if T \= nil then

																					 			{Send H.port isDead(Message)} {Wait Message}
																								if Message==false then if {Playturn H Round}==false then {LauchgameTurn Round AliveList}
																																			 else {LauchgameTurn Round T}
																																			 end
																								else {LauchgameTurn Round T|H}
																								end

																	 else
																	 			{System.show AliveList}
																	 			{System.show winner}
																				{System.show T}
																	 end
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



	PlayerList=player(port:{PlayerManager.playerGenerator player1 red 1} id:ID1 color:red kind:player1 item:_)|player(port:{PlayerManager.playerGenerator player2 blue 2} id:ID2 color:blue kind:player2 item_)|player(port:{PlayerManager.playerGenerator player3 green 3} id:ID3 color:green kind:player3 item:_)|nil
  PortList={MakePortList PlayerList}

	{System.show player1_Info}

  {InitiatePlayers PlayerList 1}

	{System.show premesssage}
%	{System.show PlayerList}

	Maman = 1|2|3|nil

	{List.forAll Maman proc {$ A} {System.show messsage} end}

	{List.forAll PlayerList proc {$ A} {System.show messsage} end}

	%Lance le jeux
	{System.show done}
	{Delay 3000}%time to load GUI
%  {LauchgameTurn 0 PlayerList }
	{System.show 'Game will be terminated in 10 sec'}%
  {Delay 10000}
	{System.show 'Prank je sais pas comment quitter'}%
	%{Exit GUI_port}

	%quitter le programme
end
