module WhenView.Stage2.Parser
    ( months
    ) where

import Text.ParserCombinators.Parsec
import WhenView.Data

import Control.Monad (void)

data TokenType = MonthT | WeekT | DayT | ItemT deriving(Show, Eq)

typeOfToken :: Token -> TokenType
typeOfToken t = case t of
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
    Week <$> many pDay
pMonth = do
    (TMonth m) <- pToken MonthT
    Month m <$> (many pWeek)

months = many pMonth
