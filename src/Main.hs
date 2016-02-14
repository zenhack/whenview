import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import Text.ParserCombinators.Parsec (runParser)
import WhenView.Stage2.Parser (months)
import WhenView.Html as H

main = do
    contents <- getContents
    let ents = runParser entries () "stdin" contents
    let toks = fmap calTokens ents
    let ast = fmap (runParser months () "tokens") toks
    print ast
