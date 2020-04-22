functor
import
   Input at 'Input.ozf'
   Browser(browse:Browse)
   Player at 'Player.ozf'
   OS
   System
export
   portPlayer:StartPlayer
define
   StartPlayer
   TreatStream
   Move
   ChargeItem
   FireItem
   FireMine
   SayMove
   SaySurface
   SayCharge
   SayMinePlaced
   SayMissileExplode
   SayMineExplode
   SayPassingDrone
   SayAnswerDrone
   SayPassingSonar
   SayAnswerSonar
   SayDeath
   SayDamageTaken

   %fcts ajoutées
   IsIsland
   Histo
   IsValidPath
   Random
   RandomPosition
   FindInList
   RemoveFromList
   ListPosDir
   GetNewPos
   Where
   TournerMap
   IsValidPathEnemy
   ValidItem
   RemoveDrone
   RemoveSonar
in

   fun{IsIsland L X Y} %testé et approuvé
      local IsIsland2 in
	 fun{IsIsland2 M A}
	    if A==1 then M.1
	    else {IsIsland2 M.2 A-1}
	    end
	 end
	 {IsIsland2 {IsIsland2 L X} Y}
      end
   end

   fun{Histo L E} %testé et approuvé
      case L of nil then true
      [] H|T then
	 if H==E then false
	 else {Histo T E}
	 end
      end
   end

    %Pour voir si la position est dans la map et dans l'eau
   fun{IsValidPathEnemy E} %validée
      local X Y in
	 pt(x:X y:Y)=E
	 (X >= 1 andthen X =< Input.nRow andthen Y >= 1 andthen Y =< Input.nColumn) andthen {IsIsland Input.map X Y} == 0
      end
   end

   fun{IsValidPath L E} %testé et approuvé
      local X Y in
	 pt(x:X y:Y)=E
	 (X >= 1 andthen X =< Input.nRow andthen Y >= 1 andthen Y =< Input.nColumn) andthen {IsIsland Input.map X Y} == 0 andthen {Histo L E}
      end
   end

   fun {Random N}
      {OS.rand} mod N + 1
   end

   %Je suppose qu'il n'existe aucune colonne avec que des 1
   fun{RandomPosition M}
      local X Y in
	 X={Random Input.nRow}
	 Y={Random Input.nColumn}
	 if {IsIsland M X Y}==0 then pt(x:X y:Y)
	 else {RandomPosition M}
	 end
      end
   end

   fun {FindInList L N}
      if N==1 then L.1
      else {FindInList L.2 N-1}
      end
   end

   fun{RemoveFromList L A}
      case L of nil then nil
      [] H|T then
	 if H==A then {RemoveFromList T A}
	 else H|{RemoveFromList T A}
	 end
      end
   end

   % Cette fonction sert pour savoir si oui ou non la Direction est possible à la position pt(x:X y:Y) sur la Input.map
   fun{Where Direction X Y}%validée
      local CandPos in 
	 case Direction of east then CandPos=pt(x:X y:Y+1)
	 [] south then CandPos=pt(x:X+1 y:Y)
	 [] west then CandPos=pt(x:X y:Y-1)
	 [] north then CandPos=pt(x:X-1 y:Y)
	 end
	 if {IsValidPathEnemy CandPos}==false then false
	 else true
	 end
      end
   end

   %Cette fonction permet de créer une liste avec les positions potentielles de l'ennemi IDEnemy
   %fct à faire tourner au début, génère tous les points où il y a pas d'ile sur la map et la retourne sous forme de liste
   %{Record.adjoin State player(id:id(id:IDEnemy(potPos:Acc)))}
   fun{TournerMap K} % testée et approuvée 
      local TournerMap2 in
	 fun {TournerMap2 X Y Acc}
	    if Y>Input.nColumn then
	       Acc
	    elseif X>Input.nRow then {TournerMap2 1 Y+1 Acc}
	    else
	       if {IsIsland Input.map X Y}==0 then
		  {TournerMap2 X+1 Y pt(x:X y:Y)|Acc}
	       else
		  {TournerMap2 X+1 Y Acc}
	       end
	    end
	 end
	 {TournerMap2 K K nil}
      end
   end


   %deal with false path also perfect place for intelligence while move is logisstic
   fun {GetNewPos State}

      local CandPos CandDir ListPosDir in
             % pick at random a path
	 CandDir={FindInList [east south west north surface] {Random 5}}
	 {System.show newcandir}
	 {System.show CandDir}

	 case CandDir of
	    east then        CandPos=pt(x:State.pos.x y:State.pos.y+1)
	 [] south then       CandPos=pt(x:State.pos.x+1 y:State.pos.y)
	 [] west then        CandPos=pt(x:State.pos.x y:State.pos.y-1)
	 [] north then       CandPos=pt(x:State.pos.x-1 y:State.pos.y)
	 [] surface then     CandPos=State.pos
	 end

            %check if pos is valid
	 if ({IsValidPath State.path CandPos}==true) then       %isvalid surface bug?
	    ListPosDir=CandPos|CandDir
	 else
	    if CandDir == surface then %isvalid surface bug?
	       ListPosDir=CandPos|CandDir
	    else
	       {System.show non_valid}
	       {GetNewPos State}
	    end
	 end
      end
   end

   fun{RemoveDrone Li Xi N} %testée et approuvée 
      local Point X Y in 
	 if N==1 then %True et X 
	    case Li of nil then nil
	    []H|T then
	       X=H.x
	       Y=H.y
	       Point=pt(x:X y:Y)
	       if X==Xi then
		  Point|{RemoveDrone T Xi N}
	       else
		  {RemoveDrone T Xi N}
	       end
	    end
	 elseif N==2 then %False et X 
	    case Li of nil then nil
	    []H|T then
	       X=H.x
	       Y=H.y
	       Point=pt(x:X y:Y)
	       if X==Xi then
		  {RemoveDrone T Xi N}
	       else
		  Point|{RemoveDrone T Xi N}
	       end
	    end
	 elseif N==3 then %True et Y
	    case Li of nil then nil
	    []H|T then
	       X=H.x
	       Y=H.y
	       Point=pt(x:X y:Y)
	       if Y==Xi then
		  Point|{RemoveDrone T Xi N}
	       else
		  {RemoveDrone T Xi N}
	       end
	    end
	 else %False et Y
	    case Li of nil then nil
	    []H|T then
	       X=H.x
	       Y=H.y
	       Point=pt(x:X y:Y)
	       if Y==Xi then
		  {RemoveDrone T Xi N}
	       else
		  Point|{RemoveDrone T Xi N}
	       end
	    end
	 end
      end
   end

   %enlève les points qui n'ont ni X ni Y en commun avec sonar
   fun{RemoveSonar L Xs Ys} %testée et approuvée 
      local X Y Point in
	 case L of nil then nil
	 [] H|T then
	    X=H.x
	    Y=H.y
	    Point=pt(x:X y:Y)
	    if X==Xs then
	       Point|{RemoveSonar T Xs Ys}
	    elseif Y==Ys then
	       Point|{RemoveSonar T Xs Ys}
	    else
	       {RemoveSonar T Xs Ys}
	    end
	 end
      end
   end


   fun{Move ?Position ?Direction State}
      {System.show newmove}

      local  ListPosDir  in

	 ListPosDir =  {GetNewPos State}
	 Position=ListPosDir.1
	 Direction=ListPosDir.2

	 if ListPosDir.2 == surface then  %deal with diving
	    {Record.adjoin State player(immersed:false path:Position|nil)}
	 else %no dive
	    {Record.adjoin State player(pos:Position path:Position|State.path)}
	 end


      end
   end

   fun{ChargeItem ?KindItem State}
      {System.show chargeitem}


      local PosItem TempItem in
	 PosItem=[mine missile drone sonar]
	 TempItem={FindInList PosItem {Random 4}}
	 {System.show TempItem}
	 {System.show tempitem}


	 case TempItem of mine then
	    if State.loadMine+1==Input.mine then
	       KindItem=null
	       {Record.adjoin State player(loadMine:0 numberMine:State.numberMine+1)}
	    else
	       KindItem=mine
	       {Record.adjoin State player(loadMine:State.loadMine+1)}
	    end

	 [] missile then
	    if State.loadMissile+1==Input.missile then
	       KindItem=null
	       {Record.adjoin State player(loadMissile:0 numberMissile:State.numberMissile+1)}
	    else
	       KindItem=missile
	       {Record.adjoin State player(loadMissile:State.loadMissile+1)}
	    end

	 [] drone then
	    if State.loadDrone+1==Input.drone then
	       KindItem=null
	       {Record.adjoin State player(loadDrone:0 numberDrone:State.numberDrone+1)}
	    else
	       KindItem=drone
	       {Record.adjoin State player(loadDrone:State.loadDrone+1)}
	    end

	 [] sonar then
	    if State.loadSonar+1==Input.sonar then
	       KindItem=null
	       {Record.adjoin State player(loadSonar:0 numberSonar:State.numberSonar+1)}
	    else
	       KindItem=sonar
	       {Record.adjoin State player(loadSonar:State.loadSonar+1)}

	    end
	 end
      end
   end

   %choisis quelle item a launch , coder IA ici et fireItem fait la logistique
   fun {ValidItem ListFire State}
      {System.show  validitem}


      if ListFire==nil then nil
      else
	 {System.show  ListFire}
	 {System.show  ListFire.1}

	 case ListFire.1 of mine then
	    if State.numberMine>0 then
	       mine|{ValidItem ListFire.2 State}
	    else
	       {ValidItem ListFire.2 State}
	    end

	 [] missile then
	    if State.numberMissile>0 then
	       missile|{ValidItem ListFire.2 State}
	    else
	       {ValidItem ListFire.2 State}
	    end

	 [] drone then
	    if State.numberDrone>0 then
	       drone|{ValidItem ListFire.2 State}
	    else
	       {ValidItem ListFire.2 State}
	    end

	 [] sonar then
	    if State.numberSonar>0 then
	       sonar|{ValidItem ListFire.2 State}

	    else
	       {ValidItem ListFire.2 State}
	    end

	 else       rien|nil
	 end
      end
   end

   fun{FireItem ?KindFire State} % Listfire étrange? version smart buggé donc remplacé par tout con , peut etre trouvée au commit updateplayer du 20/4
      {System.show  fireitem}

      local Fire FireList in


	 Fire={ValidItem [mine missile drone sonar rien]  State}.1
	 {System.show  fireList}

	 case Fire of mine then
	    KindFire=mine(State.pos)
	    {Record.adjoin State player(listMine:KindFire|State.listMine numberMine:State.numberMine-1)}

	 [] missile then
	    KindFire=missile({RandomPosition Input.map})
	    {Record.adjoin State player(numberMissile:State.numberMissile-1)} %enlevé list missile

	 [] drone then
	    KindFire=drone(1:row 2:{Random 8}) % nrow bugged? remplaced by 8 for the time being
	    {Record.adjoin State player(numberDrone:State.numberDrone-1)}

	 [] sonar then
	    KindFire=sonar
	    {Record.adjoin State player(numberSonar:State.numberSonar-1)}

	 else
	    KindFire=null
	    State


	 end
      end

   end

   fun{FireMine ?Mine State}
      {System.show firemine}
      {System.show State.listMine}

      if State.listMine==nil then
	 Mine=null
	 State
      else
	 {System.show fireMine2}
	 Mine=State.listMine.1.1 %first object first argument (which is position)
	 {Record.adjoin State player(listMine:{RemoveFromList State.listMine State.listMine.1})}
      end
   end


   fun {SayMove IDEnemy Direction State}
      local List Point X Y SayMove2 in
	 List=State.ide.potPos
	 fun{SayMove2 L}
	    case List of nil then nil
	    [] H|T then
	       X=H.x
	       Y=H.y
	       Point=pt(x:X y:Y)
	       if {Where Direction X Y}==true then
		  Point|{SayMove2 T}
	       else
		  {SayMove2 T}
	       end
	    end
	 end
	 {Record.adjoin State player(ide:id(potPos:{SayMove2 List}))}
      end
   end

   proc {SaySurface ID}
      {System.show saySurface}
   end

   proc{SayCharge ID KindItem} % proc pcq on retourne rien?
      {System.show sayCharge}
   end

   proc{SayMinePlaced ID}% proc pcq on retourne rien?
      {System.show sayMinePlaced}
   end

   fun{SayMissileExplode ID Position ?Message State}%simon

      if Position.y==State.pos.y andthen Position.x==State.pos.x then
	 if (State.life < 3 )then
	    Message=sayDeath(State.id)
	    {Record.adjoin State player(life:0)}

	 else
	    Message=sayDamageTaken(State.id 2 State.life+2)
	    {Record.adjoin State player(life:State.life-2)}
	 end
      else
	 if (({Number.abs Position.y-State.pos.y}+{Number.abs Position.x-State.pos.x})<2) then
	    if State.life < 2 then
	       Message=sayDeath(State.id)
	       {Record.adjoin State player(life:0)}

	    else
	       Message=sayDamageTaken(State.id 1 State.life+1)
	       {Record.adjoin State player(life:State.life-1)}

	    end
	 else
	    State
	 end
      end
   end

   fun{SayMineExplode ID Position ?Message State}%simon
      if Position.y==State.pos.y andthen Position.x==State.pos.x then
	 if (State.life < 3 )then
	    {Record.adjoin State player(life:0)}
	    Message=sayDeath(State.id)
	 else
	    {Record.adjoin State player(life:State.life-2)}
	    Message=sayDamageTaken(State.id 2 State.life+2)
	 end
      else
	 if (({Number.abs Position.y-State.pos.y}+{Number.abs Position.x-State.pos.x})<2) then
	    if State.life < 2 then
	       {Record.adjoin State player(life:0)}
	       Message=sayDeath(State.id)
	    else
	       {Record.adjoin State player(life:State.life-1)}
	       Message=sayDamageTaken(State.id 1 State.life+1)
	    end
	 else
	    null
	 end
      end
   end

   fun{SayPassingDrone Drone State}
      case Drone of drone(x Xp) then
	 if State.pos.x==Xp then true
	 else false
	 end
      [] drone(y Yp) then
	 if State.pos.y==Yp then true
	 else false
	 end
      else false
      end
   end

   fun{SayAnswerDrone Drone IDEnemy Answer State}
      local Xd Yd in
	 if Drone==drone(row Xd) andthen Answer==false then
	    {Record.adjoin State player(ide:id(potPos:{RemoveDrone State.ide.potPos Xd 2}))}
	 elseif Drone==drone(column Yd) andthen Answer==false then
	    {Record.adjoin State player(ide:id(potPos:{RemoveDrone State.ide.potPos Yd 4}))}
	 elseif Drone==drone(row Xd) andthen Answer==true then
	    {Record.adjoin State player(ide:id(potPos:{RemoveDrone State.ide.potPos Xd 1}))}
	 elseif Drone==drone(column Yd) andthen Answer==true then
	    {Record.adjoin State player(ide:id(potPos:{RemoveDrone State.ide.potPos Yd 3}))}
	 end
      end
   end

   fun{SayPassingSonar State}
      local R C in
	 R={Random 2}
	 if R==1 then
	    C={Random Input.nColumn}
	    if {IsIsland Input.Map State.pos.x C}==0 then
	       pt(x:State.pos.x y:C)
	    else
	       {SayPassingSonar State}
	    end
	 else
	    C={Random Input.nRow}
	    if {IsIsland Input.Map C State.pos.y}==0 then
	       pt(x:C y:State.pos.y)
	    else
	       {SayPassingSonar State}
	    end
	 end
      end
   end

   fun{SayDeath ID} %simon
      {System.show deeeeaaaattthhh}%
   end

   fun{SayDamageTaken ID Damage lifeLeft}
      {Browse 1}
   end

   fun{StartPlayer Color ID}
      Stream
      Port
      PlayerState
   in
      %immersed pour savoir si il est en surface ou pas
      PlayerState = player(id:id(id:ID color:Color name:fishy) ide:id(potPos:{TournerMap 1} life:Input.maxDamage) path:nil pos:nil immersed:false life:Input.maxDamage listMine:nil loadMine:0 numberMine:0 listMissile:nil loadMissile:0 numberMissile:0 loadDrone:0 numberDrone:0 loadSonar:0 numberSonar:0)  % list misssile?
      {NewPort Stream Port}
      thread
	 {System.show start_play}
	 {TreatStream Stream PlayerState}
      end
      Port
   end

   proc {TreatStream Stream State}
      {System.show state}
      {System.show State}

      case Stream of nil then skip
      [] initPosition(?ID ?Position)|T then
	 ID=State.id
	 Position={RandomPosition Input.map}
	 local Newstate in
	    Newstate={Record.adjoin State player(pos:Position path:Position|nil)}
	    {TreatStream T Newstate}
	 end

      [] move(ID ?Position ?Direction)|T then
	 ID=State.id
	 local Newstate in
	    Newstate={Move ?Position ?Direction State}
	    {System.show mooove}
	    {TreatStream T Newstate}
	 end

      [] dive|T then
	 local Newstate in
	    Newstate={Record.adjoin State player(immersed:true)}
	    {TreatStream T Newstate}
	 end

      [] chargeItem(?ID ?KindItem)|T then
	 ID=State.id 
	 local Newstate in
	    Newstate={ChargeItem ?KindItem State}
	    {TreatStream T Newstate}
	 end

      [] fireItem(?ID ?KindFire)|T then
	 ID=State.id
	 local Newstate ListFire in
	    Newstate={FireItem ?KindFire  State}
	    {TreatStream T Newstate}
	 end

      [] fireMine(?ID ?Mine)|T then
	 {System.show fireMine}
	 ID=State.id
	 local Newstate in
	    Newstate={FireMine ?Mine State}
	    {System.show fireMine_done}
	    {TreatStream T Newstate}
	 end

      [] isDead(?Answer)|T then
	 if State.life==0 then Answer=true
	 else Answer=false
	 end
	 {TreatStream T State}

      [] sayMove(ID Direction)|T then
	 local Newstate in
	    Newstate={{SayMove ID Direction State} State}
	    {System.show saymooove_done}
	    {TreatStream T Newstate}
	 end

      [] saySurface(ID)|T then {SaySurface ID}
	 {TreatStream T State}

      [] sayCharge(ID KindItem)|T then {SayCharge ID KindItem}
	 {System.show sayCharge_done}
	 {TreatStream T State}

      [] sayMinePlaced(ID)|T then {SayMinePlaced ID}
	 {TreatStream T State}

      [] sayMissileExplode(ID Position ?Message)|T then %simon
	 local Newstate in
	    Newstate={{SayMissileExplode ID Position ?Message State} State}
	    {TreatStream T Newstate}
	 end

      [] sayMineExplode(ID Position ?Message)|T then %simon
	 local Newstate in
	    Newstate={{SayMineExplode ID Position ?Message State} State}
	    {TreatStream T Newstate}
	 end

      [] sayAnswerDrone(Drone ?ID ?Answer)|T then
	 local Newstate in
	    Newstate={{SayAnswerDrone Drone ID Answer State} State}
	    {TreatStream T Newstate}
	 end
      [] sayPassingDrone(Drone ?ID ?Answer)|T then
	 ID=State.id
	 Answer={SayPassingDrone Drone State}
	 {TreatStream T State}

      [] sayAnswerSonar(ID Answer)|T then
	 local Newstate in
	    Newstate={Record.adjoin State player(ide:id(potPos:{RemoveSonar State.ide.potPos Answer.x Answer.y}))}
	    {TreatStream T Newstate}
	 end
      [] sayPassingSonar(?ID ?Answer)|T then
	 ID=State.id
	 Answer={SayPassingSonar State}
	 {TreatStream T State}

      [] sayDeath(ID)|T then {SayDeath ID 0}
	 {TreatStream T State}

      [] sayDamageTaken(ID Damage lifeLeft)|T then {SayDamageTaken ID Damage lifeLeft 0}
	 {TreatStream T State}

      else
	 {System.show Stream}

      end
   end
end
% enlevé tout les {{...} State } ... smart?
