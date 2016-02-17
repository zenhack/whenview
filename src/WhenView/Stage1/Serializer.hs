module WhenView.Stage1.Serializer (calTokens) where

import WhenView.Data
import Data.Hourglass (Date, TimeOfDay)
import qualified Data.Hourglass as H

oneDay = H.Period 0 0 1

allDaysFrom day = day:(allDaysFrom $ day `H.dateAddPeriod` oneDay)

calTokens :: [Entry] -> [Token]
calTokens (e:es) = let
        d = (date $ timestamp e)
        weekStart = getWeekStart d
    in
    [ TYear (H.dateYear weekStart)
    , TMonth (H.dateMonth weekStart)
    , TWeek
    , TDay weekStart
    ] ++ calTokens' (allDaysFrom weekStart) (e:es)

calTokens' _ [] = []
calTokens' (d:ds) (e:es) = let t = (date $ timestamp e) in
    if t == d then
        TItem (timeOfDay $ timestamp e) (description e):(calTokens' (d:ds) es)
    else
        datePrefix d ++ (calTokens' ds (e:es))
  where
    datePrefix d = let d' = d `H.dateAddPeriod` oneDay in
        (singleIf
            (TYear (H.dateYear d'))
            (H.dateMonth d' == H.January && H.dateDay d' == 1)) ++
        (singleIf
            (TMonth (H.dateMonth $ d' `H.dateAddPeriod` oneDay))
            (H.dateDay d' == 1)) ++
        (singleIf
            TWeek
            (H.getWeekDay d' == H.Sunday || H.dateDay d' == 1)) ++
        [TDay d']
    singleIf token condition = if condition then [token] else []


-- assumption: (fromEnum Sunday == 0). TODO verify.
getWeekStart :: Date -> Date
getWeekStart d = let period = H.Period 0 0 (-(fromEnum $ H.getWeekDay d)) in
    d `H.dateAddPeriod` period
