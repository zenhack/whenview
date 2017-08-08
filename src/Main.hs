import WhenView.CliArgs
import WhenView.I18n (getMonthsFor)
import WhenView.Process (process)
import System.Process (readProcess, callProcess)
import System.Environment (getEnv, lookupEnv)
import Control.Monad (join)

main = do
    homeDir <- getEnv "HOME"
    argSpec  <- parseArgs
    months <- getMonthsFor
    input <- if stdin argSpec then
            getContents
        else
            readProcess "when" ("--noheader":whenArgs argSpec) ""
    case process months input of
        Right output -> do
            user <- lookupEnv "USER"
            display <- lookupEnv "DISPLAY"
            let path = join [ "/tmp/whenview."
                            , maybe "" id user
                            , "."
                            , maybe "" id display
                            , ".html"
                            ]
            writeFile path output
            callProcess (browser argSpec) [path]
        Left err -> print err
