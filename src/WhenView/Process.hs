module WhenView.Process (process) where

import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import WhenView.Stage2.Parser (years)
import WhenView.I18n (Months)
import Text.ParserCombinators.Parsec (runParser, ParseError)
import WhenView.Html (calendarPage)
import Text.Blaze.Html.Renderer.Pretty (renderHtml)

process :: Months -> String -> Either ParseError String
process months input =
    let
        ents = runParser (entries months) () "stdin" input
        toks = fmap calTokens ents
        ast = fmap (runParser years () "tokens") toks
    in
    case ast of
        Right (Right result) ->
            Right $ renderHtml $ calendarPage result
        Right (Left err) -> Left err
        Left err -> Left err
