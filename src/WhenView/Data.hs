module WhenView.Data (Timestamp(..)) where

import Data.Hourglass (Date, TimeOfDay)
import qualified Data.Hourglass as H

data Timestamp = Timestamp { date      :: Date
                           , timeOfDay :: Maybe TimeOfDay
                           } deriving(Show)

data Day = Day Int [(Maybe TimeOfDay, String)] deriving(Show)
data Week = Week [Day] deriving(Show)
data Month = Month H.Month [Day] [Day] [Day] deriving(Show)
