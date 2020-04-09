functor
import
    Input at 'Input.ozf'
    Browser(browse:Browse)
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

   fun{InitPosition ?ID ?Position}
       {Browse 1}
    end

    fun{Move ?ID ?Position ?Direction}
       {Browse 1}
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
        PlayerState = player(id:id(id:ID
                                   color:Color
				   name:"Player1")
			           pos:_
                                   path:_
                                   immersed:_
                                   life:_
                                   loadMine:_
                                   nbMine:_
                                   mineList:_
                                   loadMissile:_
                                   nbMissile:_
                                   loadDrone:_
                                   nbDrone:_
                                   loadSonar:_
                                   nbSonar:_)
        {NewPort Stream Port}
        thread
            {TreatStream Stream PlayerState}
        end
        Port
    end

    proc {TreatStream Stream State}
       case Stream of nil then skip
       [] initPosition(?ID ?Position)|T then {InitPosition ID Position}
	  {TreatStream T State}
       [] move(?ID ?Position ?Direction)|T then {Move ID Position Direction}
	  {TreatStream T State}
       [] dive|T then {Dive State}
	  {TreatStream T State}
       [] chargeItem(?ID ?KindItem)|T then {ChargeItem ID KindItem}
	  {TreatStream T State}
       [] fireItem(?ID ?KindFire)|T then {FireItem ID KindFire}
	  {TreatStream T State}
       [] fireMine(?ID ?Mine)|T then {FireMine ID Mine}
	  {TreatStream T State}
       [] isDead(?Answer)|T then {IsDead Answer}
	  {TreatStream T State}
       [] sayMove(ID Direction)|T then {SayMove ID Direction}
	  {TreatStream T State}
       [] saySurface(ID)|T then {SaySurface ID}
	  {TreatStream T State}
       [] sayCharge(ID KindItem)|T then {SayCharge ID KindItem}
	  {TreatStream T State}
       [] sayMinePlaced(ID)|T then {SayMinePlaced ID}
	  {TreatStream T State}
       [] sayMissileExplode(ID Position ?Message)|T then {SayMissileExplode ID Position Message}
	  {TreatStream T State}
       [] sayMineExplode(ID Position ?Message)|T then {SayMineExplode ID Position Message}
	  {TreatStream T State}
       [] sayPassingDrone(Drone ?ID ?Answer)|T then {SayPassingDrone Drone ID Answer}
	  {TreatStream T State}
       [] sayAnswerDrone(Drone ID Answer)|T then {SayAnswerDrone Drone ID Answer}
	  {TreatStream T State}
       [] sayPassingSonar(?ID ?Answer)|T then {SayPassingSonar ID Answer}
	  {TreatStream T State}
       [] sayAnswerSonar(ID Answer)|T then {SayAnswerSonar ID Answer}
	  {TreatStream T State}
       [] sayDeath(ID)|T then {SayDeath ID}
	  {TreatStream T State}
       [] sayDamageTaken(ID Damage LifeLeft)|T then {SayDamageTaken ID Damage LifeLeft}
	  {TreatStream T State}
       end
    end







end
