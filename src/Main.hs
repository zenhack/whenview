import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import Text.ParserCombinators.Parsec (runParser)
import WhenView.Stage2.Parser (months)

main = do
    contents <- getContents
    let ents = runParser entries () "stdin" contents
    let toks = fmap calTokens ents
    let mons = fmap (runParser months () "tokens") toks
    print mons
