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
import qualified Data.Map.Strict as M

data Timestamp = Timestamp { date      :: Date
                           , timeOfDay :: Maybe TimeOfDay
                           } deriving(Show)

data Entry = Entry { timestamp   :: Timestamp
                   , description :: String
                   } deriving(Show)

data Token = TYear Int
           | TMonth H.Month
           | TWeek
           | TDay Date
           | TItem (Maybe TimeOfDay) String
           deriving(Eq, Show)

data Year = Year Int (M.Map H.Month Month) deriving(Show)
data Month = Month [Week] deriving(Show)
data Week = Week (M.Map H.WeekDay Day) deriving(Show)
data Day = Day Date [(Maybe TimeOfDay, String)] deriving(Show)
