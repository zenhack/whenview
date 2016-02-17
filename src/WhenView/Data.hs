module WhenView.Data
    ( Entry(..)
    , Timestamp(..)
    , Token(..)
    , Year(..)
    , Month(..)
    , Week(..)
    , Day(..)
    ) where

import Data.Hourglass (Date, TimeOfDay)
import qualified Data.Hourglass as H

data Timestamp = Timestamp { date      :: Date
                           , timeOfDay :: Maybe TimeOfDay
                           } deriving(Show)

data Entry = Entry { timestamp   :: Timestamp
                   , description :: String
                   } deriving(Show)

data Token = TYear Int
           | TMonth H.Month
           | TWeek
           | TDay H.WeekDay
           | TItem (Maybe TimeOfDay) String
           deriving(Eq, Show)

data Year = Year Int [Month] deriving(Show)
data Month = Month H.Month [Week] deriving(Show)
data Week = Week [Day] deriving(Show)
data Day = Day H.WeekDay [(Maybe TimeOfDay, String)] deriving(Show)
