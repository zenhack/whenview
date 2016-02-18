module WhenView.CliArgs (Args(..), parseArgs) where

import Options.Applicative hiding(Args)

data Args = Args { stdin    :: Bool
                 , browser  :: String
                 , whenArgs :: [String]
                 }

argParser :: Parser Args
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


parseArgs :: IO Args
parseArgs = execParser $ info argParser (progDesc "Render when calendars as html")
