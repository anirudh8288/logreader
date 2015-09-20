{-# LANGUAGE OverloadedStrings #-}
module LogReader.Reader (readExercise) where

import Data.Aeson
import Data.Maybe
import Data.List
import Data.Text (Text)
import Data.Text.Lazy.Encoding
import System.Directory
import System.FilePath
import LogReader.Types
import qualified Data.Text as T
import qualified Data.Text.IO as IO
import qualified Data.String.Conversions as C

-- List folder contents with absolute paths.
folderContent :: Path -> IO ([Path])
folderContent p = do
    dirs <- getDirectoryContents p
    let subDirs = filter (not . flip elem [".", ".."]) $ sort dirs
    fullDirs <- mapM (canonicalizePath . (p </>)) subDirs
    return (fullDirs)

-- Read log file.
readLog :: Path -> IO (Maybe Log)
readLog p = do
    content <- IO.readFile p
    let time = T.pack $ takeFileName p
        decodeEncoded = decode . encodeUtf8 . C.cs
    case decode $ C.cs content :: Maybe [Text] of
         Just ((l:_)) -> return (fmap (Log time) $ decodeEncoded l)
         _            -> return Nothing

-- Load user from logs.
loadUser :: Path -> IO User
loadUser p = do
    files <- folderContent p
    logs <- catMaybes <$> mapM readLog files
    let n = T.pack $ takeFileName p
    return (User n logs)

-- Load task from logs.
loadTask :: Path -> IO Task
loadTask p = do
    userFolders <- folderContent p
    users <- mapM loadUser userFolders
    let n = T.pack $ takeFileName p
    return (Task n users)

-- Read exercise from logs.
readExercise :: Path -> IO Exercise
readExercise p = do
    taskFolders <- folderContent p
    ts <- mapM loadTask taskFolders
    let n = T.pack $ takeFileName p
    return (Exercise n ts)
