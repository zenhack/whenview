module WhenView.Stage2.Parser
    ( years
    ) where

import Text.ParserCombinators.Parsec
import Data.Hourglass as H
import WhenView.Data

import qualified Data.Map.Strict as M

data TokenType = YearT | MonthT | WeekT | DayT | ItemT deriving(Show, Eq)

typeOfToken :: Token -> TokenType
typeOfToken t = case t of
    (TYear _) -> YearT
    (TMonth _) -> MonthT
    TWeek -> WeekT
    (TDay _) -> DayT
    (TItem _ _) -> ItemT

pToken ty = try $ do
    tok <- anyToken
    if typeOfToken tok == ty then
        return tok
    else
        pzero <?> show ty

pDay = do
    (TDay d)  <- pToken DayT
    items <- many (pToken ItemT)
    return $ Day d [(when, what) | TItem when what <- items]
pWeek = do
    pToken WeekT
    days <- many pDay
    return $ Week $ M.fromList [(H.getWeekDay date, day)
                                | day@(Day date _) <- days]
pMonth = do
    (TMonth m) <- pToken MonthT
    weeks <- many pWeek
    return (m, Month weeks)
pYear = do
    (TYear y) <- pToken YearT
    (Year y . M.fromList) <$> many pMonth

years = many pYear
