import WhenView.CliArgs
import WhenView.I18n (getMonthsFor)
import WhenView.Process (process)
import System.Process (readProcess, callProcess)
import System.Environment (getEnv)
import System.IO (openTempFile, hPutStr, hClose)

main = do
    homeDir <- getEnv "HOME"
    argSpec  <- parseArgs
    months <- getMonthsFor
    input <- if stdin argSpec then
            getContents
        else
            readProcess "when" ("--noheader":whenArgs argSpec) ""
    case process months input (homeDir ++ "/.when/view.css") of
        Right output -> do
            (path, hdl) <- openTempFile "/tmp" ".html"
            hPutStr hdl output
            hClose hdl
            callProcess (browser argSpec) [path]
            -- TODO: delete the file
        Left err -> print err
