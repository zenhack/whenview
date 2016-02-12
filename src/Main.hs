import WhenView.Parser
import Text.ParserCombinators.Parsec (runParser)

main = do
    contents <- getContents
    let ret = runParser entries () "stdin" contents
    print ret
