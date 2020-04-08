functor
import
    Input at 'Input.ozf'
    Browser(browse:Browse)
export
    portPlayer:StartPlayer
define
    StartPlayer
    TreatStream
in

    proc{TreatStream Stream} % as as many parameters as you want
        {Browse "Hello World"}
    end
    fun{StartPlayer Color ID}
        Stream
        Port
    in
        {NewPort Stream Port}
        thread
            {TreatStream Stream}
        end
        Port
    end
end
