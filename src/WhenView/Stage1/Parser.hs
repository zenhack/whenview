module WhenView.Stage1.Parser (entries) where

import Text.ParserCombinators.Parsec hiding (token)
import Data.Hourglass
import WhenView.Data (Timestamp(..), Entry(..))
import Control.Monad (unless)

-- TODO: These are (german) internationalized names.
-- We probably want to standardize on the POSIX/C locale
-- or something.
months :: [(String, Month)]
months = [ "Jan"
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
         ] `zip` [January .. December]



pYear :: Parser Int
pYear = token $ read <$> count 4 digit

pMonth :: Parser Month
pMonth = token $ do
    name <- choice [try $ string m | (m, _) <- months]
    let (Just ret) = lookup name months
    return ret

pDay :: Parser Int
pDay = token $ read <$> many1 digit

pTimeOfDay :: Parser TimeOfDay
pTimeOfDay = token $ do
    hour <- num
    unless (hour < 24) (pzero <?> "Hour must be < 24")
    char ':'
    min <- num
    unless (min < 60) (pzero <?> "Minute must be < 60")
    return $ TimeOfDay (Hours hour)
                       (Minutes min)
                       (Seconds 0)
                       (NanoSeconds 0)
 where
    num = read <$> count 2 digit

token :: Parser a -> Parser a
token p = p <* spaces

pDate :: Parser Date
pDate = Date <$> pYear <*> pMonth <*> pDay

pTimestamp :: Parser Timestamp
pTimestamp = Timestamp <$> pDate <*> optionMaybe pTimeOfDay

entry :: Parser Entry
entry = do
    token $ many1 letter
    when <- pTimestamp
    what <- many1 entrySafe
    return $ Entry when what
  where
    entrySafe = (noneOf "\n") <|> (try (string "\n ") *> entrySafe)

entries :: Parser [Entry]
entries = entry `sepEndBy` (char '\n')
