module WhenView.Process (process) where

import Control.Monad (join)
import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import WhenView.Stage2.Parser (years)
import WhenView.I18n (Months)
import Text.ParserCombinators.Parsec (runParser, ParseError)
import WhenView.Html (calendarPage)
import Text.Blaze.Html.Renderer.Pretty (renderHtml)

process :: Months -> String -> Either ParseError String
process months input =
    renderHtml . calendarPage <$> join
        (runParser years () "tokens" <$>
         calTokens <$>
         runParser (entries months) () "stdin" input)
