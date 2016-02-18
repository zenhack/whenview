import WhenView.Stage1.Parser (entries)
import WhenView.Stage1.Serializer (calTokens)
import Text.ParserCombinators.Parsec (runParser)
import WhenView.Stage2.Parser (years)
import WhenView.Html as H
import Text.Blaze.Html.Renderer.Pretty (renderHtml)
import System.Process (readProcess)
import System.Environment (getArgs)
import Options.Applicative hiding (runParser)
import qualified Options.Applicative as A
import Options.Applicative.Types (ArgPolicy(AllowOpts))
import Control.Monad.Trans (liftIO)

data Args = Args { stdin    :: Bool
                 , browser  :: String
                 , whenArgs :: [String]
                 }

argParser :: A.Parser Args
argParser = Args
    <$> switch (long "stdin" <> help "Read from stdin")
    <*> strOption
        ( long "browser"
       <> short 'b'
       <> value "xdg-open"
       <> metavar "BROWSER"
       <> help "The browser to invoke"
        )
    <*> (many $ argument str (metavar "WHEN_ARGS..."))

main = do
    argSpec <- execParser $ info argParser (progDesc "Render when calendars as html")
    contents <- if stdin argSpec then
            getContents
        else
            readProcess "when" ("--noheader":whenArgs argSpec) ""
    let ents = runParser entries () "stdin" contents
    let toks = fmap calTokens ents
    let ast = fmap (runParser years () "tokens") toks
    case ast of
        Right (Right result) ->
            putStrLn $ renderHtml $ calendarPage result
        Right (Left err) -> print err
        Left err -> print err
