functor
import
   Input at 'Input.ozf'
   Browser(browse:Browse)
   Player at 'Player.ozf'
export
   portPlayer:StartPlayer
define
   StartPlayer
   TreatStream
   InitPosition
   Move
   Dive
   ChargeItem
   FireItem
   FireMine
   IsDead
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
in

   

   fun{Move ?ID ?Position ?Direction}

      %PlayerState.id=ID
      %case Direction of east then pt(x:PlayerState.pos.x y:PlayerState.pos.y+1)
      %[] south then pt(x:PlayerState.pos.x+1 y:PlayerState.pos.y)
      %[] west then pt(x:PlayerState.pos.x y:PlayerState.pos.y-1)
      %[] north then pt(x:PlayerState.pos.x-1 y:PlayerState.pos.y)
      %[] surface then PlayerState.immersed=true
      {Browse 1}



   end
   %Je suppose qu'il n'existe aucune colonne avec que des 1
   fun {TrouverMap L}
      fun {TrouverMap2 L1 X}
	 case L1 of L1.1.1==0 then pt(x:X y:0)
	 else {TrouverMap L1.2 X+1}
	 end
      end
      {TrouverMap2 L 0}
   end
   

   fun{Dive State}
      {Browse 1}
   end

   fun{ChargeItem ?ID ?KindItem}
      {Browse 1}
   end

   fun{FireItem ?ID ?KindFire}
      {Browse 1}
   end

   fun{FireMine ?ID ?Mine}
      {Browse 1}
   end

   fun{IsDead ?Answer}
      {Browse 1}
   end

   fun{SayMove ID Direction}
      {Browse 1}
   end

   fun{SaySurface ID}
      {Browse 1}
   end

   fun{SayCharge ID KindItem}
      {Browse 1}
   end

   fun{SayMinePlaced ID}
      {Browse 1}
   end

   fun{SayMissileExplode ID Position ?Message}
      {Browse 1}
   end

   fun{SayMineExplode ID Position ?Message}
      {Browse 1}
   end

   fun{SayPassingDrone Drone ?ID ?Answer}
      {Browse 1}
   end

   fun{SayAnswerDrone Drone ID Answer}
      {Browse 1}
   end

   fun{SayPassingSonar ?ID ?Answer}
      {Browse 1}
   end

   fun{SayAnswerSonar ID Answer}
      {Browse 1}
   end

   fun{SayDeath ID}
      {Browse 1}
   end

   fun{SayDamageTaken ID Damage LifeLeft}
      {Browse 1}
   end

   fun{StartPlayer Color ID}
      Stream
      Port
      PlayerState
   in
      %immersed pour savoir si il est en surface ou pas
      PlayerState = player(id:ID color:Color path:_ pos:_ immersed:_)
      {NewPort Stream Port}
      thread
	 {TreatStream Stream PlayerState}
      end
      Port
   end

   proc {TreatStream Stream State}
      case Stream of nil then skip
      [] initPosition(?ID ?Position)|T then
	 ID=State.id
	 L=Input.map
	 Position={TrouverMap L}
	 local Newstate in
	    Newstate={Record.adjoin State player(path:Position|nil)}
	    {TreatStream T Newstate}
	 end
      [] move(?ID ?Position ?Direction)|T then {Move ID Position Direction  0}
	 {TreatStream T State}
      [] dive|T then {Dive State 0}
	 {TreatStream T State}
      [] chargeItem(?ID ?KindItem)|T then {ChargeItem ID KindItem 0}
	 {TreatStream T State}
      [] fireItem(?ID ?KindFire)|T then {FireItem ID KindFire 0}
	 {TreatStream T State}
      [] fireMine(?ID ?Mine)|T then {FireMine ID Mine 0}
	 {TreatStream T State}
      [] isDead(?Answer)|T then {IsDead Answer 0}
	 {TreatStream T State}
      [] sayMove(ID Direction)|T then {SayMove ID Direction 0}
	 {TreatStream T State}
      [] saySurface(ID)|T then {SaySurface ID 0}
	 {TreatStream T State}
      [] sayCharge(ID KindItem)|T then {SayCharge ID KindItem 0}
	 {TreatStream T State}
      [] sayMinePlaced(ID)|T then {SayMinePlaced ID 0}
	 {TreatStream T State}
      [] sayMissileExplode(ID Position ?Message)|T then {SayMissileExplode ID Position Message 0}
	 {TreatStream T State}
      [] sayMineExplode(ID Position ?Message)|T then {SayMineExplode ID Position Message 0}
	 {TreatStream T State}
      [] sayPassingDrone(Drone ?ID ?Answer)|T then {SayPassingDrone Drone ID Answer 0}
	 {TreatStream T State}
      [] sayAnswerDrone(Drone ID Answer)|T then {SayAnswerDrone Drone ID Answer 0}
	 {TreatStream T State}
      [] sayPassingSonar(?ID ?Answer)|T then {SayPassingSonar ID Answer 0}
	 {TreatStream T State}
      [] sayAnswerSonar(ID Answer)|T then {SayAnswerSonar ID Answer 0}
	 {TreatStream T State}
      [] sayDeath(ID)|T then {SayDeath ID 0}
	 {TreatStream T State}
      [] sayDamageTaken(ID Damage LifeLeft)|T then {SayDamageTaken ID Damage LifeLeft 0}
	 {TreatStream T State}
      end
   end

end
