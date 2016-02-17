module WhenView.Html where

import Control.Monad (forM_, mapM_)
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)
import qualified Text.Blaze.Html5 as H
import qualified Data.Hourglass as Hourglass
import Data.Hourglass(WeekDay(..), TimeOfDay(..), Hours(..), Minutes(..))
import WhenView.Data

-- Display a time of day as a string like 18:04. XXX: there must be a way to do
-- this in the hourglass package, but I'm not finding it at the moment.
-- This is also sloppy as heck; it'll display 18:04 as 18:4 for example.
formatTimeOfDay :: TimeOfDay -> String
formatTimeOfDay tod = let (Hours h, Minutes m) = (todHour tod, todMin tod) in
    (show h) ++ ":" ++ (show m)

fromItem :: (Maybe TimeOfDay, String) -> H.Html
fromItem (Nothing, s) = H.toHtml s
fromItem (Just t, s) = H.toHtml (formatTimeOfDay t ++ ": " ++ s)

fromMaybeDay :: Maybe Day -> H.Html
fromMaybeDay Nothing = H.td $ H.toHtml ""
fromMaybeDay (Just (Day date items)) = H.td $ do
    H.p $ H.toHtml $ show (Hourglass.dateDay date)
    H.ul $ forM_ items (\item -> H.li $ fromItem item)

fromWeek :: Week -> H.Html
fromWeek (Week days) = H.tr $
    let days' = [M.lookup day days | day <- [Sunday .. Saturday]]
    in mapM_ fromMaybeDay days'

fromMonth :: Hourglass.Month -> Month -> H.Html
fromMonth mon (Month weeks) = do
    H.h2 $ H.toHtml (show mon)
    H.table $ do
        H.tr $ forM_ [Sunday .. Saturday] (\day ->
            H.th $ H.toHtml (show day))
        mapM_ fromWeek weeks

fromYear :: Year -> H.Html
fromYear (Year year months) = do
    H.h1 $ H.toHtml (show year)
    mapM_ (uncurry fromMonth) (M.toList months)

calendarPage :: [Year] -> H.Html
calendarPage years = H.docTypeHtml $ H.html $ do
    H.head $ H.title (H.toHtml "When calendar")
    H.body $ mapM_ fromYear years
