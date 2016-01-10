import qualified System.Environment as Env (getArgs, getProgName)
import           Jobs

---------------------------------------------
-- constants
---------------------------------------------

verbose :: Bool
verbose = True

---------------------------------------------
-- parser + main program
-- I/O should be done in this section only!
---------------------------------------------

iov :: (String -> IO ()) -> String -> IO ()
iov f s =
    if verbose then
        f s
    else
        return ()

putStrLnV :: String -> IO ()
putStrLnV = iov putStrLn

main :: IO ()
main = do
    prgName <- Env.getProgName
    prgArgs <- Env.getArgs
    let (inputDir,outputDir) = case prgArgs of
            [s,t] -> (s,t) :: (String,String)
            _     -> error ("usage: " ++ prgName ++ " <input-dir> <output-dir>")

    jobsXml <- readFile $ inputDir ++ "/jobs.xml"
    let jobs = listJobs jobsXml
    putStrLnV jobs
