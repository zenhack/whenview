module WhenView.Html where

import Control.Monad (forM_, mapM_)
import Data.Map.Strict as M
import qualified Text.Blaze.Html5 as H
import qualified Data.Hourglass as Hourglass
import Data.Hourglass(WeekDay(..))
import WhenView.Data

fromDay :: Day -> H.Html
fromDay (Day _ items) = H.td $
    H.ul $ forM_ items (\item ->
        H.li (H.toHtml $ show item))

fromWeek :: Week -> H.Html
fromWeek (Week days) = H.tr $ mapM_ fromDay days

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
