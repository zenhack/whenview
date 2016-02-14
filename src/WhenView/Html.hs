module WhenView.Html where

import Control.Monad (forM, mapM)
import qualified Text.Blaze.Html5 as H
import WhenView.Data

fromDay :: Day -> H.Html
fromDay (Day _ items) = H.td $ do
    H.ul $ forM items (\item ->
        H.li (H.toHtml $ show item))

fromWeek :: Week -> H.Html
fromWeek (Week days) = H.tr $ mapM fromDay days
