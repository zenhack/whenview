import WhenView.CliArgs
import WhenView.Process (process)
import System.Process (readProcess)

main = do
    argSpec  <- parseArgs
    input <- if stdin argSpec then
            getContents
        else
            readProcess "when" ("--noheader":whenArgs argSpec) ""
    case process input of
        Right output -> putStrLn output
        Left err -> print err
