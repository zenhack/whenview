module WhenView.Stage1.Parser (entries) where

import Text.ParserCombinators.Parsec hiding (token)
import Data.Hourglass
import WhenView.Data (Timestamp(..), Entry(..))
import Control.Monad (unless)
import WhenView.I18n (Months)


pYear :: Parser Int
pYear = token $ read <$> count 4 digit

pMonth :: Months -> Parser Month
pMonth months = token $ do
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

pDate :: Months -> Parser Date
pDate months = Date <$> pYear <*> pMonth months <*> pDay

pTimestamp :: Months -> Parser Timestamp
pTimestamp months = Timestamp <$> pDate months <*> optionMaybe pTimeOfDay

entry :: Months -> Parser Entry
entry months = do
    token $ many1 letter
    when <- pTimestamp months
    what <- many1 entrySafe
    return $ Entry when what
  where
    entrySafe = noneOf "\n" <|> (try (string "\n ") *> entrySafe)

entries :: Months -> Parser [Entry]
entries months = entry months `sepEndBy` char '\n'
