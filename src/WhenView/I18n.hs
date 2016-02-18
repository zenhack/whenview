module WhenView.I18n (getMonthsFor, monthsFor, Months) where

import Data.Hourglass (Month(..))
import System.Environment (lookupEnv)

type Months = [(String, Month)]

englishMonths =
    [ "Jan"
    , "Feb"
    , "Mar"
    , "Apr"
    , "May"
    , "Jun"
    , "Jul"
    , "Aug"
    , "Sep"
    , "Oct"
    , "Nov"
    , "Dec"
    ]

getMonthsFor :: IO Months
getMonthsFor = do
    lang <- lookupEnv "LANG"
    return $ case lang of
        Nothing -> monthsFor "en"
        Just lang' -> monthsFor lang'


monthsFor :: String -> [(String, Month)]
monthsFor lang = monthsFor' lang `zip`  [January .. December]

monthsFor' :: String -> [String]
monthsFor' "POSIX" = englishMonths
monthsFor' "C" = englishMonths
monthsFor' "" = englishMonths
monthsFor' (x:y:_) = case lookup [x, y] months of
    Nothing -> englishMonths
    Just m -> m

months =
    [ ("en", englishMonths)
    , ("de",
        [ "Jan"
        , "Feb"
        , "Mar"
        , "Apr"
        , "Mai"
        , "Jun"
        , "Jul"
        , "Aug"
        , "Sep"
        , "Okt"
        , "Nov"
        , "Dez"
        ])
    ]
