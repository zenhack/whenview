module WhenView.Stage1.Serializer (calTokens) where

import WhenView.Data
import Data.Hourglass (Date, TimeOfDay)
import qualified Data.Hourglass as H

calTokens :: [Entry] -> [Token]
calTokens (e:es) = let d = (date $ timestamp e) in
    [TMonth (H.dateMonth d), TWeek] ++
        calTokens' (getWeekStart (date $ timestamp e)) (e:es)

calTokens' _ [] = []
calTokens' cur (e:es) = let t = (timestamp e) in
        if (date t) == cur then
            TItem (timeOfDay t) (description e):(calTokens' cur es)
        else let
            next     = cur `H.dateAddPeriod` (H.Period 0 0 1)
            monCur   = H.dateMonth cur
            monNext  = H.dateMonth next
            weekCur  = H.getWeekDay cur
            weekNext = H.getWeekDay next
            monEvent = if monCur /= monNext then [TMonth monNext] else []
            weekEvent = if weekNext == H.Sunday then [TWeek] else []
        in
            monEvent ++ weekEvent ++ [TDay weekNext] ++ calTokens' next (e:es)

-- assumption: (fromEnum Sunday == 0). TODO verify.
getWeekStart :: Date -> Date
getWeekStart d = let period = H.Period 0 0 (-(fromEnum $ H.getWeekDay d)) in
    d `H.dateAddPeriod` period
