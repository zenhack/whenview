module WhenView.Stage2.Parser
    ( months
    ) where

import Text.ParserCombinators.Parsec
import WhenView.Data

data TokenType = MonthT | WeekT | DayT | ItemT deriving(Eq)

typeOfToken :: Token -> TokenType
typeOfToken t = case t of
    (TMonth _) -> MonthT
    TWeek -> WeekT
    (TDay _) -> DayT
    (TItem _ _) -> ItemT

pSatisfy p = do
    tok <- anyToken
    if p tok then
        return tok
    else
        pzero -- TODO: Error message

pItemT  = pTokenType ItemT  <?> "Expected ItemT"
pDayT   = pTokenType DayT   <?> "Expected DayT"
pWeekT  = pTokenType WeekT  <?> "Exepcted WeekT"
pMonthT = pTokenType MonthT <?> "Expected MonthT"

pTokenType ty = pSatisfy (\t -> typeOfToken t == ty)

pDay = do
    (TDay d)  <- pDayT
    items <- many pItemT
    return $ Day d [(when, what) | TItem when what <- items]
pWeek = do
    pTokenType WeekT
    Week <$> many pDay
pMonth = do
    (TMonth m) <- pMonthT
    Month m <$> (many pWeek)

months = many pMonth
