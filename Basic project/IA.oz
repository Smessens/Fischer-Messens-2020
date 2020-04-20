functor
import
   Input at 'Input.ozf'
define
   IsIsland
   IsValidPathEnemy
   Where
   TournerMap
   SayMove
   SayAnswerDrone
   RemoveDrone
   SayAnswerSonar
   RemoveSonar
in
   
   %State=player(IDEnemy(potPos:_ path:_ life:_))    
   fun{IsIsland L X Y} %déjà présent dans player.oz
      local IsIsland2 in
	 fun{IsIsland2 M A}
	    if A==1 then M.1
	    else {IsIsland2 M.2 A-1}
	    end
	 end
	 {IsIsland2 {IsIsland2 L X} Y}
      end
   end

   %Pour voir si la position est dans la map et dans l'eau
   fun{IsValidPathEnemy E} 
      local X Y in
	 pt(x:X y:Y)=E
	 (X >= 1 andthen X =< Input.nRow andthen Y >= 1 andthen Y =< Input.nColumn) andthen {IsIsland Input.map X Y} == 0
      end
   end

   % Cette fonction sert pour savoir si oui ou non la Direction est possible à la position pt(x:X y:Y) sur la Input.map
   fun{Where Direction X Y}
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
   %fct à faire tourner au début, génère tous les points où il y a pas d'ile sur la map
   fun{TournerMap State IDEnemy}
      local PotPos TournerMap2 in
	 fun {TournerMap2 X Y}
	    if X>Input.nRow andthen Y>Input.nColumn then
	       {Record.adjoin State player(IDEnemy(potPos:PotPos))}
	    elseif X>Input.nRow then {TournerMap2 1 Y+1}
	    else
	       if {IsIsland Input.map X Y}==true then
		  {Append PotPos pt(x:X y:Y)}
		  {TournerMap2 X+1 Y}
	       else
		  {TournerMap2 X+1 Y}
	       end
	    end
	 end
	 {TournerMap2 1 1}
      end
   end

   fun {SayMove Direction State IDEnemy}
      local List Point X Y SayMove2 in
	 List=State.IDEnemy.potPos
	 fun{SayMove2 L}
	    case List of nil then nil
	    [] H|T then
	       X=H.x
	       Y=H.y
	       if {Where Direction X Y}==true then
		  Point|{SayMove2 T}
	       else
		  {SayMove2 T}
	       end
	    end
	 end
	 {Record.adjoin State player(IDEnemy(potPos:{SayMove2 List}))}
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

   fun{SayAnswerDrone Drone IDEnemy Answer State}
      local Xd Yd in
	 if Drone==drone(row Xd) andthen Answer==false then
	    {Record.adjoin State player(IDEnemy(potPos:{RemoveDrone State.IDEnemy.potPos Xd 2}))}
	 elseif Drone==drone(column Yd) andthen Answer==false then
	    {Record.adjoin State player(IDEnemy(potPos:{RemoveDrone State.IDEnemy.potPos Yd 4}))}
	 elseif Drone==drone(row Xd) andthen Answer==true then
	    {Record.adjoin State player(IDEnemy(potPos:{RemoveDrone State.IDEnemy.potPos Xd 1}))}
	 elseif Drone==drone(column Yd) andthen Answer==true then
	    {Record.adjoin State player(IDEnemy(potPos:{RemoveDrone State.IDEnemy.potPos Yd 3}))}
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

   fun{SayAnswerSonar IDEnemy Answer State}
      {Record.adjoin State player(IDEnemy(potPos:{RemoveSonar State.IDEnemy.potPos Answer.x Answer.y}))}
   end
   
   
	    
   
      

   {Browse 1}
end

	    
	    
	 

   
				  
   
   