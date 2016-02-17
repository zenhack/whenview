import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import Text.ParserCombinators.Parsec (runParser)
import WhenView.Stage2.Parser (years)
import WhenView.Html as H
import Text.Blaze.Html.Renderer.Pretty (renderHtml)

main = do
    contents <- getContents
    let ents = runParser entries () "stdin" contents
    let toks = fmap calTokens ents
    let ast = fmap (runParser years () "tokens") toks
    case ast of
        Right (Right result) ->
            putStrLn $ renderHtml $ calendarPage result
        Right (Left err) -> print err
        Left err -> print err
