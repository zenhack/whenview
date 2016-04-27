{-# LANGUAGE OverloadedStrings #-}
module WhenView.Html where

import Control.Monad (forM_, mapM_)
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)
import Data.String (fromString)
import Text.Blaze.Html5 ((!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import qualified Data.Hourglass as Hourglass
import Data.Hourglass(WeekDay(..), TimeOfDay(..), Hours(..), Minutes(..))
import Data.Time (formatTime,defaultTimeLocale)
import qualified Data.Time as T
import WhenView.Data

-- | Convert from Hourglass's TimeOfDay to Data.Time's TimeOfDay. Should
-- investigate further, but Hourglass doesn't seem to have a function for
-- formatting these nicely, and Data.Time looks to be missing some of the
-- other nice stuff we need.
convertTimeOfDay :: TimeOfDay -> T.TimeOfDay
convertTimeOfDay tod = T.TimeOfDay
    (fromIntegral hour)
    (fromIntegral min)
    (fromIntegral sec)
  where
    (Hours hour)  = todHour tod
    (Minutes min) = todMin tod
    (Hourglass.Seconds sec) = todSec tod

-- | Display the time of day as a string
formatTimeOfDay :: TimeOfDay -> String
formatTimeOfDay = formatTime defaultTimeLocale "%H:%M" . convertTimeOfDay

fromItem :: (Maybe TimeOfDay, String) -> H.Html
fromItem (Nothing, s) = H.toHtml s
fromItem (Just t, s) = H.toHtml (formatTimeOfDay t ++ ": " ++ s)

fromMaybeDay :: Maybe Day -> H.Html
fromMaybeDay Nothing = H.td ""
fromMaybeDay (Just (Day date items)) = H.td $ H.div $ do
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

calendarPage :: String -> [Year] -> H.Html
calendarPage style years = H.docTypeHtml $ do
    H.head $ do
        H.meta ! A.charset "utf-8"
        H.title "When calendar"
        H.style "td { vertical-align: top; border: 1px solid; }"
        H.link ! A.rel "stylesheet" ! A.href (fromString style)
    H.body $ mapM_ fromYear years
