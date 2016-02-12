import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import Text.ParserCombinators.Parsec (runParser)

main = do
    contents <- getContents
    let ret = runParser entries () "stdin" contents
    print (fmap calTokens ret)
