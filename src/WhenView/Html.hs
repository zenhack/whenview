module WhenView.Html where

import Control.Monad (forM_, mapM_)
import qualified Text.Blaze.Html5 as H
import WhenView.Data

fromDay :: Day -> H.Html
fromDay (Day _ items) = H.td $ do
    H.ul $ forM_ items (\item ->
        H.li (H.toHtml $ show item))

fromWeek :: Week -> H.Html
fromWeek (Week days) = H.tr $ mapM_ fromDay days

fromMonth :: Month -> H.Html
fromMonth (Month mon weeks) = do
    H.h2 $ H.toHtml (show mon)
    H.table $ mapM_ fromWeek weeks

fromYear :: Year -> H.Html
fromYear (Year year months) = do
    H.h1 $ H.toHtml (show year)
    mapM_ fromMonth months

calendarPage :: [Year] -> H.Html
calendarPage years = H.docTypeHtml $ H.html $ do
    H.head $ H.title (H.toHtml "When calendar")
    H.body $ mapM_ fromYear years
