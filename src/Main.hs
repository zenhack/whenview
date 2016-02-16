import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import Text.ParserCombinators.Parsec (runParser)
import WhenView.Stage2.Parser (months)
import WhenView.Html as H
import Text.Blaze.Renderer.Pretty (renderHtml)
import Control.Monad (mapM_)

main = do
    contents <- getContents
    let ents = runParser entries () "stdin" contents
    let toks = fmap calTokens ents
    let ast = fmap (runParser months () "tokens") toks
    case ast of
        Right (Right result) -> mapM_ (putStrLn . renderHtml) (map H.fromMonth result)
        Right (Left err) -> print err
        Left err -> print err
